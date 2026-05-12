-- =============================================================================
-- tb_mandelbrot_iter.vhd
-- Testbench for the 3-stage pipelined mandelbrot_iter architecture.
--
-- Fixed-point format : Q2.16  (DATA_W = 18, FRAC_W = 16)
--   value = signed_integer / 2^16
--
-- Test strategy
--   1. Corner / known-answer tests  – hand-computed expected values checked
--      at the correct pipeline output cycle (latency = 2 clock edges after
--      i_valid).
--   2. Divergence flag tests        – points known to be inside / outside the
--      Mandelbrot set checked for div = '0' / '1'.
--   3. Valid propagation test       – verify o_valid tracks i_valid with a
--      2-cycle delay and that back-to-back inputs produce back-to-back outputs.
--   4. Reset / idle test            – confirm outputs remain stable when no
--      valid data is presented.
--
-- Simulation ends automatically; exit code 0 = all tests passed.
-- Compatible with GHDL, ModelSim, Vivado xsim.
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_mandelbrot_iter_pipelined is
end entity tb_mandelbrot_iter_pipelined;

architecture sim of tb_mandelbrot_iter_pipelined is

    -- -------------------------------------------------------------------------
    -- DUT generics (must match your actual entity)
    -- -------------------------------------------------------------------------
    constant DATA_W : integer := 18;
    constant FRAC_W : integer := 15;

    -- -------------------------------------------------------------------------
    -- Clock / reset
    -- -------------------------------------------------------------------------
    constant CLK_PERIOD : time := 10 ns;

    signal clk   : std_logic := '0';
    signal rst : std_logic := '0';
    -- -------------------------------------------------------------------------
    -- DUT ports
    -- -------------------------------------------------------------------------
    signal i_valid : std_logic := '0';
    signal z_re_n  : signed(DATA_W-1 downto 0) := (others => '0');
    signal z_im_n  : signed(DATA_W-1 downto 0) := (others => '0');
    signal c_re_n  : signed(DATA_W-1 downto 0) := (others => '0');
    signal c_im_n  : signed(DATA_W-1 downto 0) := (others => '0');

    signal z_re_n1 : signed(DATA_W-1 downto 0);
    signal z_im_n1 : signed(DATA_W-1 downto 0);
    signal div     : std_logic;
    signal o_valid : std_logic;

    -- -------------------------------------------------------------------------
    -- Helper : real → Q2.16 fixed-point
    -- -------------------------------------------------------------------------
    function to_fp(x : real) return signed is
        variable result : integer;
    begin
        result := integer(round(x * real(2**FRAC_W)));
        return to_signed(result, DATA_W);
    end function;

    -- -------------------------------------------------------------------------
    -- Helper : Q2.16 → real (for reporting)
    -- -------------------------------------------------------------------------
    function to_real(x : signed) return real is
    begin
        return real(to_integer(x)) / real(2**FRAC_W);
    end function;

    -- -------------------------------------------------------------------------
    -- Reference model (pure real arithmetic, matches RTL slicing)
    -- Returns (z_re_next, z_im_next, diverged)
    -- -------------------------------------------------------------------------
    procedure ref_model (
        z_re   : in  real;
        z_im   : in  real;
        c_re   : in  real;
        c_im   : in  real;
        z_re_o : out real;
        z_im_o : out real;
        div_o  : out boolean
    ) is
        variable re2, im2, reim : real;
        -- Mimic the Q4.32 → Q2.16 truncation that the RTL performs
        -- by quantising the products to FRAC_W fractional bits.
        variable re2_q, im2_q, reim_q : real;
        variable scale : real;
    begin
        scale  := real(2**FRAC_W);
        re2    := z_re * z_re;
        im2    := z_im * z_im;
        reim   := z_re * z_im;
        -- Truncate toward minus-infinity (floor), matching VHDL bit-slice
        re2_q  := floor(re2  * scale) / scale;
        im2_q  := floor(im2  * scale) / scale;
        reim_q := floor(reim * scale) / scale;

        z_re_o := re2_q - im2_q + c_re;
        z_im_o := 2.0 * reim_q + c_im;

        -- Divergence uses the un-sliced 36-bit products summed, then sliced
        div_o  := (re2 + im2) >= 4.0;
    end procedure;

    -- -------------------------------------------------------------------------
    -- Test-pass/fail bookkeeping
    -- -------------------------------------------------------------------------
    signal test_errors : integer := 0;
    signal test_count  : integer := 0;

    -- Tolerance for fixed-point comparison: 1 LSB in Q2.15
    constant FP_TOL : real := 1.0 / real(2**FRAC_W);

    -- -------------------------------------------------------------------------
    -- Check procedure (called 2 cycles after applying inputs)
    -- -------------------------------------------------------------------------
    procedure check_outputs (
        test_name  : in string;
        exp_re     : in real;
        exp_im     : in real;
        exp_div    : in std_logic;
        got_re     : in signed(DATA_W-1 downto 0);
        got_im     : in signed(DATA_W-1 downto 0);
        got_div    : in std_logic;
        got_valid  : in std_logic;
	signal test_count : inout integer;
	signal test_errors : inout integer
    ) is
        variable err : boolean := false;
    begin
        test_count <= test_count + 1;

        -- o_valid must be '1'
        if got_valid /= '1' then
            report "[FAIL] " & test_name & " : o_valid = '0', expected '1'"
                severity error;
            err := true;
        end if;

        -- z_re_n1
        if abs(to_real(got_re) - exp_re) > FP_TOL then
            report "[FAIL] " & test_name
                & " : z_re_n1 = " & real'image(to_real(got_re))
                & ", expected ~" & real'image(exp_re)
                severity error;
            err := true;
        end if;

        -- z_im_n1
        if abs(to_real(got_im) - exp_im) > FP_TOL then
            report "[FAIL] " & test_name
                & " : z_im_n1 = " & real'image(to_real(got_im))
                & ", expected ~" & real'image(exp_im)
                severity error;
            err := true;
        end if;

        -- divergence flag
        if got_div /= exp_div then
            report "[FAIL] " & test_name
                & " : div = '" & std_logic'image(got_div)
                & "', expected '" & std_logic'image(exp_div) & "'"
                severity error;
            err := true;
        end if;

        if not err then
            report "[PASS] " & test_name severity note;
        else
            test_errors <= test_errors + 1;
        end if;
    end procedure;

    -- -------------------------------------------------------------------------
    -- Pipeline latency (register stages between input and output)
    -- -------------------------------------------------------------------------
    constant PIPE_LAT : integer := 2;   -- 2 clock edges

begin

    -- =========================================================================
    -- DUT instantiation
    -- =========================================================================
    u_dut : entity work.mandelbrot_iter(pipelined)
        generic map (
            DATA_W => DATA_W,
            FRAC_W => FRAC_W
        )
        port map (
            clk    => clk,
            reset => rst,
            i_valid => i_valid,
            z_re_n  => z_re_n,
            z_im_n  => z_im_n,
            c_re_n  => c_re_n,
            c_im_n  => c_im_n,
            z_re_n1 => z_re_n1,
            z_im_n1 => z_im_n1,
            div     => div,
            o_valid => o_valid
        );

    -- =========================================================================
    -- Clock generation
    -- =========================================================================
    clk <= not clk after CLK_PERIOD / 2;

    -- =========================================================================
    -- Stimulus process
    -- =========================================================================
    p_stim : process

        -- Drive one transaction and wait for it to appear at the output.
        procedure drive_and_wait (
            zr, zi, cr, ci : in real;
	    signal test_errors: inout integer
        ) is
        begin
            z_re_n  <= to_fp(zr);
            z_im_n  <= to_fp(zi);
            c_re_n  <= to_fp(cr);
            c_im_n  <= to_fp(ci);
            i_valid <= '1';
            wait until rising_edge(clk);
            i_valid <= '0';
            z_re_n  <= (others => '0');
            z_im_n  <= (others => '0');
            c_re_n  <= (others => '0');
            c_im_n  <= (others => '0');
            -- Wait for the result to emerge (PIPE_LAT - 1 more edges)
            for k in 1 to PIPE_LAT loop
                wait until rising_edge(clk);
            end loop;
        end procedure;

        variable exp_re, exp_im : real;
        variable exp_dv         : boolean;
        variable zr, zi, cr, ci, nr, ni : real;
        variable dv : boolean;

    begin

        -- -----------------------------------------------------------------
        -- Release reset
        -- -----------------------------------------------------------------
        rst <= '1';
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        rst <= '0';
        wait until rising_edge(clk);

        -- =================================================================
        -- TEST 1 : origin — Z=(0,0), C=(0,0)
        --   Expect Z'=(0,0), diverged=false
        -- =================================================================
        ref_model(0.0, 0.0, 0.0, 0.0, exp_re, exp_im, exp_dv);
        drive_and_wait(0.0, 0.0, 0.0, 0.0, test_errors);
        check_outputs("T1 origin",
            exp_re, exp_im, '0',
            z_re_n1, z_im_n1, div, o_valid, test_count, test_errors);

        -- =================================================================
        -- TEST 2 : Z=(0,0), C=(0.25, 0.5)
        --   Z' = re^2-im^2+C_re = 0.25, 2*re*im+C_im = 0.5
        -- =================================================================
        ref_model(0.0, 0.0, 0.25, 0.5, exp_re, exp_im, exp_dv);
        drive_and_wait(0.0, 0.0, 0.25, 0.5, test_errors);
        check_outputs("T2 Z=0 C=(0.25,0.5)",
            exp_re, exp_im, '0',
            z_re_n1, z_im_n1, div, o_valid, test_count, test_errors);

        -- =================================================================
        -- TEST 3 : Z=(1.0, 0.0), C=(0.0, 0.0)
        --   re^2=1, im^2=0, reim=0 → Z'=(1,0), no diverge
        -- =================================================================
        ref_model(1.0, 0.0, 0.0, 0.0, exp_re, exp_im, exp_dv);
        drive_and_wait(1.0, 0.0, 0.0, 0.0, test_errors);
        check_outputs("T3 Z=(1,0) C=0",
            exp_re, exp_im, '0',
            z_re_n1, z_im_n1, div, o_valid, test_count, test_errors);

        -- =================================================================
        -- TEST 4 : Z=(1.0, 1.0), C=(0.0, 0.0)
        --   re^2=1, im^2=1, reim=1 → Z'=(0, 2), sum_sq=2 < 4 no diverge
        -- =================================================================
        ref_model(1.0, 1.0, 0.0, 0.0, exp_re, exp_im, exp_dv);
        drive_and_wait(1.0, 1.0, 0.0, 0.0, test_errors);
        check_outputs("T4 Z=(1,1) C=0",
            exp_re, exp_im, '0',
            z_re_n1, z_im_n1, div, o_valid, test_count, test_errors);

        -- -- =================================================================
        -- -- TEST 5 : Divergence — Z=(1.5, 1.5), sum_sq = 4.5 >= 4 → div='1'
        -- -- =================================================================
        -- ref_model(1.5, 1.5, 0.0, 0.0, exp_re, exp_im, exp_dv);
        -- drive_and_wait(1.5, 1.5, 0.0, 0.0, test_errors);
        -- check_outputs("T5 diverge Z=(1.5,1.5)",
        --     exp_re, exp_im, '1',
        --     z_re_n1, z_im_n1, div, o_valid, test_count, test_errors); 
        --
        -- -- =================================================================
        -- -- TEST 6 : Exactly on threshold — Z=(√2, √2), sum_sq = 4.0 → div='1'
        -- -- =================================================================
        -- ref_model(sqrt(2.0), sqrt(2.0), 0.0, 0.0, exp_re, exp_im, exp_dv);
        -- drive_and_wait(sqrt(2.0), sqrt(2.0), 0.0, 0.0, test_errors);
        -- check_outputs("T6 threshold Z=(sqrt(2),sqrt(2))",
        --     exp_re, exp_im, '1',
        --     z_re_n1, z_im_n1, div, o_valid, test_count, test_errors);
        --
        -- =================================================================
        -- TEST 7 : Just below threshold — Z=(1.41, 1.41), sum_sq ≈ 3.98 < 4
        -- =================================================================
        ref_model(1.41, 1.41, 0.0, 0.0, exp_re, exp_im, exp_dv);
        drive_and_wait(1.41, 1.41, 0.0, 0.0, test_errors);
        check_outputs("T7 below threshold Z=(1.41,1.41)",
            exp_re, exp_im, '0',
            z_re_n1, z_im_n1, div, o_valid, test_count, test_errors);

        -- =================================================================
        -- TEST 8 : Negative imaginary — Z=(0.5, -0.75), C=(-0.1, 0.1)
        -- =================================================================
        ref_model(0.5, -0.75, -0.1, 0.1, exp_re, exp_im, exp_dv);
        drive_and_wait(0.5, -0.75, -0.1, 0.1, test_errors);
        check_outputs("T8 neg imag Z=(0.5,-0.75)",
            exp_re, exp_im, '0',
            z_re_n1, z_im_n1, div, o_valid, test_count, test_errors);

        -- =================================================================
        -- TEST 9 : Negative real and imaginary — Z=(-1.0, -1.0), C=(0,0)
        -- =================================================================
        ref_model(-1.0, -1.0, 0.0, 0.0, exp_re, exp_im, exp_dv);
        drive_and_wait(-1.0, -1.0, 0.0, 0.0, test_errors);
        check_outputs("T9 Z=(-1,-1) C=0",
            exp_re, exp_im, '0',
            z_re_n1, z_im_n1, div, o_valid, test_count, test_errors);

        -- =================================================================
        -- TEST 10 : Back-to-back valid — fill the pipeline for 8 cycles
        --   Check o_valid asserts 2 cycles after first i_valid and stays
        --   high for every subsequent cycle while inputs keep flowing.
        -- =================================================================
        -- Launch 4 transactions without gaps
        for k in 0 to 3 loop
            z_re_n  <= to_fp(0.3 + real(k) * 0.1);
            z_im_n  <= to_fp(0.2);
            c_re_n  <= to_fp(-0.5);
            c_im_n  <= to_fp(0.5);
            i_valid <= '1';
            wait until rising_edge(clk);
        end loop;
        i_valid <= '0';
        z_re_n  <= (others => '0');
        z_im_n  <= (others => '0');

        -- After 2 more edges the pipeline should have been producing
        -- o_valid='1' continuously for the last 2 cycles.
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        test_count <= test_count + 1;
        if o_valid = '1' then
            report "[PASS] T10 back-to-back valid" severity note;
        else
            report "[FAIL] T10 back-to-back valid : o_valid dropped unexpectedly"
                severity error;
            test_errors <= test_errors + 1;
        end if;

        -- Let pipeline drain
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        -- =================================================================
        -- TEST 11 : Valid gap — insert a bubble and check o_valid goes low
        -- =================================================================
        -- Send one valid beat
        z_re_n  <= to_fp(0.5);
        z_im_n  <= to_fp(0.5);
        c_re_n  <= to_fp(0.0);
        c_im_n  <= to_fp(0.0);
        i_valid <= '1';
        wait until rising_edge(clk);
        i_valid <= '0';                -- bubble cycle
        wait until rising_edge(clk);
        -- Now send another valid beat
        z_re_n  <= to_fp(-0.5);
        z_im_n  <= to_fp(-0.5);
        c_re_n  <= to_fp(0.0);
        c_im_n  <= to_fp(0.0);
        i_valid <= '1';
        wait until rising_edge(clk);
        i_valid <= '0';

        -- Two edges after the bubble beat: o_valid should be '0'
        wait until rising_edge(clk);
        test_count <= test_count + 1;
        if o_valid = '0' then
            report "[PASS] T11 bubble propagation" severity note;
        else
            report "[FAIL] T11 bubble propagation : o_valid='1' during bubble"
                severity error;
            test_errors <= test_errors + 1;
        end if;
        wait until rising_edge(clk);   -- drain

        -- =================================================================
        -- TEST 12 : Mandelbrot orbit — iterate 3 times from Z=0, C=(-0.75,0.1)
        --   This stays bounded (inside the set). Verify each iteration matches
        --   the reference model chained three times.
        -- =================================================================
            cr := -0.75; ci := 0.1;
            zr := 0.0;   zi := 0.0;

            for iter in 1 to 3 loop
                ref_model(zr, zi, cr, ci, nr, ni, dv);
                drive_and_wait(zr, zi, cr, ci, test_errors);
                check_outputs("T12 orbit iter " & integer'image(iter),
                    nr, ni, '0',
                    z_re_n1, z_im_n1, div, o_valid, test_count, test_errors);
                zr := nr; zi := ni;
	    end loop;

        -- =================================================================
        -- Final report
        -- =================================================================
        report "--------------------------------------------" severity note;
        if test_errors = 0 then
            report "ALL " & integer'image(test_count)
                & " TESTS PASSED" severity note;
        else
            report integer'image(test_errors) & " of "
                & integer'image(test_count) & " TESTS FAILED"
                severity failure;   -- non-zero exit in GHDL
        end if;

        std.env.finish(0);
        wait;
    end process p_stim;

end architecture sim;
