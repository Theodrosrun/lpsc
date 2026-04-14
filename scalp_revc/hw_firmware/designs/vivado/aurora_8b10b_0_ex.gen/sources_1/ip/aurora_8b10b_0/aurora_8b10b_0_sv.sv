// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// -------------------------------------------------------------------------------
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
// DO NOT MODIFY THIS FILE.

// MODULE VLNV: xilinx.com:ip:aurora_8b10b:11.1

`timescale 1ps / 1ps

`include "vivado_interfaces.svh"

module aurora_8b10b_0_sv (
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 USER_DATA_S_AXI_TX" *)
  (* X_INTERFACE_MODE = "slave USER_DATA_S_AXI_TX" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME USER_DATA_S_AXI_TX, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, LAYERED_METADATA undef, INSERT_VIP 0" *)
  vivado_axis_v1_0.slave USER_DATA_S_AXI_TX,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 USER_DATA_M_AXI_RX" *)
  (* X_INTERFACE_MODE = "master USER_DATA_M_AXI_RX" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME USER_DATA_M_AXI_RX, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 0, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, LAYERED_METADATA undef, INSERT_VIP 0" *)
  vivado_axis_v1_0.master USER_DATA_M_AXI_RX,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 NFC_S_AXI_TX" *)
  (* X_INTERFACE_MODE = "slave NFC_S_AXI_TX" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME NFC_S_AXI_TX, TDATA_NUM_BYTES 0, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 100000000, PHASE 0.0, LAYERED_METADATA undef, INSERT_VIP 0" *)
  vivado_axis_v1_0.slave NFC_S_AXI_TX,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 NFC_M_AXI_RX" *)
  (* X_INTERFACE_MODE = "master NFC_M_AXI_RX" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME NFC_M_AXI_RX, TDATA_NUM_BYTES 0, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 0, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 100000000, PHASE 0.0, LAYERED_METADATA undef, INSERT_VIP 0" *)
  vivado_axis_v1_0.master NFC_M_AXI_RX,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire hard_err,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire soft_err,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire frame_err,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire channel_up,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [0:0] lane_up,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [0:0] txp,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [0:0] txn,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire reset,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire gt_reset,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire [2:0] loopback,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire [0:0] rxp,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire [0:0] rxn,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire drpclk_in,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire [8:0] drpaddr_in,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire drpen_in,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire [15:0] drpdi_in,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire drprdy_out,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [15:0] drpdo_out,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire drpwe_in,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire power_down,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire tx_lock,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire tx_resetdone_out,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire rx_resetdone_out,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire link_reset_out,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire gt_common_reset_out,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire gt0_pll0outclk_in,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire gt0_pll1outclk_in,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire gt0_pll0outrefclk_in,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire gt0_pll1outrefclk_in,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire gt0_pll0refclklost_in,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire quad1_common_lock_in,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire init_clk_in,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire pll_not_locked,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire tx_out_clk,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire sys_reset_out,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire user_clk,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire sync_clk,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire gt_refclk1
);

  // interface wire assignments
  assign USER_DATA_M_AXI_RX.TDEST = 0;
  assign USER_DATA_M_AXI_RX.TID = 0;
  assign USER_DATA_M_AXI_RX.TSTRB = 0;
  assign USER_DATA_M_AXI_RX.TUSER = 0;
  assign NFC_M_AXI_RX.TDEST = 0;
  assign NFC_M_AXI_RX.TID = 0;
  assign NFC_M_AXI_RX.TKEEP = 0;
  assign NFC_M_AXI_RX.TLAST = 0;
  assign NFC_M_AXI_RX.TSTRB = 0;
  assign NFC_M_AXI_RX.TUSER = 0;

  aurora_8b10b_0 inst (
    .s_axi_tx_tdata(USER_DATA_S_AXI_TX.TDATA),
    .s_axi_tx_tkeep(USER_DATA_S_AXI_TX.TKEEP),
    .s_axi_tx_tlast(USER_DATA_S_AXI_TX.TLAST),
    .s_axi_tx_tvalid(USER_DATA_S_AXI_TX.TVALID),
    .s_axi_tx_tready(USER_DATA_S_AXI_TX.TREADY),
    .s_axi_nfc_tx_tvalid(NFC_S_AXI_TX.TVALID),
    .s_axi_nfc_tx_tdata(NFC_S_AXI_TX.TDATA),
    .s_axi_nfc_tx_tready(NFC_S_AXI_TX.TREADY),
    .m_axi_rx_tdata(USER_DATA_M_AXI_RX.TDATA),
    .m_axi_rx_tkeep(USER_DATA_M_AXI_RX.TKEEP),
    .m_axi_rx_tlast(USER_DATA_M_AXI_RX.TLAST),
    .m_axi_rx_tvalid(USER_DATA_M_AXI_RX.TVALID),
    .hard_err(hard_err),
    .soft_err(soft_err),
    .frame_err(frame_err),
    .channel_up(channel_up),
    .lane_up(lane_up),
    .txp(txp),
    .txn(txn),
    .reset(reset),
    .gt_reset(gt_reset),
    .loopback(loopback),
    .rxp(rxp),
    .rxn(rxn),
    .drpclk_in(drpclk_in),
    .drpaddr_in(drpaddr_in),
    .drpen_in(drpen_in),
    .drpdi_in(drpdi_in),
    .drprdy_out(drprdy_out),
    .drpdo_out(drpdo_out),
    .drpwe_in(drpwe_in),
    .m_axi_nfc_rx_tvalid(NFC_M_AXI_RX.TVALID),
    .m_axi_nfc_rx_tdata(NFC_M_AXI_RX.TDATA),
    .power_down(power_down),
    .tx_lock(tx_lock),
    .tx_resetdone_out(tx_resetdone_out),
    .rx_resetdone_out(rx_resetdone_out),
    .link_reset_out(link_reset_out),
    .gt_common_reset_out(gt_common_reset_out),
    .gt0_pll0outclk_in(gt0_pll0outclk_in),
    .gt0_pll1outclk_in(gt0_pll1outclk_in),
    .gt0_pll0outrefclk_in(gt0_pll0outrefclk_in),
    .gt0_pll1outrefclk_in(gt0_pll1outrefclk_in),
    .gt0_pll0refclklost_in(gt0_pll0refclklost_in),
    .quad1_common_lock_in(quad1_common_lock_in),
    .init_clk_in(init_clk_in),
    .pll_not_locked(pll_not_locked),
    .tx_out_clk(tx_out_clk),
    .sys_reset_out(sys_reset_out),
    .user_clk(user_clk),
    .sync_clk(sync_clk),
    .gt_refclk1(gt_refclk1)
  );

endmodule
