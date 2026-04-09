library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library scalp_lib;
use scalp_lib.scalp_hdmi_pkg.all;

entity scalp_vga_if_pix is
    port (
        ClkxCI          : in  std_logic;
        PllLockedxSI    : in  std_logic;
        RstxRANI        : in  std_logic;
        VgaVidOnDlyxSI  : in  std_logic;
        BramRdBankSelxSI : in  std_logic;
        BramRdData1xDI  : in  std_logic_vector(8 downto 0);
        BramRdData2xDI  : in  std_logic_vector(8 downto 0);
        PixelxDO        : out t_hdmi_vga_pix
    );
end scalp_vga_if_pix;

architecture rtl of scalp_vga_if_pix is
begin
    process (PllLockedxSI, RstxRANI, ClkxCI) is
        variable PixelCodexD : std_logic_vector(8 downto 0) := (others => '0');
    begin
        if (PllLockedxSI = '0') or (RstxRANI = '0') then
            PixelxDO <= C_HDMI_VGA_PIX_IDLE;

        elsif rising_edge(ClkxCI) then
            if VgaVidOnDlyxSI = '1' then
                if BramRdBankSelxSI = '0' then
                    PixelCodexD := BramRdData1xDI;
                else
                    PixelCodexD := BramRdData2xDI;
                end if;

                if PixelCodexD(0) = '1' then
                    PixelxDO.RxD <= (others => '1');
                    PixelxDO.GxD <= (others => '0');
                    PixelxDO.BxD <= (others => '0');
                else
                    PixelxDO.RxD <= (others => '1');
                    PixelxDO.GxD <= (others => '1');
                    PixelxDO.BxD <= (others => '1');
                end if;
            else
                PixelxDO <= C_HDMI_VGA_PIX_IDLE;
            end if;
        end if;
    end process;
end rtl;