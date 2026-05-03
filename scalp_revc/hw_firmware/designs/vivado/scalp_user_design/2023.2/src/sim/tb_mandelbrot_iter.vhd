library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_mandelbrot_iter is
end entity;

architecture sim of tb_mandelbrot_iter is
    constant DATA_W : integer := 18;
    constant FRAC_W : integer := 16;
    constant SCALE  : real    := real(2**FRAC_W);

    function to_fp(r : real) return signed is
    begin
        return to_signed(integer(round(r * SCALE)), DATA_W);
    end function;

    function to_real(s : signed) return real is
    begin
        return real(to_integer(s)) / SCALE;
    end function;

    signal clk     : std_logic := '0';
    signal reset   : std_logic := '0';
    signal z_re_n  : signed(DATA_W-1 downto 0) := (others => '0');
    signal z_im_n  : signed(DATA_W-1 downto 0) := (others => '0');
    signal c_re_n  : signed(DATA_W-1 downto 0) := (others => '0');
    signal c_im_n  : signed(DATA_W-1 downto 0) := (others => '0');
    signal z_re_n1 : signed(DATA_W-1 downto 0);
    signal z_im_n1 : signed(DATA_W-1 downto 0);
    signal div     : std_logic;
    signal i_valid : std_logic;
    signal o_valid : std_logic;

    constant CLK_P : time := 10 ns;
begin
    clk <= not clk after CLK_P / 2;

    uut : entity work.mandelbrot_iter
        generic map(DATA_W => DATA_W, FRAC_W => FRAC_W)
        port map(
		clk => clk,
		reset => reset,
		i_valid => i_valid,
		o_valid => o_valid,
		z_re_n => z_re_n,
		z_im_n => z_im_n,
		c_re_n => c_re_n,
		c_im_n => c_im_n,
		z_re_n1 => z_re_n1,
		z_im_n1 => z_im_n1,
		div => div);

    process
        variable tol : real := 4.0 / SCALE;  -- 4 LSBs tolerance for rounding

        procedure chk(tzr, tzi, tcr, tci : real; nm : string;
                      chk_re, chk_im : boolean := true) is
            variable exp_re, exp_im : real;
            variable exp_div        : std_logic;
        begin
            z_re_n <= to_fp(tzr); z_im_n <= to_fp(tzi);
            c_re_n <= to_fp(tcr); c_im_n <= to_fp(tci);
	    i_valid <= '1';
            wait for 5 ns;
	    assert o_valid = '1';
            exp_re  := tzr*tzr - tzi*tzi + tcr;
            exp_im  := 2.0*tzr*tzi + tci;
            exp_div := '1' when (tzr*tzr + tzi*tzi) >= 4.0 else '0';
            if chk_re then
                assert abs(to_real(z_re_n1) - exp_re) <= tol
                    report nm & " Z_re FAIL: exp=" & real'image(exp_re)
                           & " got=" & real'image(to_real(z_re_n1)) severity error;
            end if;
            if chk_im then
                assert abs(to_real(z_im_n1) - exp_im) <= tol
                    report nm & " Z_im FAIL: exp=" & real'image(exp_im)
                           & " got=" & real'image(to_real(z_im_n1)) severity error;
            end if;
            assert div = exp_div
                report nm & " div FAIL: exp=" & std_logic'image(exp_div)
                       & " got=" & std_logic'image(div) severity error;
            report nm & " Z_re=" & real'image(to_real(z_re_n1))
                      & " Z_im=" & real'image(to_real(z_im_n1))
                      & " div=" & std_logic'image(div) severity note;
            wait for CLK_P;
        end procedure;
    begin
        reset <= '1'; wait for CLK_P; reset <= '0';

        -- T1: origin stays at origin
        chk(0.0, 0.0, 0.0, 0.0, "T1 origin");

        -- T2: c=(-2,0), Z(0)=0 => Z(1)=(-2,0), no div
        chk(0.0, 0.0, -2.0, 0.0, "T2 c=(-2,0)");

        -- T3: c=(1,1), Z(0)=0 => Z(1)=(1,1), no div
        chk(0.0, 0.0, 1.0, 1.0, "T3a c=(1,1) iter0");

        -- T4: c=(-0.5,0.5), Z(0)=0 => Z(1)=(-0.5,0.5), no div
        chk(0.0, 0.0, -0.5, 0.5, "T4a");

        -- T5: Z=(-0.5,0.5), c=(-0.5,0.5)
        -- Z_re(2) = 0.25-0.25-0.5 = -0.5
        -- Z_im(2) = 2*(-0.5)(0.5)+0.5 = -0.5+0.5 = 0.0
        -- |Z|^2 = 0.5 < 4
        chk(-0.5, 0.5, -0.5, 0.5, "T5 bounded iter");

        -- T6: Z=(0.5, 0.5), c=(0.5,0.5)
        -- Z_re(n+1) = 0.25 - 0.25 + 0.5 = 0.5
        -- Z_im(n+1) = 2*0.5*0.5 + 0.5 = 0.5 + 0.5 = 1.0
        -- |Z|^2 = 0.25+0.25 = 0.5 < 4
        chk(0.5, 0.5, 0.5, 0.5, "T6 bounded");

        -- T7: Z=(1.0, 0.5), c=(0.0, 0.0)
        -- Z_re(n+1) = 1 - 0.25 + 0 = 0.75
        -- Z_im(n+1) = 2*1*0.5 + 0 = 1.0
        -- |Z|^2 = 1.25 < 4
        chk(1.0, 0.5, 0.0, 0.0, "T7");

        -- T8: Diverged input: |Z|^2 = 1.5^2 + 1.5^2 = 4.5 >= 4 => div='1'
        -- We don't check output values (they may be garbage/wrapping)
        chk(1.5, 1.5, 0.0, 0.0, "T8 diverged", chk_re=>false, chk_im=>false);

        -- T9: Just under threshold: Z=(1.4, 0.0) => |Z|^2 = 1.96 < 4
        -- Z_re(n+1) = 1.96 + 0 = 1.96
        -- Z_im(n+1) = 0 + 0 = 0
        chk(1.4, 0.0, 0.0, 0.0, "T9 just under");

        -- T10: Exactly at threshold: Z=(2.0, 0.0) => |Z|^2 = 4.0 => div='1'
        chk(1.99, 0.0, 0.0, 0.0, "T10 boundary", chk_re=>false, chk_im=>false);

        report "=== ALL TESTS DONE ===" severity note;
        wait;
    end process;
end architecture sim;
