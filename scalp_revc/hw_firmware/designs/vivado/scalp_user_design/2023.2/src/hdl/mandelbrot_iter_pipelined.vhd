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
-- Module Name: mandelbrot_iter_pipelined - arch
-- Description: mandelbrot_iter_pipelined
--
-- Last update: 2026-05-30
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture pipelined of mandelbrot_iter is

    constant MUL_W      : integer := 2 * DATA_W;          -- 36
    constant SL_HI      : integer := FRAC_W + DATA_W - 1; -- 32
    constant SL_LO      : integer := FRAC_W;              -- 15
    constant DIV_SUM_W  : integer := MUL_W + 1;           -- 37
    constant DIV_CMP_W  : integer := MUL_W + 1 - FRAC_W;  -- 21
    constant THRESHOLD  : signed(DIV_CMP_W-1 downto 0) :=
        to_signed(4 * (2**FRAC_W), DIV_CMP_W);

    -- =========================================================================
    -- Stage 1 outputs (combinatorial)
    -- =========================================================================
    signal mul_re2  : signed(MUL_W-1 downto 0);
    signal mul_im2  : signed(MUL_W-1 downto 0);
    signal mul_reim : signed(MUL_W-1 downto 0);

    -- =========================================================================
    -- Pipeline register 1  (stage 1 → stage 2)
    -- =========================================================================
    signal r1_mul_re2  : signed(MUL_W-1 downto 0);
    signal r1_mul_im2  : signed(MUL_W-1 downto 0);
    signal r1_mul_reim : signed(MUL_W-1 downto 0);
    signal r1_c_re     : signed(DATA_W-1 downto 0);
    signal r1_c_im     : signed(DATA_W-1 downto 0);
    signal r1_valid    : std_logic;

    -- =========================================================================
    -- Stage 2 outputs (combinatorial on r1_*)
    -- =========================================================================
    signal re2_sl      : signed(DATA_W-1 downto 0);
    signal im2_sl      : signed(DATA_W-1 downto 0);
    signal reim_sl     : signed(DATA_W-1 downto 0);
    signal reim2       : signed(DATA_W downto 0);
    signal z_re_sum    : signed(DATA_W downto 0);
    signal z_im_sum    : signed(DATA_W downto 0);
    signal sum_sq_full : signed(DIV_SUM_W-1 downto 0);

    -- =========================================================================
    -- Pipeline register 2  (stage 2 → stage 3)
    -- =========================================================================
    signal r2_z_re_sum    : signed(DATA_W downto 0);
    signal r2_z_im_sum    : signed(DATA_W downto 0);
    signal r2_sum_sq_full : signed(DIV_SUM_W-1 downto 0);
    signal r2_valid       : std_logic;

    -- =========================================================================
    -- Stage 3 outputs
    -- =========================================================================
    signal sum_sq_cmp : signed(DIV_CMP_W-1 downto 0);

begin

    -- =========================================================================
    -- Stage 1 — Multiply
    -- =========================================================================
    mul_re2  <= z_re_n * z_re_n;
    mul_im2  <= z_im_n * z_im_n;
    mul_reim <= z_re_n * z_im_n;

    -- =========================================================================
    -- Register 1
    -- =========================================================================
    p_reg1 : process(clk)
    begin
        if rising_edge(clk) then
            r1_mul_re2  <= mul_re2;
            r1_mul_im2  <= mul_im2;
            r1_mul_reim <= mul_reim;
            r1_c_re     <= c_re_n;
            r1_c_im     <= c_im_n;
            r1_valid    <= i_valid;
        end if;
    end process;

    -- =========================================================================
    -- Stage 2 — Slice + arithmetic
    -- =========================================================================
    re2_sl  <= r1_mul_re2 (SL_HI downto SL_LO);
    im2_sl  <= r1_mul_im2 (SL_HI downto SL_LO);
    reim_sl <= r1_mul_reim(SL_HI downto SL_LO);

    z_re_sum <= resize(re2_sl, DATA_W+1)
              - resize(im2_sl, DATA_W+1)
              + resize(r1_c_re, DATA_W+1);

    reim2    <= shift_left(resize(reim_sl, DATA_W+1), 1);
    z_im_sum <= reim2 + resize(r1_c_im, DATA_W+1);

    sum_sq_full <= resize(r1_mul_re2, DIV_SUM_W)
                 + resize(r1_mul_im2, DIV_SUM_W);

    -- =========================================================================
    -- Register 2
    -- =========================================================================
    p_reg2 : process(clk)
    begin
        if rising_edge(clk) then
            r2_z_re_sum    <= z_re_sum;
            r2_z_im_sum    <= z_im_sum;
            r2_sum_sq_full <= sum_sq_full;
            r2_valid       <= r1_valid;
        end if;
    end process;

    -- =========================================================================
    -- Stage 3 — Output + compare
    -- =========================================================================
    sum_sq_cmp <= r2_sum_sq_full(DIV_SUM_W-1 downto FRAC_W);

    z_re_n1  <= r2_z_re_sum(DATA_W-1 downto 0);
    z_im_n1  <= r2_z_im_sum(DATA_W-1 downto 0);
    div      <= '1' when sum_sq_cmp >= THRESHOLD else '0';
    o_valid  <= r2_valid;

end architecture pipelined;
