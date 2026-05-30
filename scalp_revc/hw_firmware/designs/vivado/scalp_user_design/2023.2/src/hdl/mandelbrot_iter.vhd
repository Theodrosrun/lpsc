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
-- Module Name: mandelbrot_iter - arch
-- Description: mandelbrot_iter
--
-- Last update: 2026-05-30
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mandelbrot_iter is
    generic (
        DATA_W : integer := 18;
        FRAC_W : integer := 15
    );
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
    	i_valid : in std_logic;
    	o_valid : out std_logic;
        z_re_n  : in  signed(DATA_W-1 downto 0);
        z_im_n  : in  signed(DATA_W-1 downto 0);
        c_re_n  : in  signed(DATA_W-1 downto 0);
        c_im_n  : in  signed(DATA_W-1 downto 0);
        z_re_n1 : out signed(DATA_W-1 downto 0);
        z_im_n1 : out signed(DATA_W-1 downto 0);
        div     : out std_logic
    );
end entity mandelbrot_iter;

