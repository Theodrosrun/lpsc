library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mandelbrot_engine is
    generic (
        DATA_W   : integer := 18;
        FRAC_W   : integer := 15;
        MAX_ITER : integer := 100
    );
    port (
        clk      : in  std_logic;
        reset    : in  std_logic;

        -- Input: Pixel Coordinates (C)
        i_re     : in  signed(DATA_W-1 downto 0);
        i_im     : in  signed(DATA_W-1 downto 0);

        i_valid  : in  std_logic;

        o_ready  : out std_logic;
        -- Output: Iteration Count for Coloring
        o_iter   : out unsigned(7 downto 0);
        o_valid  : out std_logic
    );
end entity mandelbrot_engine;

architecture rtl of mandelbrot_engine is

    type state_t is (IDLE, ITERATE, FINISH);
    signal state : state_t;

    -- Internal Registers
    signal reg_c_re, reg_c_im : signed(DATA_W-1 downto 0);
    signal reg_z_re, reg_z_im : signed(DATA_W-1 downto 0);
    signal iter_count         : unsigned(7 downto 0);

    -- Pipelined Math Signals
    signal math_i_valid : std_logic;
    signal math_o_valid : std_logic;
    signal math_z_re_next, math_z_im_next : signed(DATA_W-1 downto 0);
    signal math_div     : std_logic;

begin

    -- Instantiate your math unit
    u_math : entity work.mandelbrot_iter
        generic map (DATA_W => DATA_W, FRAC_W => FRAC_W)
        port map (
            clk     => clk,
            reset   => reset,
            i_valid => math_i_valid,
            o_valid => math_o_valid,
            z_re_n  => reg_z_re,
            z_im_n  => reg_z_im,
            c_re_n  => reg_c_re,
            c_im_n  => reg_c_im,
            z_re_n1 => math_z_re_next,
            z_im_n1 => math_z_im_next,
            div     => math_div
        );

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state        <= IDLE;
                o_valid      <= '0';
                o_ready      <= '1';
                math_i_valid <= '0';
            else
                case state is
                    when IDLE =>
                        o_valid <= '0';
                        if i_valid = '1' then
                            reg_c_re     <= to_signed(11633, DATA_W); -- 0.355 * 2^15
                            reg_c_im     <= to_signed(11633, DATA_W); -- 0.355 * 2^15
                            reg_z_re     <= i_re;
                            reg_z_im     <= i_im;
                            iter_count   <= (others => '0');
                            o_ready      <= '0';
                            math_i_valid <= '1'; -- Kick off first math cycle
                            state        <= ITERATE;
                        else
                            o_ready      <= '1';
                        end if;

                    when ITERATE =>
                        math_i_valid <= '0'; -- Clear pulse
                        
                        -- Wait for the pipelined math to finish one step
                        if math_o_valid = '1' then
                            if (math_div = '1') or (iter_count = MAX_ITER) then
                                state <= FINISH;
                                if iter_count = MAX_ITER then
                                    iter_count <= (others=> '0');
                                end if;
                            else
                                -- Feed back result and trigger next iteration
                                reg_z_re     <= math_z_re_next;
                                reg_z_im     <= math_z_im_next;
                                iter_count   <= iter_count + 1;
                                math_i_valid <= '1'; 
                            end if;
                        end if;

                    when FINISH =>
                        o_iter  <= iter_count;
                        o_valid <= '1';
                        state   <= IDLE;

                end case;
            end if;
        end if;
    end process;

end architecture;
