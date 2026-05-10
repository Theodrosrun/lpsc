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

        BramWrAddrxDO : out std_logic_vector((C_BRAM_ADDR_BIT_SIZE - 1) downto 0);
        BramWrDataxDO : out std_logic_vector(8 downto 0);
        BramWexSO     : out std_logic_vector(0 downto 0);

        FrameDonexSO  : out std_logic
    );
end entity;

architecture rtl of mandelbrot_picture_gen is

    type state_t is (
        IDLE,
        SEND_PIXEL,
        WAIT_RESULT,
        WRITE_PIXEL,
        NEXT_PIXEL,
        FRAME_DONE
    );

    signal StatexS : state_t := IDLE;

    signal HxCntxD : integer range 0 to (C_BUFFER_WIDTH - 1) := 0;
    signal VxCntxD : integer range 0 to (C_BUFFER_HEIGHT - 1) := 0;

    signal CurrentRexD : signed(DATA_W-1 downto 0) := (others => '0');
    signal CurrentImxD : signed(DATA_W-1 downto 0) := (others => '0');

    signal EngineIValidxS : std_logic := '0';
    signal EngineReadyxS  : std_logic;
    signal EngineIterxD   : unsigned(7 downto 0);
    signal EngineOValidxS : std_logic;

    signal PalettePixelxD : std_logic_vector(8 downto 0);

    signal X0xD : signed(DATA_W-1 downto 0) := (others => '0');
    signal Y0xD : signed(DATA_W-1 downto 0) := (others => '0');
    signal DxxD : signed(DATA_W-1 downto 0) := (others => '0');
    signal DyxD : signed(DATA_W-1 downto 0) := (others => '0');
begin

    MandelbrotEnginexI : entity work.mandelbrot_engine
        generic map (
            DATA_W   => DATA_W,
            FRAC_W   => FRAC_W,
            MAX_ITER => MAX_ITER
        )
        port map (
            clk      => ClkxCI,
            reset    => not RstxRANI,

            i_re     => CurrentRexD,
            i_im     => CurrentImxD,
            i_valid  => EngineIValidxS,
            o_ready  => EngineReadyxS,

            o_iter   => EngineIterxD,
            o_valid  => EngineOValidxS
        );

    MandelbrotPalettexI : entity work.mandelbrot_palette
        generic map (
            MAX_ITER => MAX_ITER
        )
        port map (
            iter  => EngineIterxD,
            pixel => PalettePixelxD
        );

        process(ClkxCI, RstxRANI)
        begin
            if RstxRANI = '0' then
                StatexS         <= IDLE;
                HxCntxD         <= 0;
                VxCntxD         <= 0;

                CurrentRexD     <= (others => '0');
                CurrentImxD     <= (others => '0');

                X0xD         <= (others => '0');
                Y0xD         <= (others => '0');
                DxxD         <= (others => '0');
                DyxD         <= (others => '0');

                EngineIValidxS  <= '0';

                BramWrAddrxDO   <= (others => '0');
                BramWrDataxDO   <= (others => '0');
                BramWexSO       <= "0";

                FrameDonexSO    <= '0';

            elsif rising_edge(ClkxCI) then
                EngineIValidxS <= '0';
                BramWexSO      <= "0";
                FrameDonexSO   <= '0';

                case StatexS is

                    ------------------------------------------------------------
                    -- Start of a new frame
                    -- Capture the parameters only once here.
                    ------------------------------------------------------------
                    when IDLE =>
                        HxCntxD <= 0;
                        VxCntxD <= 0;

                        X0xD <= X0xDI;
                        Y0xD <= Y0xDI;
                        DxxD <= DxxDI;
                        DyxD <= DyxDI;

                        CurrentRexD <= X0xDI;
                        CurrentImxD <= Y0xDI;

                        StatexS <= SEND_PIXEL;

                    ------------------------------------------------------------
                    -- Send the current pixel to the Mandelbrot engine
                    ------------------------------------------------------------
                    when SEND_PIXEL =>
                        if EngineReadyxS = '1' then
                            EngineIValidxS <= '1';
                            StatexS        <= WAIT_RESULT;
                        end if;

                    ------------------------------------------------------------
                    -- Wait for the engine result
                    ------------------------------------------------------------
                    when WAIT_RESULT =>
                        if EngineOValidxS = '1' then
                            StatexS <= WRITE_PIXEL;
                        end if;

                    ------------------------------------------------------------
                    -- Write the pixel to the BRAM
                    ------------------------------------------------------------
                    when WRITE_PIXEL =>
                        BramWrAddrxDO <= 
                        std_logic_vector(
                            to_unsigned(((VxCntxD * C_BUFFER_WIDTH) + HxCntxD), C_BRAM_ADDR_BIT_SIZE)
                        );

                        BramWrDataxDO <= PalettePixelxD;
                        BramWexSO     <= "1";

                        StatexS <= NEXT_PIXEL;

                    ------------------------------------------------------------
                    -- Move to the next pixel
                    ------------------------------------------------------------
                    when NEXT_PIXEL =>

                        -- Next pixel on the same line
                        if HxCntxD < (C_BUFFER_WIDTH - 1) then

                            HxCntxD     <= HxCntxD + 1;
                            CurrentRexD <= CurrentRexD + DxxD;
                            StatexS     <= SEND_PIXEL;

                        -- End of line
                        else

                            HxCntxD     <= 0;
                            CurrentRexD <= X0xD;

                            -- Next line
                            if VxCntxD < (C_BUFFER_HEIGHT - 1) then

                                VxCntxD     <= VxCntxD + 1;
                                CurrentImxD <= CurrentImxD + DyxD;
                                StatexS     <= SEND_PIXEL;

                            -- End of frame
                            else

                                VxCntxD     <= 0;
                                CurrentImxD <= Y0xD;
                                StatexS     <= FRAME_DONE;

                            end if;
                        end if;

                    ------------------------------------------------------------
                    -- Frame done
                    ------------------------------------------------------------
                    when FRAME_DONE =>
                        FrameDonexSO <= '1';
                        StatexS      <= IDLE;

                end case;
            end if;
        end process;

end architecture;