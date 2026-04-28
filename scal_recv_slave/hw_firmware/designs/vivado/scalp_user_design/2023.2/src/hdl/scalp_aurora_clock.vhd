-- (c) Copyright 2023 Advanced Micro Devices, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Advanced Micro Devices, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- AMD, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) AMD shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or AMD had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- AMD products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of AMD products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
--
--

--
--  CLOCK_MODULE
--
--
--
--  Description: A module provided as a convenience for desingners using 4-byte
--               lane Aurora Modules. This module takes the V5 reference clock as
--               input, and produces a fabric clock on a global clock net suitable
--               for driving application logic connected to the Aurora User Interface.
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

-- synthesis translate_off
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
-- synthesis translate_on

entity aurora_8b10b_0_CLOCK_MODULE is

    port (
            GT_CLK                 : in std_logic;
            GT_CLK_LOCKED          : in std_logic;
            USER_CLK               : out std_logic;
            SYNC_CLK               : out std_logic;
            PLL_NOT_LOCKED         : out std_logic
         );

end aurora_8b10b_0_CLOCK_MODULE;

architecture MAPPED of aurora_8b10b_0_CLOCK_MODULE is
  attribute core_generation_info           : string;
  attribute core_generation_info of MAPPED : architecture is "aurora_8b10b_0,aurora_8b10b_v11_1_25,{user_interface=AXI_4_Streaming,backchannel_mode=Sidebands,c_aurora_lanes=1,c_column_used=None,c_gt_clock_1=GTPQ0,c_gt_clock_2=None,c_gt_loc_1=1,c_gt_loc_10=X,c_gt_loc_11=X,c_gt_loc_12=X,c_gt_loc_13=X,c_gt_loc_14=X,c_gt_loc_15=X,c_gt_loc_16=X,c_gt_loc_17=X,c_gt_loc_18=X,c_gt_loc_19=X,c_gt_loc_2=X,c_gt_loc_20=X,c_gt_loc_21=X,c_gt_loc_22=X,c_gt_loc_23=X,c_gt_loc_24=X,c_gt_loc_25=X,c_gt_loc_26=X,c_gt_loc_27=X,c_gt_loc_28=X,c_gt_loc_29=X,c_gt_loc_3=X,c_gt_loc_30=X,c_gt_loc_31=X,c_gt_loc_32=X,c_gt_loc_33=X,c_gt_loc_34=X,c_gt_loc_35=X,c_gt_loc_36=X,c_gt_loc_37=X,c_gt_loc_38=X,c_gt_loc_39=X,c_gt_loc_4=X,c_gt_loc_40=X,c_gt_loc_41=X,c_gt_loc_42=X,c_gt_loc_43=X,c_gt_loc_44=X,c_gt_loc_45=X,c_gt_loc_46=X,c_gt_loc_47=X,c_gt_loc_48=X,c_gt_loc_5=X,c_gt_loc_6=X,c_gt_loc_7=X,c_gt_loc_8=X,c_gt_loc_9=X,c_lane_width=4,c_line_rate=50000,c_nfc=true,c_nfc_mode=IMM,c_refclk_frequency=125000,c_simplex=false,c_simplex_mode=TX,c_stream=false,c_ufc=false,flow_mode=Immediate_NFC,interface_mode=Framing,dataflow_config=Duplex}";

    component IBUFDS
        port (

                O : out std_ulogic;
                I : in std_ulogic;
                IB : in std_ulogic);

    end component;



    component BUFG

        port (

                O : out std_ulogic;
                I : in  std_ulogic

             );

    end component;

----- component MMCME2_ADV -----
component MMCME2_ADV
  generic (
     BANDWIDTH : string := "OPTIMIZED";
     CLKFBOUT_MULT_F : real := 5.000;
     CLKFBOUT_PHASE : real := 0.000;
     CLKFBOUT_USE_FINE_PS : boolean := FALSE;
     CLKIN1_PERIOD : real := 0.000;
     CLKIN2_PERIOD : real := 0.000;
     CLKOUT0_DIVIDE_F : real := 1.000;
     CLKOUT0_DUTY_CYCLE : real := 0.500;
     CLKOUT0_PHASE : real := 0.000;
     CLKOUT0_USE_FINE_PS : boolean := FALSE;
     CLKOUT1_DIVIDE : integer := 1;
     CLKOUT1_DUTY_CYCLE : real := 0.500;
     CLKOUT1_PHASE : real := 0.000;
     CLKOUT1_USE_FINE_PS : boolean := FALSE;
     CLKOUT2_DIVIDE : integer := 1;
     CLKOUT2_DUTY_CYCLE : real := 0.500;
     CLKOUT2_PHASE : real := 0.000;
     CLKOUT2_USE_FINE_PS : boolean := FALSE;
     CLKOUT3_DIVIDE : integer := 1;
     CLKOUT3_DUTY_CYCLE : real := 0.500;
     CLKOUT3_PHASE : real := 0.000;
     CLKOUT3_USE_FINE_PS : boolean := FALSE;
     CLKOUT4_CASCADE : boolean := FALSE;
     CLKOUT4_DIVIDE : integer := 1;
     CLKOUT4_DUTY_CYCLE : real := 0.500;
     CLKOUT4_PHASE : real := 0.000;
     CLKOUT4_USE_FINE_PS : boolean := FALSE;
     CLKOUT5_DIVIDE : integer := 1;
     CLKOUT5_DUTY_CYCLE : real := 0.500;
     CLKOUT5_PHASE : real := 0.000;
     CLKOUT5_USE_FINE_PS : boolean := FALSE;
     CLKOUT6_DIVIDE : integer := 1;
     CLKOUT6_DUTY_CYCLE : real := 0.500;
     CLKOUT6_PHASE : real := 0.000;
     CLKOUT6_USE_FINE_PS : boolean := FALSE;
     COMPENSATION : string := "ZHOLD";
     DIVCLK_DIVIDE : integer := 1;
     REF_JITTER1 : real := 0.0;
     REF_JITTER2 : real := 0.0;
     SS_EN : string := "FALSE";
     SS_MODE : string := "CENTER_HIGH";
     SS_MOD_PERIOD : integer := 10000;
     STARTUP_WAIT : boolean := FALSE
  );
  port (
     CLKFBOUT : out std_ulogic := '0';
     CLKFBOUTB : out std_ulogic := '0';
     CLKFBSTOPPED : out std_ulogic := '0';
     CLKINSTOPPED : out std_ulogic := '0';
     CLKOUT0 : out std_ulogic := '0';
     CLKOUT0B : out std_ulogic := '0';
     CLKOUT1 : out std_ulogic := '0';
     CLKOUT1B : out std_ulogic := '0';
     CLKOUT2 : out std_ulogic := '0';
     CLKOUT2B : out std_ulogic := '0';
     CLKOUT3 : out std_ulogic := '0';
     CLKOUT3B : out std_ulogic := '0';
     CLKOUT4 : out std_ulogic := '0';
     CLKOUT5 : out std_ulogic := '0';
     CLKOUT6 : out std_ulogic := '0';
     DO : out std_logic_vector (15 downto 0);
     DRDY : out std_ulogic := '0';
     LOCKED : out std_ulogic := '0';
     PSDONE : out std_ulogic := '0';
     CLKFBIN : in std_ulogic;
     CLKIN1 : in std_ulogic;
     CLKIN2 : in std_ulogic;
     CLKINSEL : in std_ulogic;
     DADDR : in std_logic_vector(6 downto 0);
     DCLK : in std_ulogic;
     DEN : in std_ulogic;
     DI : in std_logic_vector(15 downto 0);
     DWE : in std_ulogic;
     PSCLK : in std_ulogic;
     PSEN : in std_ulogic;
     PSINCDEC : in std_ulogic;
     PWRDWN : in std_ulogic;
     RST : in std_ulogic
  );
end component;

  signal  locked_w     : std_logic;
  signal reset_n                  : std_logic;

  -- Input clock buffering / unused connectors
  signal clkin1      : std_logic;
  -- Output clock buffering / unused connectors
  signal clkfbout         : std_logic;
  signal clkfboutb_unused : std_logic;
  signal clkout0          : std_logic;
  signal clkout0b_unused  : std_logic;
  signal clkout1          : std_logic;
  signal clkout1b_unused  : std_logic;
  signal clkout2          : std_logic;
  signal clkout2b_unused  : std_logic;
  signal clkout3          : std_logic;
  signal clkout3b_unused  : std_logic;
  signal clkout4_unused   : std_logic;
  signal clkout5_unused   : std_logic;
  signal clkout6_unused   : std_logic;
  -- Dynamic programming unused signals
  signal do_unused        : std_logic_vector(15 downto 0);
  signal drdy_unused      : std_logic;
  -- Dynamic phase shift unused signals
  signal psdone_unused    : std_logic;
  -- Unused status signals
  signal clkfbstopped_unused : std_logic;
  signal clkinstopped_unused : std_logic;
  --***************************** Parameter Declarations ************************
constant MULT         : real    :=  8.0;
constant DIVIDE       : integer :=  2;
constant CLK_PERIOD   : real    :=  4.000	;
constant OUT0_DIVIDE  : real    :=  8.0;
constant OUT1_DIVIDE  : integer :=  4;
constant OUT2_DIVIDE  : integer :=  8;
constant OUT3_DIVIDE  : integer :=  4;

begin

      reset_n        <= not GT_CLK_LOCKED;

  -- Input buffering
  --------------------------------------
  clkin1_buf : BUFG
  port map
   (O => clkin1,
    I => GT_CLK);

  -- Clocking primitive
  --------------------------------------
  -- Instantiation of the MMCM primitive
  --    * Unused inputs are tied off
  --    * Unused outputs are labeled unused

  mmcm_adv_inst : MMCME2_ADV
  generic map
   (BANDWIDTH            => "OPTIMIZED",
    CLKOUT4_CASCADE      => FALSE,
    COMPENSATION         => "ZHOLD",
    STARTUP_WAIT         => FALSE,
    DIVCLK_DIVIDE        => DIVIDE,
    CLKFBOUT_MULT_F      => MULT,
    CLKFBOUT_PHASE       => 0.000,
    CLKFBOUT_USE_FINE_PS => FALSE,
    CLKOUT0_DIVIDE_F     => OUT0_DIVIDE,
    CLKOUT0_PHASE        => 0.000,
    CLKOUT0_DUTY_CYCLE   => 0.500,
    CLKOUT0_USE_FINE_PS  => FALSE,
    CLKIN1_PERIOD        => CLK_PERIOD,
    CLKOUT1_DIVIDE       => OUT1_DIVIDE,
    CLKOUT1_PHASE        => 0.000,
    CLKOUT1_DUTY_CYCLE   => 0.500,
    CLKOUT1_USE_FINE_PS  => FALSE,
    CLKOUT2_DIVIDE       => OUT2_DIVIDE,
    CLKOUT2_PHASE        => 0.000,
    CLKOUT2_DUTY_CYCLE   => 0.500,
    CLKOUT2_USE_FINE_PS  => FALSE,
    CLKOUT3_DIVIDE       => OUT3_DIVIDE,
    CLKOUT3_PHASE        => 0.000,
    CLKOUT3_DUTY_CYCLE   => 0.500,
    CLKOUT3_USE_FINE_PS  => FALSE,
    REF_JITTER1          => 0.010)
  port map
    -- Output clocks
   (CLKFBOUT            => clkfbout,
    CLKFBOUTB           => clkfboutb_unused,
    CLKOUT0             => clkout0,
    CLKOUT0B            => clkout0b_unused,
    CLKOUT1             => clkout1,
    CLKOUT1B            => clkout1b_unused,
    CLKOUT2             => clkout2,
    CLKOUT2B            => clkout2b_unused,
    CLKOUT3             => clkout3,
    CLKOUT3B            => clkout3b_unused,
    CLKOUT4             => clkout4_unused,
    CLKOUT5             => clkout5_unused,
    CLKOUT6             => clkout6_unused,
    -- Input clock control
    CLKFBIN             => clkfbout,
    CLKIN1              => clkin1,
    CLKIN2              => '0',
    -- Tied to always select the primary input clock
    CLKINSEL            => '1',
    -- Ports for dynamic reconfiguration
    DADDR               => (others => '0'),
    DCLK                => '0',
    DEN                 => '0',
    DI                  => (others => '0'),
    DO                  => do_unused,
    DRDY                => drdy_unused,
    DWE                 => '0',
    -- Ports for dynamic phase shift
    PSCLK               => '0',
    PSEN                => '0',
    PSINCDEC            => '0',
    PSDONE              => psdone_unused,
    -- Other control and status signals
    LOCKED              => locked_w,
    CLKINSTOPPED        => clkinstopped_unused,
    CLKFBSTOPPED        => clkfbstopped_unused,
    PWRDWN              => '0',
    RST                 => reset_n);


  clkout0_buf : BUFG
  port map
   (O   => USER_CLK,
    I   => clkout0);

  clkout1_buf : BUFG
  port map
   (O   => SYNC_CLK,
    I   => clkout1);

  -- The PLL_NOT_LOCKED signal is created by inverting the PLL's locked signal.
  PLL_NOT_LOCKED  <=   not locked_w;


end MAPPED;
