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
        BramRdData1xDI : in  std_logic_vector(8 downto 0);
        BramRdData2xDI : in  std_logic_vector(8 downto 0);
        BramRdAddrxDO  : out std_logic_vector((C_BRAM_ADDR_BIT_SIZE - 1) downto 0);
        PixelxDO       : out t_hdmi_vga_pix
    );
end scalp_vga_if;

architecture rtl of scalp_vga_if is
    signal BramRdBankSelxS : std_logic := '0';
    signal VgaVidOnDlyxS   : std_logic := '0';
begin

    process (PllLockedxSI, RstxRANI, ClkxCI) is
        variable PixelCodexD  : std_logic_vector(8 downto 0) := (others => '0');
        variable HxScaledxD   : integer := 0;
        variable VxScaledxD   : integer := 0;
        variable BramRdAddrxD : integer := 0;
    begin
        if (PllLockedxSI = '0') or (RstxRANI = '0') then
            BramRdAddrxDO   <= (others => '0');
            BramRdBankSelxS <= '0';
            VgaVidOnDlyxS   <= '0';
            PixelxDO        <= C_HDMI_VGA_PIX_IDLE;

        elsif rising_edge(ClkxCI) then

            ----------------------------------------------------------------
            -- Display of the current pixel
            ----------------------------------------------------------------
            if VgaVidOnDlyxS = '1' then
                if BramRdBankSelxS = '0' then
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

            ----------------------------------------------------------------
            -- Preparation of the next pixel
            ----------------------------------------------------------------
            VgaVidOnDlyxS   <= VidOnxSI;
            BramRdAddrxDO   <= (others => '0');
            BramRdBankSelxS <= '0';

            if VidOnxSI = '1' then
                HxScaledxD := (to_integer(unsigned(HxCntxDI)) * C_BUFFER_WIDTH) / C_VGA_ACTIVE_SIZE;
                VxScaledxD := (to_integer(unsigned(VxCntxDI)) * C_BUFFER_HEIGHT) / C_VGA_ACTIVE_SIZE;

                if VxScaledxD < (C_BUFFER_HEIGHT / 2) then
                    BramRdAddrxD := (VxScaledxD * C_BUFFER_WIDTH) + HxScaledxD;
                    BramRdBankSelxS <= '0';
                else
                    BramRdAddrxD := ((VxScaledxD - (C_BUFFER_HEIGHT / 2)) * C_BUFFER_WIDTH) + HxScaledxD;
                    BramRdBankSelxS <= '1';
                end if;

                BramRdAddrxDO <= std_logic_vector(to_unsigned(BramRdAddrxD, C_BRAM_ADDR_BIT_SIZE));
            end if;
        end if;
    end process;

end rtl;
