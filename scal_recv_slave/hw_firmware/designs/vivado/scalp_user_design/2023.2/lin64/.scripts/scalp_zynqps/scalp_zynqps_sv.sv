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

// MODULE VLNV: amd.com:blockdesign:scalp_zynqps:1.0

`timescale 1ps / 1ps

`include "vivado_interfaces.svh"

module scalp_zynqps_sv (
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 aximm_mst_firmwareid_if" *)
  (* X_INTERFACE_MODE = "master aximm_mst_firmwareid_if" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aximm_mst_firmwareid_if, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 32, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN scalp_zynqps_scalp_axi_link_firmwareid_0_SAxiMstClkxCO, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
  vivado_axi4_lite_v1_0.master aximm_mst_firmwareid_if,
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 aximm_mst_clpx_num_regs_if" *)
  (* X_INTERFACE_MODE = "master aximm_mst_clpx_num_regs_if" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aximm_mst_clpx_num_regs_if, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 32, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN scalp_zynqps_scalp_axi_link_cplx_num_regs_0_SAxiMstClkxCO, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
  vivado_axi4_lite_v1_0.master aximm_mst_clpx_num_regs_if,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire DDR_cas_n,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire DDR_cke,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire DDR_ck_n,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire DDR_ck_p,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire DDR_cs_n,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire DDR_reset_n,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire DDR_odt,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire DDR_ras_n,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire DDR_we_n,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire [2:0] DDR_ba,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire [14:0] DDR_addr,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire [3:0] DDR_dm,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire [31:0] DDR_dq,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire [3:0] DDR_dqs_n,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire [3:0] DDR_dqs_p,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire [53:0] FIXED_IO_mio,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire FIXED_IO_ddr_vrn,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire FIXED_IO_ddr_vrp,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire FIXED_IO_ps_srstb,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire FIXED_IO_ps_clk,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire FIXED_IO_ps_porb,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire [1:0] GPIOSwitchesxDI_tri_i,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [0:0] GPIOResetBtnxDO_tri_o,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire IoExtIICxDIO_scl_i,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire IoExtIICxDIO_scl_o,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire IoExtIICxDIO_scl_t,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire IoExtIICxDIO_sda_i,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire IoExtIICxDIO_sda_o,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire IoExtIICxDIO_sda_t,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire [4:0] GPIOJoystickxDI_tri_i,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire Spi1MOSIxSO,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire Spi1SSxSO,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire Spi1SclkxCO,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire Usb0VBusPwrFaultxSI,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [0:0] Clk125RstxRNAO,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [0:0] Clk125RstxRO,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire SAxiMstFirmwareIdClkxCO,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire SAxiMstFirmwareIdRstxRANO,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire ClkVgaxCO,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire ClkHdmixCO,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [0:0] ClkVgaRstxRO,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [0:0] ClkVgaRstxRNAO,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [0:0] ClkHdmiRstxRO,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [0:0] ClkHdmiRstxRNAO,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire Clk125PllLockedxS,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire Clk125xCO,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire SAxiMstCplxNumRegsClkxCO,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire SAxiMstCplxNumRegsRstxRANO,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire VgaHdmiClkPllLockedxSO
);

  // interface wire assignments
  assign aximm_mst_firmwareid_if.ARPROT = 0;
  assign aximm_mst_firmwareid_if.AWPROT = 0;
  assign aximm_mst_clpx_num_regs_if.ARPROT = 0;
  assign aximm_mst_clpx_num_regs_if.AWPROT = 0;

  scalp_zynqps inst (
    .DDR_cas_n(DDR_cas_n),
    .DDR_cke(DDR_cke),
    .DDR_ck_n(DDR_ck_n),
    .DDR_ck_p(DDR_ck_p),
    .DDR_cs_n(DDR_cs_n),
    .DDR_reset_n(DDR_reset_n),
    .DDR_odt(DDR_odt),
    .DDR_ras_n(DDR_ras_n),
    .DDR_we_n(DDR_we_n),
    .DDR_ba(DDR_ba),
    .DDR_addr(DDR_addr),
    .DDR_dm(DDR_dm),
    .DDR_dq(DDR_dq),
    .DDR_dqs_n(DDR_dqs_n),
    .DDR_dqs_p(DDR_dqs_p),
    .FIXED_IO_mio(FIXED_IO_mio),
    .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
    .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
    .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
    .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
    .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
    .aximm_mst_firmwareid_if_rready(aximm_mst_firmwareid_if.RREADY),
    .aximm_mst_firmwareid_if_bvalid(aximm_mst_firmwareid_if.BVALID),
    .aximm_mst_firmwareid_if_bready(aximm_mst_firmwareid_if.BREADY),
    .aximm_mst_firmwareid_if_awvalid(aximm_mst_firmwareid_if.AWVALID),
    .aximm_mst_firmwareid_if_awready(aximm_mst_firmwareid_if.AWREADY),
    .aximm_mst_firmwareid_if_wdata(aximm_mst_firmwareid_if.WDATA),
    .aximm_mst_firmwareid_if_rresp(aximm_mst_firmwareid_if.RRESP),
    .aximm_mst_firmwareid_if_rvalid(aximm_mst_firmwareid_if.RVALID),
    .aximm_mst_firmwareid_if_araddr(aximm_mst_firmwareid_if.ARADDR),
    .aximm_mst_firmwareid_if_arready(aximm_mst_firmwareid_if.ARREADY),
    .aximm_mst_firmwareid_if_awaddr(aximm_mst_firmwareid_if.AWADDR),
    .aximm_mst_firmwareid_if_wvalid(aximm_mst_firmwareid_if.WVALID),
    .aximm_mst_firmwareid_if_wready(aximm_mst_firmwareid_if.WREADY),
    .aximm_mst_firmwareid_if_arvalid(aximm_mst_firmwareid_if.ARVALID),
    .aximm_mst_firmwareid_if_wstrb(aximm_mst_firmwareid_if.WSTRB),
    .aximm_mst_firmwareid_if_bresp(aximm_mst_firmwareid_if.BRESP),
    .aximm_mst_firmwareid_if_rdata(aximm_mst_firmwareid_if.RDATA),
    .GPIOSwitchesxDI_tri_i(GPIOSwitchesxDI_tri_i),
    .GPIOResetBtnxDO_tri_o(GPIOResetBtnxDO_tri_o),
    .aximm_mst_clpx_num_regs_if_rready(aximm_mst_clpx_num_regs_if.RREADY),
    .aximm_mst_clpx_num_regs_if_bvalid(aximm_mst_clpx_num_regs_if.BVALID),
    .aximm_mst_clpx_num_regs_if_bready(aximm_mst_clpx_num_regs_if.BREADY),
    .aximm_mst_clpx_num_regs_if_awvalid(aximm_mst_clpx_num_regs_if.AWVALID),
    .aximm_mst_clpx_num_regs_if_awready(aximm_mst_clpx_num_regs_if.AWREADY),
    .aximm_mst_clpx_num_regs_if_wdata(aximm_mst_clpx_num_regs_if.WDATA),
    .aximm_mst_clpx_num_regs_if_rresp(aximm_mst_clpx_num_regs_if.RRESP),
    .aximm_mst_clpx_num_regs_if_rvalid(aximm_mst_clpx_num_regs_if.RVALID),
    .aximm_mst_clpx_num_regs_if_araddr(aximm_mst_clpx_num_regs_if.ARADDR),
    .aximm_mst_clpx_num_regs_if_arready(aximm_mst_clpx_num_regs_if.ARREADY),
    .aximm_mst_clpx_num_regs_if_awaddr(aximm_mst_clpx_num_regs_if.AWADDR),
    .aximm_mst_clpx_num_regs_if_wvalid(aximm_mst_clpx_num_regs_if.WVALID),
    .aximm_mst_clpx_num_regs_if_wready(aximm_mst_clpx_num_regs_if.WREADY),
    .aximm_mst_clpx_num_regs_if_arvalid(aximm_mst_clpx_num_regs_if.ARVALID),
    .aximm_mst_clpx_num_regs_if_wstrb(aximm_mst_clpx_num_regs_if.WSTRB),
    .aximm_mst_clpx_num_regs_if_bresp(aximm_mst_clpx_num_regs_if.BRESP),
    .aximm_mst_clpx_num_regs_if_rdata(aximm_mst_clpx_num_regs_if.RDATA),
    .IoExtIICxDIO_scl_i(IoExtIICxDIO_scl_i),
    .IoExtIICxDIO_scl_o(IoExtIICxDIO_scl_o),
    .IoExtIICxDIO_scl_t(IoExtIICxDIO_scl_t),
    .IoExtIICxDIO_sda_i(IoExtIICxDIO_sda_i),
    .IoExtIICxDIO_sda_o(IoExtIICxDIO_sda_o),
    .IoExtIICxDIO_sda_t(IoExtIICxDIO_sda_t),
    .GPIOJoystickxDI_tri_i(GPIOJoystickxDI_tri_i),
    .Spi1MOSIxSO(Spi1MOSIxSO),
    .Spi1SSxSO(Spi1SSxSO),
    .Spi1SclkxCO(Spi1SclkxCO),
    .Usb0VBusPwrFaultxSI(Usb0VBusPwrFaultxSI),
    .Clk125RstxRNAO(Clk125RstxRNAO),
    .Clk125RstxRO(Clk125RstxRO),
    .SAxiMstFirmwareIdClkxCO(SAxiMstFirmwareIdClkxCO),
    .SAxiMstFirmwareIdRstxRANO(SAxiMstFirmwareIdRstxRANO),
    .ClkVgaxCO(ClkVgaxCO),
    .ClkHdmixCO(ClkHdmixCO),
    .ClkVgaRstxRO(ClkVgaRstxRO),
    .ClkVgaRstxRNAO(ClkVgaRstxRNAO),
    .ClkHdmiRstxRO(ClkHdmiRstxRO),
    .ClkHdmiRstxRNAO(ClkHdmiRstxRNAO),
    .Clk125PllLockedxS(Clk125PllLockedxS),
    .Clk125xCO(Clk125xCO),
    .SAxiMstCplxNumRegsClkxCO(SAxiMstCplxNumRegsClkxCO),
    .SAxiMstCplxNumRegsRstxRANO(SAxiMstCplxNumRegsRstxRANO),
    .VgaHdmiClkPllLockedxSO(VgaHdmiClkPllLockedxSO)
  );

endmodule
