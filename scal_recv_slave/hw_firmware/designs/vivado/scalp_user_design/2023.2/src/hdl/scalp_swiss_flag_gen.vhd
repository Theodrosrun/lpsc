library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity scalp_swiss_flag_gen is
    generic (
        C_BUFFER_WIDTH       : integer;
        C_BUFFER_HEIGHT      : integer;
        C_BRAM_ADDR_BIT_SIZE : integer
    );
    port (
        ClkxCI        : in  std_logic;
        RstxRANI      : in  std_logic;
        BramWrAddrxDO : out std_logic_vector((C_BRAM_ADDR_BIT_SIZE - 1) downto 0);
        BramWrDataxDO : out std_logic_vector(8 downto 0);
        BramWe1xDO    : out std_logic_vector(0 downto 0);
        BramWe2xDO    : out std_logic_vector(0 downto 0)
    );
end scalp_swiss_flag_gen;

architecture rtl of scalp_swiss_flag_gen is
    constant C_CROSS_THICKNESSxD : integer := C_BUFFER_WIDTH / 5;
    constant C_CROSS_MARGINxD    : integer := C_BUFFER_WIDTH / 5;

    constant C_CROSS_V_X_MINxD : integer := (C_BUFFER_WIDTH / 2) - (C_CROSS_THICKNESSxD / 2);
    constant C_CROSS_V_X_MAXxD : integer := (C_BUFFER_WIDTH / 2) + (C_CROSS_THICKNESSxD / 2);
    constant C_CROSS_V_Y_MINxD : integer := C_CROSS_MARGINxD;
    constant C_CROSS_V_Y_MAXxD : integer := C_BUFFER_HEIGHT - C_CROSS_MARGINxD;

    constant C_CROSS_H_X_MINxD : integer := C_CROSS_MARGINxD;
    constant C_CROSS_H_X_MAXxD : integer := C_BUFFER_WIDTH - C_CROSS_MARGINxD;
    constant C_CROSS_H_Y_MINxD : integer := (C_BUFFER_HEIGHT / 2) - (C_CROSS_THICKNESSxD / 2);
    constant C_CROSS_H_Y_MAXxD : integer := (C_BUFFER_HEIGHT / 2) + (C_CROSS_THICKNESSxD / 2);

    constant C_PIXEL_WHITExD : std_logic_vector(8 downto 0) := "000000000";
    constant C_PIXEL_REDxD   : std_logic_vector(8 downto 0) := "000000001";

    signal DonexS  : std_logic := '0';
    signal HxCntxD : integer range 0 to (C_BUFFER_WIDTH - 1) := 0;
    signal VxCntxD : integer range 0 to (C_BUFFER_HEIGHT - 1) := 0;
begin

    process (ClkxCI, RstxRANI) is
        variable BramWrAddrxD : integer := 0;
    begin
        if RstxRANI = '0' then
            DonexS        <= '0';
            HxCntxD       <= 0;
            VxCntxD       <= 0;
            BramWrAddrxDO <= (others => '0');
            BramWrDataxDO <= (others => '0');
            BramWe1xDO    <= "0";
            BramWe2xDO    <= "0";

        elsif rising_edge(ClkxCI) then
            BramWe1xDO <= "0";
            BramWe2xDO <= "0";

            if DonexS = '0' then
                BramWrDataxDO <= C_PIXEL_REDxD;

                if (((HxCntxD >= C_CROSS_V_X_MINxD) and (HxCntxD < C_CROSS_V_X_MAXxD)) and
                    ((VxCntxD >= C_CROSS_V_Y_MINxD) and (VxCntxD < C_CROSS_V_Y_MAXxD))) or
                   (((HxCntxD >= C_CROSS_H_X_MINxD) and (HxCntxD < C_CROSS_H_X_MAXxD)) and
                    ((VxCntxD >= C_CROSS_H_Y_MINxD) and (VxCntxD < C_CROSS_H_Y_MAXxD))) then
                    BramWrDataxDO <= C_PIXEL_WHITExD;
                end if;

                if VxCntxD < (C_BUFFER_HEIGHT / 2) then
                    BramWrAddrxD := (VxCntxD * C_BUFFER_WIDTH) + HxCntxD;
                    BramWe1xDO   <= "1";
                else
                    BramWrAddrxD := ((VxCntxD - (C_BUFFER_HEIGHT / 2)) * C_BUFFER_WIDTH) + HxCntxD;
                    BramWe2xDO   <= "1";
                end if;

                BramWrAddrxDO <= std_logic_vector(to_unsigned(BramWrAddrxD, C_BRAM_ADDR_BIT_SIZE));

                if HxCntxD < (C_BUFFER_WIDTH - 1) then
                    HxCntxD <= HxCntxD + 1;
                else
                    if VxCntxD < (C_BUFFER_HEIGHT - 1) then
                        VxCntxD <= VxCntxD + 1;
                    else
                        VxCntxD <= 0;
                        DonexS  <= '1';
                    end if;

                    HxCntxD <= 0;
                end if;
            end if;
        end if;
    end process;

end rtl;
