library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library scalp_lib;
use scalp_lib.scalp_hdmi_pkg.all;

entity scalp_vga_if is
    generic (
        C_BUFFER_WIDTH       : integer;
        C_BUFFER_HEIGHT      : integer;
        C_BRAM_ADDR_BIT_SIZE : integer;
        C_VGA_ACTIVE_SIZE    : integer
    );
    port (
        ClkxCI         : in  std_logic;
        PllLockedxSI   : in  std_logic;
        RstxRANI       : in  std_logic;
        VidOnxSI       : in  std_logic;
        HxCntxDI       : in  std_logic_vector(15 downto 0);
        VxCntxDI       : in  std_logic_vector(15 downto 0);
        BramRdDataxDI  : in  std_logic_vector(8 downto 0);
        BramRdAddrxDO  : out std_logic_vector((C_BRAM_ADDR_BIT_SIZE - 1) downto 0);
        PixelxDO       : out t_hdmi_vga_pix
    );
end scalp_vga_if;

architecture rtl of scalp_vga_if is
    signal VgaVidOnDlyxS : std_logic := '0';
begin

    process (PllLockedxSI, RstxRANI, ClkxCI) is
        variable PixelCodexD  : std_logic_vector(8 downto 0) := (others => '0');
        variable HxScaledxD   : integer := 0;
        variable VxScaledxD   : integer := 0;
        variable BramRdAddrxD : integer := 0;
    begin
        if (PllLockedxSI = '0') or (RstxRANI = '0') then
            BramRdAddrxDO <= (others => '0');
            VgaVidOnDlyxS <= '0';
            PixelxDO      <= C_HDMI_VGA_PIX_IDLE;

        elsif rising_edge(ClkxCI) then

            if VgaVidOnDlyxS = '1' then
                PixelCodexD := BramRdDataxDI;

                PixelxDO.RxD <= PixelCodexD(8 downto 6) &
                                PixelCodexD(8 downto 6) &
                                PixelCodexD(8 downto 7);

                PixelxDO.GxD <= PixelCodexD(5 downto 3) &
                                PixelCodexD(5 downto 3) &
                                PixelCodexD(5 downto 4);

                PixelxDO.BxD <= PixelCodexD(2 downto 0) &
                                PixelCodexD(2 downto 0) &
                                PixelCodexD(2 downto 1);
            else
                PixelxDO <= C_HDMI_VGA_PIX_IDLE;
            end if;

            VgaVidOnDlyxS <= VidOnxSI;
            BramRdAddrxDO <= (others => '0');

            if VidOnxSI = '1' then
                HxScaledxD := (to_integer(unsigned(HxCntxDI)) * C_BUFFER_WIDTH) / C_VGA_ACTIVE_SIZE;
                VxScaledxD := (to_integer(unsigned(VxCntxDI)) * C_BUFFER_HEIGHT) / C_VGA_ACTIVE_SIZE;

                BramRdAddrxD := (VxScaledxD * C_BUFFER_WIDTH) + HxScaledxD;

                BramRdAddrxDO <= std_logic_vector(
                    to_unsigned(BramRdAddrxD, C_BRAM_ADDR_BIT_SIZE)
                );
            end if;
        end if;
    end process;

end rtl;
