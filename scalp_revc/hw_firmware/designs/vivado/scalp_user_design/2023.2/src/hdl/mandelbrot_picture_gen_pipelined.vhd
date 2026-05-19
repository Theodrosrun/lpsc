library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

architecture pipelined of mandelbrot_picture_gen is

	constant NUM_SLOTS : integer := 3;

	type slot_state_t is (INACTIVE, READY, ACTIVE);

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
	type engine_state_t is (IDLE, RUNNING, DONE_ST);

	-- Tag/valid shift register (depth = pipeline latency = 2)
	type tag_pipe_t is array (0 to NUM_SLOTS) of integer range 0 to NUM_SLOTS-1;

	-- Signals
	signal eng_state : engine_state_t := IDLE;
	signal slots     : slots_t;

	signal x : integer range 0 to C_BUFFER_WIDTH  - 1 := 0;
	signal y : integer range 0 to C_BUFFER_HEIGHT - 1 := 0;
	signal re : signed(DATA_W-1 downto 0);
	signal im : signed(DATA_W-1 downto 0);

	signal all_issued  : boolean; 

	signal tag_pipe : tag_pipe_t   := (others => 0);
	signal valid_pipe : std_logic_vector(NUM_SLOTS downto 0) := (others => '0');

	signal iter_valid_in  : std_logic := '0';
	signal iter_z_re_in   : signed(DATA_W-1 downto 0) := (others => '0');
	signal iter_z_im_in   : signed(DATA_W-1 downto 0) := (others => '0');
	signal iter_c_re_in   : signed(DATA_W-1 downto 0) := (others => '0');
	signal iter_c_im_in   : signed(DATA_W-1 downto 0) := (others => '0');
	signal iter_z_re_out  : signed(DATA_W-1 downto 0);
	signal iter_z_im_out  : signed(DATA_W-1 downto 0);
	signal iter_div_out   : std_logic;
	signal iter_valid_out : std_logic;

	signal pixels_written : integer range 0 to C_BUFFER_WIDTH * C_BUFFER_HEIGHT := 0;

	signal x0, y0, dx, dy : signed(DATA_W-1 downto 0) := (others => '0');

	component mandelbrot_iter is
		generic (
				DATA_W : integer;
				FRAC_W : integer
			);
		port (
			     clk     : in  std_logic;
			     reset   : in std_logic;
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

begin

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


	p_engine : process (ClkxCI, RstxRANI)
		variable v_input_slot	  : integer range 0 to NUM_SLOTS-1 := 0;
		variable v_slot    : integer range 0 to NUM_SLOTS-1;
		variable v_x              : integer range 0 to C_BUFFER_WIDTH  - 1;
		variable v_y              : integer range 0 to C_BUFFER_HEIGHT  - 1;
		variable v_re             : signed(re'range);
		variable v_im             : signed(im'range);
		variable v_pixels_written : integer range 0 to C_BUFFER_WIDTH * C_BUFFER_HEIGHT := 0;
		variable v_tag_pipe       : tag_pipe_t;
		variable v_valid_pipe     : std_logic_vector(valid_pipe'range);
		variable v_slots 	  : slots_t;
		variable v_iter_z_re_in	  : signed(iter_z_re_in'range);
		variable v_iter_z_im_in	  : signed(iter_z_im_in'range);
		variable v_iter_c_re_in	  : signed(iter_c_re_in'range);
		variable v_iter_c_im_in	  : signed(iter_c_im_in'range);
		variable v_bram_we	  : std_logic;
		variable v_bram_addr	  : std_logic_vector(BramWrAddrxDO'range);
		variable v_bram_data	  : std_logic_vector(BramWrDataxDO'range);
		variable v_frame_done	  : std_logic;
		variable v_all_issued     : boolean;
		variable v_diverged       : boolean;
		variable v_exhausted      : boolean;
		variable v_pixel_done     : boolean;
		variable v_state          : engine_state_t;
		variable v_x0 		  : signed(DATA_W-1 downto 0);
		variable v_y0 		  : signed(DATA_W-1 downto 0);
		variable v_dx 		  : signed(DATA_W-1 downto 0);
		variable v_dy 		  : signed(DATA_W-1 downto 0);
	begin

		if RstxRANI = '0' then
			eng_state 	<= IDLE;
			x     	 	<= 0;
			y     	 	<= 0;
			re    	 	<= (others => '0');
			im    	 	<= (others => '0');
			pixels_written  <= 0;
			tag_pipe        <= (others => 0);
			valid_pipe      <= (others => '0');
			BramWrAddrxDO 	<= (others => '0');
			BramWrDataxDO 	<= (others => '0');
			BramWexSO 	<= (others => '0');
			FrameDonexSO  	<= '0';
			for s in 0 to NUM_SLOTS-1 loop
				slots(s).state <= INACTIVE;
				slots(s).iter  <= 0;
				slots(s).z_re  <= (others => '0');
				slots(s).z_im  <= (others => '0');
				slots(s).c_re  <= (others => '0');
				slots(s).c_im  <= (others => '0');
				slots(s).x  <= 0;
				slots(s).y  <= 0;
			end loop;

		elsif rising_edge(ClkxCI) then
			v_state         := eng_state;
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
			v_bram_addr := (others => '0');
			v_bram_data := (others => '0');
			v_frame_done := '0';
			v_slots := slots;
			v_x0 := x0;
			v_y0 := y0;
			v_dx := dx;
			v_dy := dy;
			v_tag_pipe(3) := v_tag_pipe(2);
			v_tag_pipe(2) := v_tag_pipe(1);
			v_tag_pipe(1) := v_tag_pipe(0);
			v_valid_pipe(3) := v_valid_pipe(2);
			v_valid_pipe(2) := v_valid_pipe(1);
			v_valid_pipe(1) := v_valid_pipe(0);
			v_all_issued := all_issued;
			case v_state is
				when IDLE =>
					v_valid_pipe     := (others => '0');
					v_pixels_written := 0;

					if StartxDI = '1' then
						v_state  := RUNNING;
						v_x0 := X0xDI;
						v_y0 := Y0xDI;
						v_dx := DxxDI;
						v_dy := DyxDI;
						v_x := 0;
						v_y := 0;
						v_re := v_x0;
						v_im := v_y0;
						v_all_issued := false;
						for s in 0 to NUM_SLOTS-1 loop
							v_slots(s).state := INACTIVE;
							v_slots(s).iter  := 0;
							v_slots(s).z_re  := (others => '0');
							v_slots(s).z_im  := (others => '0');
							v_slots(s).c_re  := (others => '0');
							v_slots(s).c_im  := (others => '0');
							v_slots(s).x     := 0;
							v_slots(s).y     := 0;
						end loop;
					end if;

				when RUNNING => 

					for i in 0 to NUM_SLOTS - 1 loop
						if not v_all_issued and v_slots(i).state = INACTIVE then
					        	v_slots(i).state := READY; 
					        	v_slots(i).z_re  := v_re;
					        	v_slots(i).z_im  := v_im;
					        	v_slots(i).c_re  := to_signed(11633, DATA_W);
					        	v_slots(i).c_im  := to_signed(11633, DATA_W);
					        	v_slots(i).x     := v_x;
					        	v_slots(i).y     := v_y;
					        	v_slots(i).iter  := 0;

					        	-- Increment coordinate counters
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
					        			v_im := v_y0;
									v_all_issued := true;
					        		end if;
					        	end if;
					        	
					        	exit;
					        end if;
					end loop;

					v_valid_pipe(0) := '0';
					for i in 0 to NUM_SLOTS - 1 loop
						if v_slots(i).state = READY then
					        	v_iter_z_re_in  := v_slots(i).z_re;
					        	v_iter_z_im_in  := v_slots(i).z_im;
					        	v_iter_c_re_in  := v_slots(i).c_re;
					        	v_iter_c_im_in  := v_slots(i).c_im;
					        	v_valid_pipe(0) := '1';
					        	v_tag_pipe(0)   := i;
					        	v_slots(i).state := ACTIVE; 
					        	exit;
						end if;
					end loop;

					if v_valid_pipe(3) = '1' then
						v_slot := v_tag_pipe(3);
						v_diverged  := (iter_div_out = '1');
						v_exhausted := (v_slots(v_slot).iter >= MAX_ITER - 1);
						v_pixel_done := v_diverged or v_exhausted;

						if not v_pixel_done then
							v_slots(v_slot).z_re := iter_z_re_out;
							v_slots(v_slot).z_im := iter_z_im_out;
							v_slots(v_slot).iter := v_slots(v_slot).iter + 1;
							v_slots(v_slot).state := READY;
						else
							-- Write the result and fill the free'd slot with the next pixel
							v_bram_addr := std_logic_vector(to_unsigned(v_slots(v_slot).y * C_BUFFER_WIDTH + v_slots(v_slot).x,
											C_BRAM_ADDR_BIT_SIZE));
							if v_diverged then
								v_bram_data := std_logic_vector(to_unsigned(v_slots(v_slot).iter, v_bram_data'length));
							else
								v_bram_data := (others => '0');
							end if;

							v_bram_we := '1';
							v_pixels_written := v_pixels_written + 1;
							v_slots(v_slot).state := INACTIVE;
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

			eng_state <= v_state;
			x <= v_x;
			y <= v_y;
			re <= v_re;
			im <= v_im;
			pixels_written <= v_pixels_written;
			tag_pipe <= v_tag_pipe;
			valid_pipe <= v_valid_pipe;
			iter_valid_in <= v_valid_pipe(0);
			slots <= v_slots;
			x0 <= v_x0;
			y0 <= v_y0;
			dx <= v_dx;
			dy <= v_dy;
			iter_z_re_in <= v_iter_z_re_in;
			iter_z_im_in <= v_iter_z_im_in;
			iter_c_re_in <= v_iter_c_re_in;
			iter_c_im_in <= v_iter_c_im_in;
			BramWrAddrxDO <= v_bram_addr;
			BramWrDataxDO <= v_bram_data;
			BramWexSO(0)  <= v_bram_we;
			FrameDonexSO  <= v_frame_done;
			all_issued <= v_all_issued;
		end if;
	end process p_engine;

end architecture rtl;
