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
-- Module Name: mandelbrot_picture_gen - arch
-- Description: mandelbrot_picture_gen
--
-- Last update: 2026-05-30
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mandelbrot_picture_gen is
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
end entity mandelbrot_picture_gen;

