-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
-- Date        : Tue Apr 14 18:32:21 2026
-- Host        : andre running 64-bit Fedora Linux 42 (Workstation Edition)
-- Command     : write_vhdl -force -mode synth_stub
--               /home/andre/dev/mse/ma-lpsc/lpsc/scalp_revc/hw_firmware/designs/vivado/scalp_user_design/2023.2/lin64/scalp_user_design/scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0_stub.vhdl
-- Design      : aurora_8b10b_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z015clg485-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity aurora_8b10b_0 is
  Port ( 
    s_axi_tx_tdata : in STD_LOGIC_VECTOR ( 0 to 31 );
    s_axi_tx_tvalid : in STD_LOGIC;
    s_axi_tx_tready : out STD_LOGIC;
    s_axi_tx_tkeep : in STD_LOGIC_VECTOR ( 0 to 3 );
    s_axi_tx_tlast : in STD_LOGIC;
    m_axi_rx_tdata : out STD_LOGIC_VECTOR ( 0 to 31 );
    m_axi_rx_tvalid : out STD_LOGIC;
    m_axi_rx_tkeep : out STD_LOGIC_VECTOR ( 0 to 3 );
    m_axi_rx_tlast : out STD_LOGIC;
    s_axi_nfc_tx_tvalid : in STD_LOGIC;
    s_axi_nfc_tx_tdata : in STD_LOGIC_VECTOR ( 0 to 3 );
    s_axi_nfc_tx_tready : out STD_LOGIC;
    m_axi_nfc_rx_tvalid : out STD_LOGIC;
    m_axi_nfc_rx_tdata : out STD_LOGIC_VECTOR ( 0 to 3 );
    rxp : in STD_LOGIC_VECTOR ( 0 to 0 );
    rxn : in STD_LOGIC_VECTOR ( 0 to 0 );
    txp : out STD_LOGIC_VECTOR ( 0 to 0 );
    txn : out STD_LOGIC_VECTOR ( 0 to 0 );
    gt_refclk1 : in STD_LOGIC;
    frame_err : out STD_LOGIC;
    hard_err : out STD_LOGIC;
    soft_err : out STD_LOGIC;
    channel_up : out STD_LOGIC;
    lane_up : out STD_LOGIC_VECTOR ( 0 to 0 );
    user_clk : in STD_LOGIC;
    sync_clk : in STD_LOGIC;
    reset : in STD_LOGIC;
    power_down : in STD_LOGIC;
    loopback : in STD_LOGIC_VECTOR ( 2 downto 0 );
    gt_reset : in STD_LOGIC;
    tx_lock : out STD_LOGIC;
    sys_reset_out : out STD_LOGIC;
    init_clk_in : in STD_LOGIC;
    tx_resetdone_out : out STD_LOGIC;
    rx_resetdone_out : out STD_LOGIC;
    link_reset_out : out STD_LOGIC;
    drpclk_in : in STD_LOGIC;
    drpaddr_in : in STD_LOGIC_VECTOR ( 8 downto 0 );
    drpdi_in : in STD_LOGIC_VECTOR ( 15 downto 0 );
    drpdo_out : out STD_LOGIC_VECTOR ( 15 downto 0 );
    drpen_in : in STD_LOGIC;
    drprdy_out : out STD_LOGIC;
    drpwe_in : in STD_LOGIC;
    gt_common_reset_out : out STD_LOGIC;
    gt0_pll0refclklost_in : in STD_LOGIC;
    quad1_common_lock_in : in STD_LOGIC;
    GT0_PLL0OUTCLK_IN : in STD_LOGIC;
    GT0_PLL1OUTCLK_IN : in STD_LOGIC;
    GT0_PLL0OUTREFCLK_IN : in STD_LOGIC;
    GT0_PLL1OUTREFCLK_IN : in STD_LOGIC;
    tx_out_clk : out STD_LOGIC;
    pll_not_locked : in STD_LOGIC
  );

  attribute core_generation_info : string;
  attribute core_generation_info of aurora_8b10b_0 : entity is "aurora_8b10b_0,aurora_8b10b_v11_1_25,{user_interface=AXI_4_Streaming,backchannel_mode=Sidebands,c_aurora_lanes=1,c_column_used=None,c_gt_clock_1=GTPQ0,c_gt_clock_2=None,c_gt_loc_1=1,c_gt_loc_10=X,c_gt_loc_11=X,c_gt_loc_12=X,c_gt_loc_13=X,c_gt_loc_14=X,c_gt_loc_15=X,c_gt_loc_16=X,c_gt_loc_17=X,c_gt_loc_18=X,c_gt_loc_19=X,c_gt_loc_2=X,c_gt_loc_20=X,c_gt_loc_21=X,c_gt_loc_22=X,c_gt_loc_23=X,c_gt_loc_24=X,c_gt_loc_25=X,c_gt_loc_26=X,c_gt_loc_27=X,c_gt_loc_28=X,c_gt_loc_29=X,c_gt_loc_3=X,c_gt_loc_30=X,c_gt_loc_31=X,c_gt_loc_32=X,c_gt_loc_33=X,c_gt_loc_34=X,c_gt_loc_35=X,c_gt_loc_36=X,c_gt_loc_37=X,c_gt_loc_38=X,c_gt_loc_39=X,c_gt_loc_4=X,c_gt_loc_40=X,c_gt_loc_41=X,c_gt_loc_42=X,c_gt_loc_43=X,c_gt_loc_44=X,c_gt_loc_45=X,c_gt_loc_46=X,c_gt_loc_47=X,c_gt_loc_48=X,c_gt_loc_5=X,c_gt_loc_6=X,c_gt_loc_7=X,c_gt_loc_8=X,c_gt_loc_9=X,c_lane_width=4,c_line_rate=50000,c_nfc=true,c_nfc_mode=IMM,c_refclk_frequency=125000,c_simplex=false,c_simplex_mode=TX,c_stream=false,c_ufc=false,flow_mode=Immediate_NFC,interface_mode=Framing,dataflow_config=Duplex}";
end aurora_8b10b_0;

architecture stub of aurora_8b10b_0 is
  attribute syn_black_box : boolean;
  attribute black_box_pad_pin : string;
  attribute syn_black_box of stub : architecture is true;
  attribute black_box_pad_pin of stub : architecture is "s_axi_tx_tdata[0:31],s_axi_tx_tvalid,s_axi_tx_tready,s_axi_tx_tkeep[0:3],s_axi_tx_tlast,m_axi_rx_tdata[0:31],m_axi_rx_tvalid,m_axi_rx_tkeep[0:3],m_axi_rx_tlast,s_axi_nfc_tx_tvalid,s_axi_nfc_tx_tdata[0:3],s_axi_nfc_tx_tready,m_axi_nfc_rx_tvalid,m_axi_nfc_rx_tdata[0:3],rxp[0:0],rxn[0:0],txp[0:0],txn[0:0],gt_refclk1,frame_err,hard_err,soft_err,channel_up,lane_up[0:0],user_clk,sync_clk,reset,power_down,loopback[2:0],gt_reset,tx_lock,sys_reset_out,init_clk_in,tx_resetdone_out,rx_resetdone_out,link_reset_out,drpclk_in,drpaddr_in[8:0],drpdi_in[15:0],drpdo_out[15:0],drpen_in,drprdy_out,drpwe_in,gt_common_reset_out,gt0_pll0refclklost_in,quad1_common_lock_in,GT0_PLL0OUTCLK_IN,GT0_PLL1OUTCLK_IN,GT0_PLL0OUTREFCLK_IN,GT0_PLL1OUTREFCLK_IN,tx_out_clk,pll_not_locked";
begin
end;
