-- =============================================================================
-- Mandelbrot One-Iteration Computing Unit
-- =============================================================================
-- Z_re(n+1) = Z_re^2 - Z_im^2 + C_re
-- Z_im(n+1) = 2 * Z_re * Z_im + C_im
-- div        = (Z_re^2 + Z_im^2) >= 4
--
-- Fixed-point: Q2.16 (18-bit signed, range [-2, 2), 1 LSB = 2^-16)
-- Products (18×18) are 36-bit signed (Q4.32).
--
-- Key design choices:
--
--  1. Z_re path: uses sliced Q2.16 products.  Valid for |Zre|,|Zim| < sqrt(2),
--     which holds for all non-diverged points after the div check.
--
--  2. Z_im path: 2*Zre*Zim computed by left-shifting the Q2.16 slice of
--     Zre*Zim by 1 bit, giving a 19-bit Q3.16 value.  Valid for bounded points.
--
--  3. Divergence: uses the FULL 36-bit Q4.32 products (not sliced) to avoid
--     overflow when Zre^2 or Zim^2 exceeds 2.0.  Both products are summed into
--     a 37-bit result, then shifted right 16 to give a Q4.16 (21-bit) integer.
--     Threshold 4.0 = 4*2^16 = 262144, which fits in 21-bit signed.
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mandelbrot_iter is
    generic (
        DATA_W : integer := 18;
        FRAC_W : integer := 15
    );
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
    	i_valid : in std_logic;
    	o_valid : out std_logic;
        z_re_n  : in  signed(DATA_W-1 downto 0);
        z_im_n  : in  signed(DATA_W-1 downto 0);
        c_re_n  : in  signed(DATA_W-1 downto 0);
        c_im_n  : in  signed(DATA_W-1 downto 0);
        z_re_n1 : out signed(DATA_W-1 downto 0);
        z_im_n1 : out signed(DATA_W-1 downto 0);
        div     : out std_logic
    );
end entity mandelbrot_iter;

architecture rtl of mandelbrot_iter is

    constant MUL_W : integer := 2 * DATA_W;   -- 36

    -- Raw multiplier outputs (Q4.32)
    signal mul_re2  : signed(MUL_W-1 downto 0);
    signal mul_im2  : signed(MUL_W-1 downto 0);
    signal mul_reim : signed(MUL_W-1 downto 0);

    -- Q2.16 slice: bits [FRAC_W + DATA_W - 1 : FRAC_W] = [32:15]
    constant SL_HI : integer := FRAC_W + DATA_W - 1;   -- 32
    constant SL_LO : integer := FRAC_W;                -- 15

    signal re2_sl   : signed(DATA_W-1 downto 0);   -- Z_re^2 Q2.16
    signal im2_sl   : signed(DATA_W-1 downto 0);   -- Z_im^2 Q2.16
    signal reim_sl  : signed(DATA_W-1 downto 0);   -- Z_re*Z_im Q2.16

    -- Z_re path (1 more bit to store result)
    signal z_re_sum : signed(DATA_W downto 0);

    -- Z_im path: 2*reim_sl shifted left = 19-bit; add C_im (extend to 19-bit)
    signal reim2    : signed(DATA_W downto 0);      -- 2*Z_re*Z_im as Q3.16
    signal z_im_sum : signed(DATA_W downto 0);      -- 19-bit

    -- Divergence: full products summed (37-bit), then >> FRAC_W to get Q4.16 (21-bit)
    constant DIV_SUM_W  : integer := MUL_W + 1;    -- 37
    constant DIV_CMP_W  : integer := MUL_W + 1 - FRAC_W;  -- 21
    constant THRESHOLD  : signed(DIV_CMP_W-1 downto 0) :=
        to_signed(4 * (2**FRAC_W), DIV_CMP_W);     -- 4.0 in Q4.16 = 262144

    signal sum_sq_full  : signed(DIV_SUM_W-1 downto 0);  -- 37-bit Q4.32
    signal sum_sq_cmp   : signed(DIV_CMP_W-1 downto 0);  -- 21-bit Q4.16

begin

    -- =========================================================================
    -- Multiplications
    -- =========================================================================
    mul_re2  <= z_re_n * z_re_n;
    mul_im2  <= z_im_n * z_im_n;
    mul_reim <= z_re_n * z_im_n;

    -- =========================================================================
    -- Q2.16 slices  (valid for |val| < 2.0)
    -- =========================================================================
    re2_sl  <= mul_re2 (SL_HI downto SL_LO);
    im2_sl  <= mul_im2 (SL_HI downto SL_LO);
    reim_sl <= mul_reim(SL_HI downto SL_LO);

    -- =========================================================================
    -- Z_re(n+1) = Z_re^2 - Z_im^2 + C_re
    -- =========================================================================
    z_re_sum <= resize(re2_sl, DATA_W+1)
              - resize(im2_sl, DATA_W+1)
              + resize(c_re_n, DATA_W+1);

    z_re_n1 <= z_re_sum(DATA_W-1 downto 0);

    -- =========================================================================
    -- Z_im(n+1) = 2*Z_re*Z_im + C_im
    --   reim_sl is Q2.16 (18-bit); shift left 1 → Q3.16 (19-bit) = ×2
    -- =========================================================================
    reim2    <= shift_left(resize(reim_sl, DATA_W+1), 1);
    z_im_sum <= reim2 + resize(c_im_n, DATA_W+1);

    z_im_n1 <= z_im_sum(DATA_W-1 downto 0);

    -- =========================================================================
    -- Divergence: (Z_re^2 + Z_im^2) >= 4
    --   Use full Q4.32 products to avoid overflow in squares.
    --   Shift result right 16 (= FRAC_W) to bring into Q4.16 for comparison.
    -- =========================================================================
    sum_sq_full <= resize(mul_re2, DIV_SUM_W) + resize(mul_im2, DIV_SUM_W);

    -- Arithmetic right shift: divide by 2^16 (rounds toward -inf)
    sum_sq_cmp  <= sum_sq_full(DIV_SUM_W-1 downto FRAC_W);

    div <= '1' when sum_sq_cmp >= THRESHOLD else '0';
    o_valid <= i_valid;

end architecture rtl;
