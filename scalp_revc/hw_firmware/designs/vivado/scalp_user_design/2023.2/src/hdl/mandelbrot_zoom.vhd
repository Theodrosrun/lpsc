

----------------------------------------------------------------------------------
--                                 _             _
--                                | |_  ___ _ __(_)__ _
--                                | ' \/ -_) '_ \ / _` |
--                                |_||_\___| .__/_\__,_|
--                                         |_|
--
----------------------------------------------------------------------------------
--
-- Company: hepia
-- Authors: Andrè Costa, Theodros Mulugeta
--
-- Module Name: mandelbrot_zoom - arch
-- Description: mandelbrot_zoom
--
-- Last update: 2026-05-30
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mandelbrot_pkg.all;

entity mandelbrot_zoom is
    generic (
        C_BRAM_ROW_WIDTH: integer:=512;
	    C_BRAM_COUNT : integer := 32;
        DATA_W : integer := 18;
        FRAC_W : integer := 15
    );
    port (
        frame_counter : in  unsigned(6 downto 0);
        x0            : out signed(DATA_W-1 downto 0);
        dx            : out signed(DATA_W-1 downto 0);
        dy            : out signed(DATA_W-1 downto 0);
        y0            : out signed_array_t(0 to C_BRAM_COUNT-1)
    );
end entity;

architecture rtl of mandelbrot_zoom is

    constant C_ROW_STRIDE  : integer := C_BRAM_ROW_WIDTH / C_BRAM_COUNT;

    type zoom_preset_t is record
        x0 : integer;
        y0 : integer;
        dx : integer;
        dy : integer;
    end record;

    -- Per-frame, per-BRAM y0 ROM
    type y0_frame_t  is array (0 to C_BRAM_COUNT - 1) of integer;
    type y0_rom_t    is array (0 to 99) of y0_frame_t;

    -- Raw zoom presets (unchanged)
    type zoom_rom_t is array (0 to 99) of zoom_preset_t;
    constant ZOOM_ROM : zoom_rom_t := (
        0  => (x0 => -49152, y0 => -49152, dx => 192, dy => 192),
        1  => (x0 => -48780, y0 => -48780, dx => 190, dy => 190),
        2  => (x0 => -48407, y0 => -48407, dx => 189, dy => 189),
        3  => (x0 => -48035, y0 => -48035, dx => 187, dy => 187),
        4  => (x0 => -47663, y0 => -47663, dx => 186, dy => 186),
        5  => (x0 => -47290, y0 => -47290, dx => 184, dy => 184),
        6  => (x0 => -46918, y0 => -46918, dx => 183, dy => 183),
        7  => (x0 => -46545, y0 => -46545, dx => 181, dy => 181),
        8  => (x0 => -46173, y0 => -46173, dx => 180, dy => 180),
        9  => (x0 => -45801, y0 => -45801, dx => 178, dy => 178),
        10 => (x0 => -45428, y0 => -45428, dx => 177, dy => 177),
        11 => (x0 => -45056, y0 => -45056, dx => 176, dy => 176),
        12 => (x0 => -44683, y0 => -44683, dx => 174, dy => 174),
        13 => (x0 => -44311, y0 => -44311, dx => 173, dy => 173),
        14 => (x0 => -43939, y0 => -43939, dx => 171, dy => 171),
        15 => (x0 => -43566, y0 => -43566, dx => 170, dy => 170),
        16 => (x0 => -43194, y0 => -43194, dx => 168, dy => 168),
        17 => (x0 => -42822, y0 => -42822, dx => 167, dy => 167),
        18 => (x0 => -42449, y0 => -42449, dx => 165, dy => 165),
        19 => (x0 => -42077, y0 => -42077, dx => 164, dy => 164),
        20 => (x0 => -41704, y0 => -41704, dx => 162, dy => 162),
        21 => (x0 => -41332, y0 => -41332, dx => 161, dy => 161),
        22 => (x0 => -40960, y0 => -40960, dx => 160, dy => 160),
        23 => (x0 => -40587, y0 => -40587, dx => 158, dy => 158),
        24 => (x0 => -40215, y0 => -40215, dx => 157, dy => 157),
        25 => (x0 => -39842, y0 => -39842, dx => 155, dy => 155),
        26 => (x0 => -39470, y0 => -39470, dx => 154, dy => 154),
        27 => (x0 => -39098, y0 => -39098, dx => 152, dy => 152),
        28 => (x0 => -38725, y0 => -38725, dx => 151, dy => 151),
        29 => (x0 => -38353, y0 => -38353, dx => 149, dy => 149),
        30 => (x0 => -37980, y0 => -37980, dx => 148, dy => 148),
        31 => (x0 => -37608, y0 => -37608, dx => 146, dy => 146),
        32 => (x0 => -37236, y0 => -37236, dx => 145, dy => 145),
        33 => (x0 => -36863, y0 => -36863, dx => 143, dy => 143),
        34 => (x0 => -36491, y0 => -36491, dx => 142, dy => 142),
        35 => (x0 => -36119, y0 => -36119, dx => 141, dy => 141),
        36 => (x0 => -35746, y0 => -35746, dx => 139, dy => 139),
        37 => (x0 => -35374, y0 => -35374, dx => 138, dy => 138),
        38 => (x0 => -35001, y0 => -35001, dx => 136, dy => 136),
        39 => (x0 => -34629, y0 => -34629, dx => 135, dy => 135),
        40 => (x0 => -34257, y0 => -34257, dx => 133, dy => 133),
        41 => (x0 => -33884, y0 => -33884, dx => 132, dy => 132),
        42 => (x0 => -33512, y0 => -33512, dx => 130, dy => 130),
        43 => (x0 => -33139, y0 => -33139, dx => 129, dy => 129),
        44 => (x0 => -32767, y0 => -32767, dx => 127, dy => 127),
        45 => (x0 => -32395, y0 => -32395, dx => 126, dy => 126),
        46 => (x0 => -32022, y0 => -32022, dx => 125, dy => 125),
        47 => (x0 => -31650, y0 => -31650, dx => 123, dy => 123),
        48 => (x0 => -31277, y0 => -31277, dx => 122, dy => 122),
        49 => (x0 => -30905, y0 => -30905, dx => 120, dy => 120),
        50 => (x0 => -30533, y0 => -30533, dx => 119, dy => 119),
        51 => (x0 => -30160, y0 => -30160, dx => 117, dy => 117),
        52 => (x0 => -29788, y0 => -29788, dx => 116, dy => 116),
        53 => (x0 => -29416, y0 => -29416, dx => 114, dy => 114),
        54 => (x0 => -29043, y0 => -29043, dx => 113, dy => 113),
        55 => (x0 => -28671, y0 => -28671, dx => 111, dy => 111),
        56 => (x0 => -28298, y0 => -28298, dx => 110, dy => 110),
        57 => (x0 => -27926, y0 => -27926, dx => 109, dy => 109),
        58 => (x0 => -27554, y0 => -27554, dx => 107, dy => 107),
        59 => (x0 => -27181, y0 => -27181, dx => 106, dy => 106),
        60 => (x0 => -26809, y0 => -26809, dx => 104, dy => 104),
        61 => (x0 => -26436, y0 => -26436, dx => 103, dy => 103),
        62 => (x0 => -26064, y0 => -26064, dx => 101, dy => 101),
        63 => (x0 => -25692, y0 => -25692, dx => 100, dy => 100),
        64 => (x0 => -25319, y0 => -25319, dx => 98,  dy => 98),
        65 => (x0 => -24947, y0 => -24947, dx => 97,  dy => 97),
        66 => (x0 => -24574, y0 => -24574, dx => 95,  dy => 95),
        67 => (x0 => -24202, y0 => -24202, dx => 94,  dy => 94),
        68 => (x0 => -23830, y0 => -23830, dx => 93,  dy => 93),
        69 => (x0 => -23457, y0 => -23457, dx => 91,  dy => 91),
        70 => (x0 => -23085, y0 => -23085, dx => 90,  dy => 90),
        71 => (x0 => -22713, y0 => -22713, dx => 88,  dy => 88),
        72 => (x0 => -22340, y0 => -22340, dx => 87,  dy => 87),
        73 => (x0 => -21968, y0 => -21968, dx => 85,  dy => 85),
        74 => (x0 => -21595, y0 => -21595, dx => 84,  dy => 84),
        75 => (x0 => -21223, y0 => -21223, dx => 82,  dy => 82),
        76 => (x0 => -20851, y0 => -20851, dx => 81,  dy => 81),
        77 => (x0 => -20478, y0 => -20478, dx => 79,  dy => 79),
        78 => (x0 => -20106, y0 => -20106, dx => 78,  dy => 78),
        79 => (x0 => -19733, y0 => -19733, dx => 77,  dy => 77),
        80 => (x0 => -19361, y0 => -19361, dx => 75,  dy => 75),
        81 => (x0 => -18989, y0 => -18989, dx => 74,  dy => 74),
        82 => (x0 => -18616, y0 => -18616, dx => 72,  dy => 72),
        83 => (x0 => -18244, y0 => -18244, dx => 71,  dy => 71),
        84 => (x0 => -17871, y0 => -17871, dx => 69,  dy => 69),
        85 => (x0 => -17499, y0 => -17499, dx => 68,  dy => 68),
        86 => (x0 => -17127, y0 => -17127, dx => 66,  dy => 66),
        87 => (x0 => -16754, y0 => -16754, dx => 65,  dy => 65),
        88 => (x0 => -16382, y0 => -16382, dx => 63,  dy => 63),
        89 => (x0 => -16010, y0 => -16010, dx => 62,  dy => 62),
        90 => (x0 => -15639, y0 => -15639, dx => 61,  dy => 61),
        91 => (x0 => -15267, y0 => -15267, dx => 59,  dy => 59),
        92 => (x0 => -14895, y0 => -14895, dx => 58,  dy => 58),
        93 => (x0 => -14522, y0 => -14522, dx => 56,  dy => 56),
        94 => (x0 => -14150, y0 => -14150, dx => 55,  dy => 55),
        95 => (x0 => -13777, y0 => -13777, dx => 53,  dy => 53),
        96 => (x0 => -13405, y0 => -13405, dx => 52,  dy => 52),
        97 => (x0 => -13033, y0 => -13033, dx => 50,  dy => 50),
        98 => (x0 => -12660, y0 => -12660, dx => 49,  dy => 49),
        99 => (x0 => -12288, y0 => -12288, dx => 48,  dy => 48)
    );

    -- Elaboration-time function to build the full y0 ROM
    function build_y0_rom return y0_rom_t is
        variable rom : y0_rom_t;
    begin
        for frame in 0 to 99 loop
            for bram in 0 to C_BRAM_COUNT - 1 loop
                rom(frame)(bram) := ZOOM_ROM(frame).y0 + bram * C_ROW_STRIDE * ZOOM_ROM(frame).dy;
            end loop;
        end loop;
        return rom;
    end function;

    constant Y0_ROM : y0_rom_t := build_y0_rom;

    signal frame_index : integer range 0 to 99;

begin

    process(frame_counter)
    begin
        if to_integer(frame_counter) > 99 then
            frame_index <= 99;
        else
            frame_index <= to_integer(frame_counter);
        end if;
    end process;

    x0 <= to_signed(ZOOM_ROM(frame_index).x0, DATA_W);
    dx <= to_signed(ZOOM_ROM(frame_index).dx, DATA_W);
    dy <= to_signed(ZOOM_ROM(frame_index).dy, DATA_W);

    gen_y0 : for i in 0 to C_BRAM_COUNT - 1 generate
        y0(i) <= to_signed(Y0_ROM(frame_index)(i), DATA_W);
    end generate;

end architecture;
