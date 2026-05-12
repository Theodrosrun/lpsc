library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_mandelbrot_picture_gen is
end entity tb_mandelbrot_picture_gen;

architecture sim of tb_mandelbrot_picture_gen is

    constant CLK_PERIOD : time    := 10 ns;
    constant WIDTH      : integer := 80;
    constant HEIGHT     : integer := 60;
    constant ADDR_BITS  : integer := 19;
    constant MAX_ITER   : integer := 100;
    constant DATA_W     : integer := 18;
    constant FRAC_W     : integer := 15;

    -- Mandelbrot Math Parameters
    constant X_MIN : real := -2.0;
    constant X_MAX : real := 1.0;
    constant Y_MIN : real := -1.2;
    constant Y_MAX : real := 1.2;

    -- Auto-calculated Step Sizes
    -- Formula: ((Max - Min) / Pixels) * 2^FRAC_W
    constant DX_REAL : real := ((X_MAX - X_MIN) / real(WIDTH))  * real(2**FRAC_W);
    constant DY_REAL : real := ((Y_MAX - Y_MIN) / real(HEIGHT)) * real(2**FRAC_W);
    -- Hardware Constants
    constant DX : signed(DATA_W-1 downto 0) := to_signed(integer(DX_REAL), DATA_W); 
    constant DY : signed(DATA_W-1 downto 0) := to_signed(integer(DY_REAL), DATA_W);
    
    -- Starting Coordinates (Left-Top)
    constant X0 : signed(DATA_W-1 downto 0) := to_signed(integer(X_MIN * real(2**FRAC_W)), DATA_W);
    constant Y0 : signed(DATA_W-1 downto 0) := to_signed(integer(Y_MIN * real(2**FRAC_W)), DATA_W);

    signal clk        : std_logic := '0';
    signal reset      : std_logic := '1';
    signal bram_addr  : std_logic_vector(ADDR_BITS-1 downto 0);
    signal bram_data  : std_logic_vector(6 downto 0);
    signal bram_we   : std_logic_vector(0 downto 0);
    signal frame_done : std_logic;

    -- Simple model of the BRAM: one entry per pixel
    type bram_t is array (0 to WIDTH*HEIGHT-1) of std_logic_vector(6 downto 0);
    signal bram : bram_t := (others => (others => '0'));

begin

    clk <= not clk after CLK_PERIOD / 2;

    dut : entity work.mandelbrot_picture_gen
        generic map (
            WIDTH     => WIDTH,
            HEIGHT    => HEIGHT,
            ADDR_BITS => ADDR_BITS,
            DATA_W    => 18,
            FRAC_W    => 15,
            MAX_ITER  => MAX_ITER
        )
        port map (
            clk        => clk,
            reset      => reset,
            bram_addr  => bram_addr,
            bram_data  => bram_data,
            bram_we   => bram_we,
            frame_done => frame_done,
            x0 => X0,
            y0 => Y0,
            dx => DX,
            dy => DY
        );

    -- BRAM write model
    process (clk) is
    begin
        if rising_edge(clk) then
            if bram_we = "1" then
                bram(to_integer(unsigned(bram_addr))) <= bram_data;
            end if;
        end if;
    end process;

    -- Reset and dump process
    process is
        file     f_ppm : text open write_mode is "output.ppm";
        variable l     : line;
        variable entry : std_logic_vector(6 downto 0);
        variable iter  : integer;
        variable r, g, b : integer;

        -- Simple greyscale mapping: brighter = more iterations = near the set
        -- Inside-set pixels (bit 8 set) are rendered black.
        procedure iter_to_rgb (
            val       : in  std_logic_vector(6 downto 0);
            signal ro : out integer;
            signal go : out integer;
            signal bo : out integer
        ) is
        begin
        end procedure;

    begin
        -- Hold reset for a few cycles
        reset <= '1';
        wait for CLK_PERIOD * 4;
        wait until rising_edge(clk);
        reset <= '0';

        -- Wait for one complete frame
        wait until rising_edge(clk) and frame_done = '1';
        wait until rising_edge(clk);   -- let the last BRAM write settle

        report "Frame complete - writing PPM";

        -- PPM header
        write(l, string'("P3"));                          writeline(f_ppm, l);
        write(l, integer'image(WIDTH) & " " &
                 integer'image(HEIGHT));                   writeline(f_ppm, l);
        write(l, string'("255"));                         writeline(f_ppm, l);

        -- Dump BRAM contents as RGB
        for y in 0 to HEIGHT-1 loop
            for x in 0 to WIDTH-1 loop
                entry := bram(y * WIDTH + x);

                if entry(8) = '1' then
                    -- Inside the Mandelbrot set: black
                    r := 0;
                    g := 0;
                    b := 0;
                else
                    iter := to_integer(unsigned(entry(7 downto 0)));

                    -- Smooth greyscale: scale iteration count to 0-255
                    -- iter=0 is deep black, iter=MAX_ITER-1 is near-white.
                    -- Gamma-like boost with a square-root approximation:
                    --   value = round(255 * sqrt(iter / (MAX_ITER-1)))
                    -- We approximate sqrt in pure VHDL-sim arithmetic:
                    --   sqrt(t) ~ t^0.5 is expensive; use linear for simplicity
                    --   and let the user swap in a palette if desired.
                    r := (iter * 255) / (MAX_ITER - 1);
                    g := (iter * 200) / (MAX_ITER - 1);
                    b := (iter * 100) / (MAX_ITER - 1);
                end if;

                write(l, integer'image(r) & " " &
                         integer'image(g) & " " &
                         integer'image(b));
                writeline(f_ppm, l);
            end loop;

            report "Written row " & integer'image(y);
        end loop;

        file_close(f_ppm);
        report "PPM saved to output.ppm";
        std.env.stop;
    end process;

end architecture sim;
