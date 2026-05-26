library ieee;
use ieee.numeric_std.all;

package mandelbrot_pkg is
    constant DATA_W      : integer := 18;
    constant C_BRAM_COUNT : integer := 32;
    type signed_array_t is array(natural range <>) of signed(DATA_W-1 downto 0);
end package mandelbrot_pkg;
