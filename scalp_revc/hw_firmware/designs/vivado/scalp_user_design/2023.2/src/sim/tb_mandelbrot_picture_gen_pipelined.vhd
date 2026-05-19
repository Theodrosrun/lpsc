library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_mandelbrot_picture_gen_pipelined is
end entity tb_mandelbrot_picture_gen_pipelined;

architecture sim of tb_mandelbrot_picture_gen_pipelined is

    constant CLK_PERIOD : time    := 10 ns;
    constant WIDTH      : integer := 720/10;
    constant HEIGHT     : integer := 720/10;
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
    signal start      : std_logic := '0';
    signal bram_addr  : std_logic_vector(ADDR_BITS-1 downto 0);
    signal bram_data  : std_logic_vector(6 downto 0);
    signal bram_we   : std_logic_vector(0 downto 0);
    signal frame_done : std_logic;

    -- Simple model of the BRAM: one entry per pixel
    type bram_t is array (0 to WIDTH*HEIGHT-1) of std_logic_vector(6 downto 0);
    signal bram : bram_t := (others => (others => '0'));

    type rgb_color is array (0 to 2) of integer;
    type palette_t is array (0 to MAX_ITER - 1) of rgb_color;

    constant magma_palette : palette_t := (
    ( 0, 0, 5 ),      ( 0, 0, 10 ),	( 0, 0, 15 ),     ( 1, 0, 20 ),	    ( 2, 0, 25 ),     ( 4, 0, 30 ),
    ( 6, 0, 35 ),     ( 8, 0, 40 ),     ( 10, 0, 45 ),    ( 12, 0, 50 ),    ( 15, 0, 55 ),    ( 17, 0, 60 ),
    ( 20, 0, 65 ),    ( 23, 0, 70 ),    ( 26, 0, 75 ),    ( 29, 0, 80 ),    ( 32, 1, 85 ),    ( 36, 1, 90 ),
    ( 39, 1, 95 ),    ( 43, 1, 100 ),   ( 46, 2, 104 ),   ( 50, 2, 108 ),   ( 54, 2, 112 ),   ( 58, 2, 116 ),
    ( 62, 2, 119 ),   ( 66, 3, 123 ),   ( 70, 3, 126 ),   ( 75, 3, 129 ),   ( 79, 4, 132 ),   ( 84, 4, 134 ),
    ( 88, 4, 137 ),   ( 93, 5, 139 ),   ( 98, 5, 141 ),   ( 103, 6, 143 ),  ( 107, 6, 145 ),  ( 112, 7, 146 ),
    ( 117, 7, 148 ),  ( 122, 8, 149 ),  ( 127, 9, 150 ),  ( 132, 10, 151 ), ( 137, 10, 151 ), ( 142, 11, 152 ),
    ( 147, 12, 152 ), ( 152, 13, 153 ), ( 157, 14, 153 ), ( 162, 15, 153 ), ( 167, 16, 153 ), ( 172, 18, 152 ),
    ( 176, 19, 152 ), ( 181, 21, 151 ), ( 186, 22, 151 ), ( 190, 24, 150 ), ( 195, 26, 149 ), ( 199, 28, 148 ),
    ( 203, 30, 147 ), ( 208, 32, 145 ), ( 212, 34, 143 ), ( 216, 36, 141 ), ( 220, 38, 139 ), ( 224, 40, 137 ),
    ( 228, 43, 135 ), ( 232, 45, 132 ), ( 235, 47, 130 ), ( 239, 50, 127 ), ( 242, 53, 124 ), ( 245, 55, 121 ),
    ( 248, 58, 118 ), ( 251, 61, 114 ), ( 253, 64, 111 ), ( 255, 67, 107 ), ( 255, 70, 104 ), ( 255, 74, 100 ),
    ( 255, 77, 96 ),  ( 255, 80, 93 ),  ( 255, 84, 89 ),  ( 255, 87, 85 ),  ( 255, 91, 81 ),  ( 255, 94, 77 ),
    ( 255, 98, 73 ),  ( 255, 101, 69 ), ( 255, 105, 65 ), ( 255, 109, 61 ), ( 255, 112, 58 ), ( 255, 116, 54 ),
    ( 255, 120, 50 ), ( 255, 123, 46 ), ( 255, 127, 42 ), ( 255, 131, 39 ), ( 255, 135, 35 ), ( 255, 139, 32 ),
    ( 255, 142, 28 ), ( 255, 146, 25 ), ( 255, 150, 22 ), ( 255, 154, 19 ), ( 255, 158, 17 ), ( 255, 162, 14 ),
    ( 255, 165, 12 ), ( 255, 169, 10 ), ( 255, 173, 8 ),  ( 255, 177, 6 ));

    procedure write_pixel(file f : text; iter : in unsigned(6 downto 0)) is
        variable l : line;
        variable r, g, b : integer;
        variable idx : integer;
    begin
        idx := to_integer(iter);

        -- write(l, idx);
        -- writeline(f, l);

        
        if idx = MAX_ITER then
            r := 0; g := 0; b := 0; -- Point is inside the set
        else
            r := magma_palette(idx)(0);
            g := magma_palette(idx)(1);
            b := magma_palette(idx)(2);
        end if;
    
        -- Format: "R G B " followed by a newline for clear scannability
        write(l, integer'image(r) & " " & integer'image(g) & " " & integer'image(b));
        writeline(f, l);
    end procedure;

begin

    clk <= not clk after CLK_PERIOD / 2;

    dut : entity work.mandelbrot_picture_gen_pipelined
        generic map (
            C_BUFFER_WIDTH     => WIDTH,
            C_BUFFER_HEIGHT    => HEIGHT,
            C_BRAM_ADDR_BIT_SIZE => ADDR_BITS,
            DATA_W    => 18,
            FRAC_W    => 15,
            MAX_ITER  => MAX_ITER
        )
        port map (
                ClkxCI        => clk,
                RstxRANI      => not reset,
                
                X0xDI         => X0,
                Y0xDI         => Y0,
                DxxDI         => DX,
                DyxDI         => DY,
                
                StartxDI      => start,
                BramWrAddrxDO => bram_addr,
                BramWrDataxDO => bram_data,
                BramWexSO     => bram_we,
                
                FrameDonexSO  => frame_done
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
        start <= '0';
        wait for CLK_PERIOD * 4;
        wait until rising_edge(clk);
        reset <= '0';
        start <= '1';
        wait until rising_edge(clk);
        wait for CLK_PERIOD * 2;
        wait until rising_edge(clk);
        start <= '0';

        -- Wait for one complete frame
        wait until rising_edge(clk) and frame_done = '1';
        wait until rising_edge(clk);   -- let the last BRAM write settle

        report "Frame complete - writing PPM";

        -- PPM header
        write(l, string'("P3"));
        writeline(f_ppm, l);
        write(l, integer'image(WIDTH) & " " & integer'image(HEIGHT));
        writeline(f_ppm, l); 
        write(l, string'("255"));
        writeline(f_ppm, l);

        -- Dump BRAM contents as RGB
        for y in 0 to HEIGHT-1 loop
            for x in 0 to WIDTH-1 loop
                entry := bram(y * WIDTH + x);
                write_pixel(f_ppm, unsigned(entry(6 downto 0)));
            end loop;

            report "Written row " & integer'image(y);
        end loop;

        file_close(f_ppm);
        report "PPM saved to output.ppm";
        std.env.stop;
    end process;

end architecture sim;
