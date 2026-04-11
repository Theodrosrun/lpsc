library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity scalp_swiss_flag_gen is
    generic (
        C_FB_WIDTH           : integer := 32;
        C_FB_HEIGHT          : integer := 32;
        C_FB_LOCAL_ADDR_SIZE : integer := 512;
        C_BRAM_ADDR_BIT_SIZE : integer := 11
    );
    port (
        ClkxCI       : in  std_logic;
        RstxRANI     : in  std_logic;
        BramWrAddrxDO : out std_logic_vector((C_BRAM_ADDR_BIT_SIZE - 1) downto 0);
        BramWrDataxDO : out std_logic_vector(8 downto 0);
        BramWe1xDO    : out std_logic_vector(0 downto 0);
        BramWe2xDO    : out std_logic_vector(0 downto 0)
    );
end scalp_swiss_flag_gen;

architecture rtl of scalp_swiss_flag_gen is
    constant C_PIXEL_WHITExD : std_logic_vector(8 downto 0) := "000000000";
    constant C_PIXEL_REDxD   : std_logic_vector(8 downto 0) := "000000001";

    signal GenDonexS  : std_logic := '0';
    signal GenHxCntxD : integer range 0 to (C_FB_WIDTH - 1) := 0;
    signal GenVxCntxD : integer range 0 to (C_FB_HEIGHT - 1) := 0;
begin

    process (ClkxCI, RstxRANI) is
        variable PixelAddrxD : integer range 0 to (C_FB_LOCAL_ADDR_SIZE - 1) := 0;
    begin
        if RstxRANI = '0' then
            GenDonexS     <= '0';
            GenHxCntxD    <= 0;
            GenVxCntxD    <= 0;
            BramWrAddrxDO <= (others => '0');
            BramWrDataxDO <= (others => '0');
            BramWe1xDO    <= "0";
            BramWe2xDO    <= "0";

        elsif rising_edge(ClkxCI) then
            BramWe1xDO <= "0";
            BramWe2xDO <= "0";

            if GenDonexS = '0' then
                BramWrDataxDO <= C_PIXEL_REDxD;

                if (((GenHxCntxD >= 13) and (GenHxCntxD < 19)) and
                    ((GenVxCntxD >=  6) and (GenVxCntxD < 26))) or
                   (((GenHxCntxD >=  6) and (GenHxCntxD < 26)) and
                    ((GenVxCntxD >= 13) and (GenVxCntxD < 19))) then
                    BramWrDataxDO <= C_PIXEL_WHITExD;
                end if;

                if GenVxCntxD < (C_FB_HEIGHT / 2) then
                    PixelAddrxD := (GenVxCntxD * C_FB_WIDTH) + GenHxCntxD;
                    BramWe1xDO  <= "1";
                else
                    PixelAddrxD := ((GenVxCntxD - (C_FB_HEIGHT / 2)) * C_FB_WIDTH) + GenHxCntxD;
                    BramWe2xDO  <= "1";
                end if;

                BramWrAddrxDO <= std_logic_vector(to_unsigned(PixelAddrxD, C_BRAM_ADDR_BIT_SIZE));

                if GenHxCntxD < (C_FB_WIDTH - 1) then
                    GenHxCntxD <= GenHxCntxD + 1;
                else
                    if GenVxCntxD < (C_FB_HEIGHT - 1) then
                        GenVxCntxD <= GenVxCntxD + 1;
                    else
                        GenVxCntxD <= 0;
                        GenDonexS  <= '1';
                    end if;

                    GenHxCntxD <= 0;
                end if;
            end if;
        end if;
    end process;

end rtl;
