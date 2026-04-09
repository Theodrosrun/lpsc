library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity scalp_vga_if_addr is
    generic (
        C_FB_WIDTH           : integer := 32;
        C_FB_HEIGHT          : integer := 32;
        C_FB_HALF_HEIGHT     : integer := 16;
        C_FB_LOCAL_ADDR_SIZE : integer := 512;
        C_BRAM_ADDR_BIT_SIZE : integer := 11;
        C_VGA_ACTIVE_SIZE    : integer := 720;
        C_CNT_WIDTH          : integer := 16
    );
    port (
        ClkxCI          : in  std_logic;
        PllLockedxSI    : in  std_logic;
        RstxRANI        : in  std_logic;
        VidOnxSI        : in  std_logic;
        HxCntxDI        : in  std_logic_vector((C_CNT_WIDTH - 1) downto 0);
        VxCntxDI        : in  std_logic_vector((C_CNT_WIDTH - 1) downto 0);
        BramRdAddrxDO   : out std_logic_vector((C_BRAM_ADDR_BIT_SIZE - 1) downto 0);
        BramRdBankSelxSO : out std_logic;
        VgaVidOnDlyxSO  : out std_logic
    );
end scalp_vga_if_addr;

architecture rtl of scalp_vga_if_addr is
begin
    process (PllLockedxSI, RstxRANI, ClkxCI) is
        variable HxScaledxD  : integer range 0 to (C_FB_WIDTH - 1) := 0;
        variable VxScaledxD  : integer range 0 to (C_FB_HEIGHT - 1) := 0;
        variable LocalAddrxD : integer range 0 to (C_FB_LOCAL_ADDR_SIZE - 1) := 0;
    begin
        if (PllLockedxSI = '0') or (RstxRANI = '0') then
            BramRdAddrxDO    <= (others => '0');
            BramRdBankSelxSO <= '0';
            VgaVidOnDlyxSO   <= '0';

        elsif rising_edge(ClkxCI) then
            VgaVidOnDlyxSO <= VidOnxSI;

            if VidOnxSI = '1' then
                HxScaledxD := (to_integer(unsigned(HxCntxDI)) * C_FB_WIDTH) / C_VGA_ACTIVE_SIZE;
                VxScaledxD := (to_integer(unsigned(VxCntxDI)) * C_FB_HEIGHT) / C_VGA_ACTIVE_SIZE;

                if VxScaledxD < C_FB_HALF_HEIGHT then
                    LocalAddrxD     := (VxScaledxD * C_FB_WIDTH) + HxScaledxD;
                    BramRdBankSelxSO <= '0';
                else
                    LocalAddrxD     := ((VxScaledxD - C_FB_HALF_HEIGHT) * C_FB_WIDTH) + HxScaledxD;
                    BramRdBankSelxSO <= '1';
                end if;

                BramRdAddrxDO <= std_logic_vector(to_unsigned(LocalAddrxD, C_BRAM_ADDR_BIT_SIZE));
            else
                BramRdAddrxDO    <= (others => '0');
                BramRdBankSelxSO <= '0';
            end if;
        end if;
    end process;
end rtl;