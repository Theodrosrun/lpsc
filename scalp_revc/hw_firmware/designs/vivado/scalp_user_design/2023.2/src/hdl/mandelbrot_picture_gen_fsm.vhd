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

    signal NextStatexS        : state_t;
    signal NextHxCntxD        : integer range 0 to C_BUFFER_WIDTH;
    signal NextVxCntxD        : integer range 0 to C_BUFFER_HEIGHT;
    signal NextCurrentRexD    : signed(CurrentRexD'range);
    signal NextCurrentImxD    : signed(CurrentImxD'range);
    signal NextX0xD           : signed(X0xDI'range);
    signal NextY0xD           : signed(Y0xDI'range);
    signal NextDxxD           : signed(DXxDI'range);
    signal NextDyxD           : signed(DYxDI'range);
    signal NextEngineIValidxS : std_logic;
    signal NextBramWrAddrxD   : std_logic_vector(BramWrAddrxDO'range);
    signal NextBramWrDataxD   : std_logic_vector(BramWrDataxDO'range);
    signal NextBramWexS       : std_logic_vector(0 downto 0);
    signal NextFrameDonexS    : std_logic;

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

    process(ClkxCI, RstxRANI)
    begin
        if RstxRANI = '0' then
            StatexS         <= IDLE;
            HxCntxD         <= 0;
            VxCntxD         <= 0;
            CurrentRexD     <= (others => '0');
            CurrentImxD     <= (others => '0');
            X0xD            <= (others => '0');
            Y0xD            <= (others => '0');
            DxxD            <= (others => '0');
            DyxD            <= (others => '0');
            EngineIValidxS  <= '0';
            BramWrAddrxDO   <= (others => '0');
            BramWrDataxDO   <= (others => '0');
            BramWexSO       <= "0";
            FrameDonexSO    <= '0';
    
        elsif rising_edge(ClkxCI) then
            StatexS        <= NextStatexS;
            HxCntxD        <= NextHxCntxD;
            VxCntxD        <= NextVxCntxD;
            CurrentRexD    <= NextCurrentRexD;
            CurrentImxD    <= NextCurrentImxD;
            X0xD           <= NextX0xD;
            Y0xD           <= NextY0xD;
            DxxD           <= NextDxxD;
            DyxD           <= NextDyxD;
            EngineIValidxS <= NextEngineIValidxS;
            BramWrAddrxDO  <= NextBramWrAddrxD;
            BramWrDataxDO  <= NextBramWrDataxD;
            BramWexSO      <= NextBramWexS;
            FrameDonexSO   <= NextFrameDonexS;
        end if;
    end process;
    
    
    process(all) is
    begin
        -- Default: hold all registers, clear strobes
        NextStatexS         <= StatexS;
        NextHxCntxD         <= HxCntxD;
        NextVxCntxD         <= VxCntxD;
        NextCurrentRexD     <= CurrentRexD;
        NextCurrentImxD     <= CurrentImxD;
        NextX0xD            <= X0xD;
        NextY0xD            <= Y0xD;
        NextDxxD            <= DxxD;
        NextDyxD            <= DyxD;
        NextEngineIValidxS  <= '0';
        NextBramWrAddrxD    <= (others => '0');
        NextBramWrDataxD    <= (others => '0');
        NextBramWexS        <= "0";
        NextFrameDonexS     <= '0';
    
        case StatexS is
    
            ------------------------------------------------------------
            -- Start of a new frame
            -- Capture the parameters only once here.
            ------------------------------------------------------------
            when IDLE =>
	        if StartxDI = '1' then
                    NextHxCntxD     <= 0;
                    NextVxCntxD     <= 0;
                    NextX0xD        <= X0xDI;
                    NextY0xD        <= Y0xDI;
                    NextDxxD        <= DxxDI;
                    NextDyxD        <= DyxDI;
                    NextCurrentRexD <= X0xDI;
                    NextCurrentImxD <= Y0xDI;
                    NextStatexS     <= SEND_PIXEL;
	        end if;
    
            ------------------------------------------------------------
            -- Send the current pixel to the Mandelbrot engine
            ------------------------------------------------------------
            when SEND_PIXEL =>
                if EngineReadyxS = '1' then
                    NextEngineIValidxS <= '1';
                    NextStatexS        <= WAIT_RESULT;
                end if;
    
            ------------------------------------------------------------
            -- Wait for the engine result
            ------------------------------------------------------------
            when WAIT_RESULT =>
                if EngineOValidxS = '1' then
                    NextStatexS <= WRITE_PIXEL;
                end if;
    
            ------------------------------------------------------------
            -- Write the pixel to the BRAM
            ------------------------------------------------------------
            when WRITE_PIXEL =>
                NextBramWrAddrxD <=
                    std_logic_vector(
                        to_unsigned(((VxCntxD * C_BUFFER_WIDTH) + HxCntxD), C_BRAM_ADDR_BIT_SIZE)
                    );
                NextBramWrDataxD <= std_logic_vector(EngineIterxD);
                NextBramWexS     <= "1";
                NextStatexS      <= NEXT_PIXEL;
    
            ------------------------------------------------------------
            -- Move to the next pixel
            ------------------------------------------------------------
            when NEXT_PIXEL =>
    
                -- Next pixel on the same line
                if HxCntxD < (C_BUFFER_WIDTH - 1) then
                    NextHxCntxD     <= HxCntxD + 1;
                    NextCurrentRexD <= CurrentRexD + DxxD;
                    NextStatexS     <= SEND_PIXEL;
    
                -- End of line
                else
                    NextHxCntxD     <= 0;
                    NextCurrentRexD <= X0xD;
    
                    -- Next line
                    if VxCntxD < (C_BUFFER_HEIGHT - 1) then
                        NextVxCntxD     <= VxCntxD + 1;
                        NextCurrentImxD <= CurrentImxD + DyxD;
                        NextStatexS     <= SEND_PIXEL;
    
                    -- End of frame
                    else
                        NextVxCntxD     <= 0;
                        NextCurrentImxD <= Y0xD;
                        NextStatexS     <= FRAME_DONE;
                    end if;
                end if;
    
            ------------------------------------------------------------
            -- Frame done
            ------------------------------------------------------------
            when FRAME_DONE =>
                NextFrameDonexS <= '1';
                NextStatexS     <= IDLE;
    
        end case;
    end process;

end architecture;
