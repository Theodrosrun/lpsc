
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
-- Module Name: mandelbrot_picture_gen_fsm - arch
-- Description: mandelbrot_picture_gen_fsm
--
-- Last update: 2026-05-30
--
----------------------------------------------------------------------------------

architecture fsm of mandelbrot_picture_gen is
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
    signal EngineIterxD   : unsigned(6 downto 0);
    signal EngineOValidxS : std_logic;

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

    ----------------------------------------------------------------------------
    -- Single-Process FSM and Datapath
    ----------------------------------------------------------------------------
    process(ClkxCI, RstxRANI)
    begin
        if RstxRANI = '0' then
            StatexS        <= IDLE;
            HxCntxD        <= 0;
            VxCntxD        <= 0;
            CurrentRexD    <= (others => '0');
            CurrentImxD    <= (others => '0');
            X0xD           <= (others => '0');
            Y0xD           <= (others => '0');
            DxxD           <= (others => '0');
            DyxD           <= (others => '0');
            EngineIValidxS <= '0';
            BramWrAddrxDO  <= (others => '0');
            BramWrDataxDO  <= (others => '0');
            BramWexSO      <= "0";
            FrameDonexSO   <= '0';
    
        elsif rising_edge(ClkxCI) then
            -- Default assignments for single-cycle strobes/outputs
            EngineIValidxS <= '0';
            BramWexSO      <= "0";
            FrameDonexSO   <= '0';

            case StatexS is
        
                ----------------------------------------------------------------
                -- Start of a new frame
                ----------------------------------------------------------------
                when IDLE =>
                    if StartxDI = '1' then
                        HxCntxD     <= 0;
                        VxCntxD     <= 0;
                        X0xD        <= X0xDI;
                        Y0xD        <= Y0xDI;
                        DxxD        <= DxxDI;
                        DyxD        <= DyxDI;
                        CurrentRexD <= X0xDI;
                        CurrentImxD <= Y0xDI;
                        StatexS     <= SEND_PIXEL;
                    end if;
        
                ----------------------------------------------------------------
                -- Send the current pixel to the Mandelbrot engine
                ----------------------------------------------------------------
                when SEND_PIXEL =>
                    if EngineReadyxS = '1' then
                        EngineIValidxS <= '1';
                        StatexS        <= WAIT_RESULT;
                    end if;
        
                ----------------------------------------------------------------
                -- Wait for the engine result
                ----------------------------------------------------------------
                when WAIT_RESULT =>
                    if EngineOValidxS = '1' then
                        StatexS <= WRITE_PIXEL;
                    end if;
        
                ----------------------------------------------------------------
                -- Write the pixel to the BRAM
                ----------------------------------------------------------------
                when WRITE_PIXEL =>
                    BramWrAddrxDO <= std_logic_vector(
                        to_unsigned(((VxCntxD * C_BUFFER_WIDTH) + HxCntxD), C_BRAM_ADDR_BIT_SIZE)
                    );
                    BramWrDataxDO <= std_logic_vector(EngineIterxD);
                    BramWexSO      <= "1";
                    StatexS        <= NEXT_PIXEL;
        
                ----------------------------------------------------------------
                -- Move to the next pixel
                ----------------------------------------------------------------
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
        
                ----------------------------------------------------------------
                -- Frame done
                ----------------------------------------------------------------
                when FRAME_DONE =>
                    FrameDonexSO <= '1';
                    StatexS      <= IDLE;
        
                when others =>
                    StatexS <= IDLE;

            end case;
        end if;
    end process;

end architecture;
