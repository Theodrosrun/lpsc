// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
// Date        : Tue Apr 14 18:32:21 2026
// Host        : andre running 64-bit Fedora Linux 42 (Workstation Edition)
// Command     : write_verilog -force -mode synth_stub
//               /home/andre/dev/mse/ma-lpsc/lpsc/scalp_revc/hw_firmware/designs/vivado/scalp_user_design/2023.2/lin64/scalp_user_design/scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0_stub.v
// Design      : aurora_8b10b_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z015clg485-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* core_generation_info = "aurora_8b10b_0,aurora_8b10b_v11_1_25,{user_interface=AXI_4_Streaming,backchannel_mode=Sidebands,c_aurora_lanes=1,c_column_used=None,c_gt_clock_1=GTPQ0,c_gt_clock_2=None,c_gt_loc_1=1,c_gt_loc_10=X,c_gt_loc_11=X,c_gt_loc_12=X,c_gt_loc_13=X,c_gt_loc_14=X,c_gt_loc_15=X,c_gt_loc_16=X,c_gt_loc_17=X,c_gt_loc_18=X,c_gt_loc_19=X,c_gt_loc_2=X,c_gt_loc_20=X,c_gt_loc_21=X,c_gt_loc_22=X,c_gt_loc_23=X,c_gt_loc_24=X,c_gt_loc_25=X,c_gt_loc_26=X,c_gt_loc_27=X,c_gt_loc_28=X,c_gt_loc_29=X,c_gt_loc_3=X,c_gt_loc_30=X,c_gt_loc_31=X,c_gt_loc_32=X,c_gt_loc_33=X,c_gt_loc_34=X,c_gt_loc_35=X,c_gt_loc_36=X,c_gt_loc_37=X,c_gt_loc_38=X,c_gt_loc_39=X,c_gt_loc_4=X,c_gt_loc_40=X,c_gt_loc_41=X,c_gt_loc_42=X,c_gt_loc_43=X,c_gt_loc_44=X,c_gt_loc_45=X,c_gt_loc_46=X,c_gt_loc_47=X,c_gt_loc_48=X,c_gt_loc_5=X,c_gt_loc_6=X,c_gt_loc_7=X,c_gt_loc_8=X,c_gt_loc_9=X,c_lane_width=4,c_line_rate=50000,c_nfc=true,c_nfc_mode=IMM,c_refclk_frequency=125000,c_simplex=false,c_simplex_mode=TX,c_stream=false,c_ufc=false,flow_mode=Immediate_NFC,interface_mode=Framing,dataflow_config=Duplex}" *) 
module aurora_8b10b_0(s_axi_tx_tdata, s_axi_tx_tvalid, 
  s_axi_tx_tready, s_axi_tx_tkeep, s_axi_tx_tlast, m_axi_rx_tdata, m_axi_rx_tvalid, 
  m_axi_rx_tkeep, m_axi_rx_tlast, s_axi_nfc_tx_tvalid, s_axi_nfc_tx_tdata, 
  s_axi_nfc_tx_tready, m_axi_nfc_rx_tvalid, m_axi_nfc_rx_tdata, rxp, rxn, txp, txn, gt_refclk1, 
  frame_err, hard_err, soft_err, channel_up, lane_up, user_clk, sync_clk, reset, power_down, 
  loopback, gt_reset, tx_lock, sys_reset_out, init_clk_in, tx_resetdone_out, rx_resetdone_out, 
  link_reset_out, drpclk_in, drpaddr_in, drpdi_in, drpdo_out, drpen_in, drprdy_out, drpwe_in, 
  gt_common_reset_out, gt0_pll0refclklost_in, quad1_common_lock_in, GT0_PLL0OUTCLK_IN, 
  GT0_PLL1OUTCLK_IN, GT0_PLL0OUTREFCLK_IN, GT0_PLL1OUTREFCLK_IN, tx_out_clk, 
  pll_not_locked)
/* synthesis syn_black_box black_box_pad_pin="s_axi_tx_tdata[0:31],s_axi_tx_tvalid,s_axi_tx_tready,s_axi_tx_tkeep[0:3],s_axi_tx_tlast,m_axi_rx_tdata[0:31],m_axi_rx_tvalid,m_axi_rx_tkeep[0:3],m_axi_rx_tlast,s_axi_nfc_tx_tvalid,s_axi_nfc_tx_tdata[0:3],s_axi_nfc_tx_tready,m_axi_nfc_rx_tvalid,m_axi_nfc_rx_tdata[0:3],rxp[0:0],rxn[0:0],txp[0:0],txn[0:0],gt_refclk1,frame_err,hard_err,soft_err,channel_up,lane_up[0:0],reset,power_down,loopback[2:0],gt_reset,tx_lock,sys_reset_out,tx_resetdone_out,rx_resetdone_out,link_reset_out,drpaddr_in[8:0],drpdi_in[15:0],drpdo_out[15:0],drpen_in,drprdy_out,drpwe_in,gt_common_reset_out,gt0_pll0refclklost_in,quad1_common_lock_in,GT0_PLL0OUTREFCLK_IN,GT0_PLL1OUTREFCLK_IN,tx_out_clk,pll_not_locked" */
/* synthesis syn_force_seq_prim="user_clk" */
/* synthesis syn_force_seq_prim="sync_clk" */
/* synthesis syn_force_seq_prim="init_clk_in" */
/* synthesis syn_force_seq_prim="drpclk_in" */
/* synthesis syn_force_seq_prim="GT0_PLL0OUTCLK_IN" */
/* synthesis syn_force_seq_prim="GT0_PLL1OUTCLK_IN" */;
  input [0:31]s_axi_tx_tdata;
  input s_axi_tx_tvalid;
  output s_axi_tx_tready;
  input [0:3]s_axi_tx_tkeep;
  input s_axi_tx_tlast;
  output [0:31]m_axi_rx_tdata;
  output m_axi_rx_tvalid;
  output [0:3]m_axi_rx_tkeep;
  output m_axi_rx_tlast;
  input s_axi_nfc_tx_tvalid;
  input [0:3]s_axi_nfc_tx_tdata;
  output s_axi_nfc_tx_tready;
  output m_axi_nfc_rx_tvalid;
  output [0:3]m_axi_nfc_rx_tdata;
  input [0:0]rxp;
  input [0:0]rxn;
  output [0:0]txp;
  output [0:0]txn;
  input gt_refclk1;
  output frame_err;
  output hard_err;
  output soft_err;
  output channel_up;
  output [0:0]lane_up;
  input user_clk /* synthesis syn_isclock = 1 */;
  input sync_clk /* synthesis syn_isclock = 1 */;
  input reset;
  input power_down;
  input [2:0]loopback;
  input gt_reset;
  output tx_lock;
  output sys_reset_out;
  input init_clk_in /* synthesis syn_isclock = 1 */;
  output tx_resetdone_out;
  output rx_resetdone_out;
  output link_reset_out;
  input drpclk_in /* synthesis syn_isclock = 1 */;
  input [8:0]drpaddr_in;
  input [15:0]drpdi_in;
  output [15:0]drpdo_out;
  input drpen_in;
  output drprdy_out;
  input drpwe_in;
  output gt_common_reset_out;
  input gt0_pll0refclklost_in;
  input quad1_common_lock_in;
  input GT0_PLL0OUTCLK_IN /* synthesis syn_isclock = 1 */;
  input GT0_PLL1OUTCLK_IN /* synthesis syn_isclock = 1 */;
  input GT0_PLL0OUTREFCLK_IN;
  input GT0_PLL1OUTREFCLK_IN;
  output tx_out_clk;
  input pll_not_locked;
endmodule
