-- =============================================================================
-- mandelbrot_picture_gen_pipelined.vhd
--
-- Mandelbrot set engine with 3-slot round-robin pipeline scheduler.
--
-- The 3-stage pipelined mandelbrot_iter has a 2-cycle output latency.
-- We keep 3 pixel "slots" in flight simultaneously, issuing one slot per clock:
--
--   Cycle N   : issue slot 0 → stage 1 of iterator
--   Cycle N+1 : issue slot 1 → stage 2 of iterator  (slot 0 in stage 2)
--   Cycle N+2 : issue slot 2 → stage 1 of iterator  (slot 0 result ready!)
--
-- A depth-2 shift register carries the slot ID alongside the data through the
-- pipeline, so the result handler always knows which slot to update.
--
-- Slot lifecycle
--   EMPTY  : freshly retired or not yet started → load next pixel from coord gen
--   ACTIVE : pixel in iteration → keep issuing to iterator each turn
--   DONE   : diverged or hit MAX_ITER → write to BRAM, then EMPTY again
--
-- Fixed-point format  Q2.FRAC_W  (default DATA_W=18, FRAC_W=15)
--   C_re = X0 + x * Dx,  C_im = Y0 + y * Dy
--   (multiplication done in full precision, result sliced)
--
-- BRAM write
--   addr = y * C_BUFFER_WIDTH + x   (fits in C_BRAM_ADDR_BIT_SIZE bits)
--   data = iter_count[6:0]  (saturated at 127 = 2^7-1)
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mandelbrot_picture_gen_pipelined is
	generic (
			C_BUFFER_WIDTH       : integer := 64;
			C_BUFFER_HEIGHT      : integer := 64;
			C_BRAM_ADDR_BIT_SIZE : integer := 12;
			DATA_W               : integer := 18;
			FRAC_W               : integer := 15;
			MAX_ITER             : integer := 100
		);
	port (
		     ClkxCI        : in  std_logic;
		     RstxRANI      : in  std_logic;
		     X0xDI         : in  signed(DATA_W-1 downto 0);
		     Y0xDI         : in  signed(DATA_W-1 downto 0);
		     DxxDI         : in  signed(DATA_W-1 downto 0);
		     DyxDI         : in  signed(DATA_W-1 downto 0);
		     StartxDI      : in  std_logic;
		     BramWrAddrxDO : out std_logic_vector(C_BRAM_ADDR_BIT_SIZE-1 downto 0);
		     BramWrDataxDO : out std_logic_vector(6 downto 0);
		     BramWexSO     : out std_logic_vector(0 downto 0);
		     FrameDonexSO  : out std_logic
	     );
end entity mandelbrot_picture_gen_pipelined;

architecture rtl of mandelbrot_picture_gen_pipelined is

	constant NUM_SLOTS : integer := 3;

	-- Slot
	type slot_state_t is (EMPTY, ACTIVE);

	type slot_t is record
		state : slot_state_t;
		z_re  : signed(DATA_W-1 downto 0);
		z_im  : signed(DATA_W-1 downto 0);
		c_re  : signed(DATA_W-1 downto 0);
		c_im  : signed(DATA_W-1 downto 0);
		x     : integer range 0 to C_BUFFER_WIDTH  - 1;
		y     : integer range 0 to C_BUFFER_HEIGHT - 1;
		iter  : integer range 0 to MAX_ITER;
	end record;

	type slots_t is array (0 to NUM_SLOTS-1) of slot_t;

	-- Engine FSM
	type engine_state_t is (IDLE, FILLING, RUNNING, DRAINING, DONE_ST);

	-- Tag/valid shift register (depth = pipeline latency = 2)
	type tag_pipe_t is array (0 to 2) of integer range 0 to NUM_SLOTS-1;

	-- Signals
	signal eng_state : engine_state_t := IDLE;
	signal slots     : slots_t;

	signal x : integer range 0 to C_BUFFER_WIDTH  - 1 := 0;
	signal y : integer range 0 to C_BUFFER_HEIGHT - 1 := 0;
	signal re : signed(DATA_W-1 downto 0);
	signal im : signed(DATA_W-1 downto 0);

	signal filling_count : integer range 0 to NUM_SLOTS-1 := 0;

	signal tag_pipe : tag_pipe_t   := (others => 0);
	signal valid_pipe : std_logic_vector(NUM_SLOTS-1 downto 0) := (others => '0');

	signal iter_valid_in  : std_logic := '0';
	signal iter_z_re_in   : signed(DATA_W-1 downto 0) := (others => '0');
	signal iter_z_im_in   : signed(DATA_W-1 downto 0) := (others => '0');
	signal iter_c_re_in   : signed(DATA_W-1 downto 0) := (others => '0');
	signal iter_c_im_in   : signed(DATA_W-1 downto 0) := (others => '0');
	signal iter_z_re_out  : signed(DATA_W-1 downto 0);
	signal iter_z_im_out  : signed(DATA_W-1 downto 0);
	signal iter_div_out   : std_logic;
	signal iter_valid_out : std_logic;

	signal bram_addr  : std_logic_vector(C_BRAM_ADDR_BIT_SIZE-1 downto 0) := (others => '0');
	signal bram_data  : std_logic_vector(6 downto 0) := (others => '0');
	signal bram_we    : std_logic := '0';
	signal frame_done : std_logic := '0';

	signal pixels_written : integer range 0 to C_BUFFER_WIDTH * C_BUFFER_HEIGHT := 0;

	signal x0, y0, dx, dy : signed(DATA_W-1 downto 0) := (others => '0');

	component mandelbrot_iter is
		generic (
				DATA_W : integer;
				FRAC_W : integer
			);
		port (
			     clk     : in  std_logic;
			     reset : in std_logic;
			     i_valid : in  std_logic;
			     z_re_n  : in  signed(DATA_W-1 downto 0);
			     z_im_n  : in  signed(DATA_W-1 downto 0);
			     c_re_n  : in  signed(DATA_W-1 downto 0);
			     c_im_n  : in  signed(DATA_W-1 downto 0);
			     z_re_n1 : out signed(DATA_W-1 downto 0);
			     z_im_n1 : out signed(DATA_W-1 downto 0);
			     div     : out std_logic;
			     o_valid : out std_logic
		     );
	end component;

    -- -------------------------------------------------------------------------
    -- Saturate iteration count to 7 bits (max 127)
    -- -------------------------------------------------------------------------
	function sat7 (iter : integer) return std_logic_vector is
	begin
		if iter >= 127 then
			return std_logic_vector(to_unsigned(127, 7));
		else
			return std_logic_vector(to_unsigned(iter, 7));
		end if;
	end function;

begin

    -- =========================================================================
    -- Iterator
    -- =========================================================================
	u_iter : entity work.mandelbrot_iter(pipelined)
	generic map (DATA_W => DATA_W, FRAC_W => FRAC_W)
	port map (
			 clk     => ClkxCI,
			 reset => not RstxRANI,
			 i_valid => iter_valid_in,
			 z_re_n  => iter_z_re_in,
			 z_im_n  => iter_z_im_in,
			 c_re_n  => iter_c_re_in,
			 c_im_n  => iter_c_im_in,
			 z_re_n1 => iter_z_re_out,
			 z_im_n1 => iter_z_im_out,
			 div     => iter_div_out,
			 o_valid => iter_valid_out
		 );

	BramWrAddrxDO <= bram_addr;
	BramWrDataxDO <= bram_data;
	BramWexSO(0)  <= bram_we;
	FrameDonexSO  <= frame_done;

    -- =========================================================================
    -- Main engine process
    -- =========================================================================
	p_engine : process (ClkxCI, RstxRANI)
		variable v_slot    	  : integer range 0 to NUM_SLOTS-1;
		variable v_x              : integer range 0 to C_BUFFER_WIDTH  - 1;
		variable v_y              : integer range 0 to C_BUFFER_HEIGHT  - 1;
		variable v_re             : signed(DATA_W-1 downto 0);
		variable v_im             : signed(DATA_W-1 downto 0);
		variable v_pixels_written : integer range 0 to C_BUFFER_WIDTH * C_BUFFER_HEIGHT := 0;
		variable v_tag_pipe       : tag_pipe_t;
		variable v_valid_pipe     : std_logic_vector(NUM_SLOTS-1 downto 0);
		variable v_slots 	  : slots_t;
		variable v_iter_z_re_in	  : signed(DATA_W-1 downto 0);
		variable v_iter_z_im_in	  : signed(DATA_W-1 downto 0);
		variable v_iter_c_re_in	  : signed(DATA_W-1 downto 0);
		variable v_iter_c_im_in	  : signed(DATA_W-1 downto 0);

		variable v_bram_we	  : std_logic;
		variable v_bram_addr	  : std_logic_vector(BramWrAddrxDO'range);
		variable v_bram_data	  : std_logic_vector(BramWrDataxDO'range);
		variable v_frame_done	  : std_logic;
		variable v_all_issued     : boolean;
		variable v_diverged       : boolean;
		variable v_exhausted      : boolean;
		variable v_pixel_done     : boolean;
		variable v_writing        : boolean;
		variable v_filling_count  : integer range 0 to NUM_SLOTS-1:= 0;
		variable v_state          : engine_state_t;
		variable v_x0 		  : signed(DATA_W-1 downto 0);
		variable v_y0 		  : signed(DATA_W-1 downto 0);
		variable v_dx 		  : signed(DATA_W-1 downto 0);
		variable v_dy 		  : signed(DATA_W-1 downto 0);
	begin
		v_state         := eng_state;
		v_filling_count := filling_count;
		v_x := x;
		v_y := y;
		v_re := re;
		v_im := im;
		v_pixels_written := pixels_written;
		v_tag_pipe := tag_pipe;
		v_valid_pipe := valid_pipe;
		v_iter_z_re_in := (others => '0');
		v_iter_z_im_in := (others => '0');
		v_iter_c_re_in := (others => '0');
		v_iter_c_im_in := (others => '0');

		v_bram_we := '0';
		v_bram_addr := bram_addr;
		v_bram_data := bram_data;
		v_frame_done := '0';
		v_slots := slots;
		v_x0 := x0;
		v_y0 := y0;
		v_dx := dx;
		v_dy := dy;

		if RstxRANI = '0' then
			v_state 	 := IDLE;
			v_x     	 := 0;
			v_y     	 := 0;
			v_re    	 := (others => '0');
			v_im    	 := (others => '0');
			v_pixels_written := 0;
			v_tag_pipe       := (others => 0);
			v_valid_pipe     := (others => '0');
			v_bram_we        := '0';
			v_frame_done     := '0';
			for s in 0 to NUM_SLOTS-1 loop
				v_slots(s).state := EMPTY;
				v_slots(s).iter  := 0;
				v_slots(s).z_re  := (others => '0');
				v_slots(s).z_im  := (others => '0');
				v_slots(s).c_re  := (others => '0');
				v_slots(s).c_im  := (others => '0');
				v_slots(s).x  := 0;
				v_slots(s).y  := 0;
			end loop;

		elsif rising_edge(ClkxCI) then
			v_tag_pipe(2) := v_tag_pipe(1);
			v_tag_pipe(1) := v_tag_pipe(0);
			v_valid_pipe(2) := v_valid_pipe(1);
			v_valid_pipe(1) := v_valid_pipe(0);
			case v_state is
				when IDLE =>
					v_valid_pipe     := (others => '0');
					v_pixels_written := 0;

					if StartxDI = '1' then
						v_state  := FILLING;

						v_x0 := X0xDI;
						v_y0 := Y0xDI;
						v_dx := DxxDI;
						v_dy := DyxDI;
						v_x := 0;
						v_y := 0;
						v_re := v_x0;
						v_im := v_y0;
						for s in 0 to NUM_SLOTS-1 loop
							v_slots(s).state := EMPTY;
							v_slots(s).iter  := 0;
							v_slots(s).z_re  := (others => '0');
							v_slots(s).z_im  := (others => '0');
							v_slots(s).c_re  := (others => '0');
							v_slots(s).c_im  := (others => '0');
							v_slots(s).x     := 0;
							v_slots(s).y     := 0;
						end loop;
					end if;
				when FILLING =>
					v_slots(v_filling_count).z_re  := v_re;
					v_slots(v_filling_count).z_im  := v_im;
					v_slots(v_filling_count).c_re  := to_signed(11633, DATA_W);
					v_slots(v_filling_count).c_im  := to_signed(11633, DATA_W);
					v_slots(v_filling_count).x     := v_x;
					v_slots(v_filling_count).y     := v_y;
					v_slots(v_filling_count).iter  := 0;
					v_slots(v_filling_count).state := ACTIVE;

					v_iter_z_re_in  := v_slots().z_re;
					v_iter_z_im_in  := v_slots().z_im;
					v_iter_c_re_in  := v_slots().c_re;
					v_iter_c_im_in  := v_slots().c_im;
					v_valid_pipe(0) := '1';
					v_tag_pipe(0)   := v_slot;

					-- we assume num slots is always < width so we don't need to check for the width
					v_x := v_x + 1;
					v_re := v_re + v_dx;
					-- Next clock we can already get a result from the first slot, go to running
					if v_filling_count = NUM_SLOTS - 1 then
						v_state := RUNNING;
					else
						v_filling_count := v_filling_count + 1;
					end if;

				when RUNNING => 
					-- Get the result 
					v_slot := v_tag_pipe(2);

					v_diverged  := (iter_div_out = '1');
					v_exhausted := (v_slots(v_slot).iter >= MAX_ITER - 1);
					v_pixel_done := v_diverged or v_exhausted;

					if not v_pixel_done then
						-- Feed the slot back into the input for another iteration
						v_slots(v_slot).z_re := iter_z_re_out;
						v_slots(v_slot).z_im := iter_z_im_out;
						v_slots(v_slot).iter := v_slots(v_slot).iter + 1;
					else
						-- Write the result and fill the free'd slot with the next pixel
						v_bram_addr := std_logic_vector(to_unsigned(v_slots(v_slot).y * C_BUFFER_WIDTH + v_slots(v_slot).x,
										C_BRAM_ADDR_BIT_SIZE));
						if v_diverged then
							v_bram_data := std_logic_vector(to_unsigned(v_slots(v_slot).iter + 1, v_bram_data'length));
						else
							v_bram_data := (others => '0');
						end if;

						v_bram_we := '1';
						v_pixels_written := v_pixels_written + 1;

						-- Fill slot with new pixel
						v_slots(v_slot).z_re  := v_re;
						v_slots(v_slot).z_im  := v_im;
						v_slots(v_slot).c_re  := to_signed(11633, DATA_W);
						v_slots(v_slot).c_im  := to_signed(11633, DATA_W);
						v_slots(v_slot).x     := v_x;
						v_slots(v_slot).y     := v_y;
						v_slots(v_slot).iter  := 0;
						v_slots(v_slot).state := ACTIVE;

						if v_x < C_BUFFER_WIDTH - 1 then
							v_x := v_x + 1;
							v_re := v_re + v_dx;
						else -- EOL
							v_x := 0;
							v_re := v_x0;
							if v_y < C_BUFFER_HEIGHT - 1 then
								v_y := v_y + 1;
								v_im := v_im + v_dy;
							else
								v_y := 0;
								v_state := DRAINING;
							end if;
						end if;
					end if;

					if v_state = DRAINING then
						v_valid_pipe(0) := '0';
					else 
						v_iter_z_re_in  := v_slots(v_slot).z_re;
						v_iter_z_im_in  := v_slots(v_slot).z_im;
						v_iter_c_re_in  := v_slots(v_slot).c_re;
						v_iter_c_im_in  := v_slots(v_slot).c_im;
						v_valid_pipe(0) := '1';
						v_tag_pipe(0)   := v_slot;
					end if;

				when DRAINING => 
					if iter_valid_out then
						v_slot := v_tag_pipe(2);
						v_diverged  := (iter_div_out = '1');
						v_exhausted := (v_slots(v_slot).iter >= MAX_ITER - 1);
						v_pixel_done := v_diverged or v_exhausted;

						if not v_pixel_done then
							-- Feed the slot back into the input for another iteration
							v_slots(v_slot).z_re := iter_z_re_out;
							v_slots(v_slot).z_im := iter_z_im_out;
							v_slots(v_slot).iter := v_slots(v_slot).iter + 1;
							v_valid_pipe(0) := '1';
							v_tag_pipe(0) := v_slot;
						else
							v_valid_pipe(0) := '0';
							-- Write the result
							v_bram_addr := std_logic_vector(to_unsigned(v_slots(v_slot).y * C_BUFFER_WIDTH + v_slots(v_slot).x,
											C_BRAM_ADDR_BIT_SIZE));
							if v_diverged then
								v_bram_data := std_logic_vector(to_unsigned(v_slots(v_slot).iter + 1, v_bram_data'length));
							else
								v_bram_data := (others => '0');
							end if;

							v_bram_we := '1';

							v_pixels_written := v_pixels_written + 1;
							if v_pixels_written >= C_BUFFER_WIDTH * C_BUFFER_HEIGHT then
								v_state := DONE_ST;
							end if;
						end if;
					end if;
				when DONE_ST =>
					v_frame_done  := '1';
					if StartxDI = '1' then
						eng_state <= IDLE;
					end if;
			end case;
		end if;

		eng_state <= v_state;
		filling_count <= v_filling_count;
		x <= v_x;
		y <= v_y;
		re <= v_re;
		im <= v_im;
		pixels_written <= v_pixels_written;
		tag_pipe <= v_tag_pipe;
		valid_pipe <= v_valid_pipe;
		iter_valid_in <= v_valid_pipe(0);

		bram_we <= v_bram_we;
		bram_addr <= v_bram_addr;
		bram_data <= v_bram_data;
		frame_done <= v_frame_done;
		slots <= v_slots;
		x0 <= v_x0;
		y0 <= v_y0;
		dx <= v_dx;
		dy <= v_dy;
		iter_z_re_in <= v_iter_z_re_in;
		iter_z_im_in <= v_iter_z_im_in;
		iter_c_re_in <= v_iter_c_re_in;
		iter_c_im_in <= v_iter_c_im_in;
	end process p_engine;
end architecture rtl;
