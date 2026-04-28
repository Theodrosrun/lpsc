-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
-- -------------------------------------------------------------------------------
-- This file contains confidential and proprietary information
-- of AMD and is protected under U.S. and international copyright
-- and other intellectual property laws.
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
-- DO NOT MODIFY THIS FILE.

-- MODULE VLNV: amd.com:blockdesign:scalp_zynqps:1.0

-- The following code must appear in the VHDL architecture header.

-- COMP_TAG     ------ Begin cut for COMPONENT Declaration ------
COMPONENT scalp_zynqps
  PORT (
    DDR_cas_n : INOUT STD_LOGIC;
    DDR_cke : INOUT STD_LOGIC;
    DDR_ck_n : INOUT STD_LOGIC;
    DDR_ck_p : INOUT STD_LOGIC;
    DDR_cs_n : INOUT STD_LOGIC;
    DDR_reset_n : INOUT STD_LOGIC;
    DDR_odt : INOUT STD_LOGIC;
    DDR_ras_n : INOUT STD_LOGIC;
    DDR_we_n : INOUT STD_LOGIC;
    DDR_ba : INOUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    DDR_addr : INOUT STD_LOGIC_VECTOR(14 DOWNTO 0);
    DDR_dm : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    DDR_dq : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    DDR_dqs_n : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    DDR_dqs_p : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    FIXED_IO_mio : INOUT STD_LOGIC_VECTOR(53 DOWNTO 0);
    FIXED_IO_ddr_vrn : INOUT STD_LOGIC;
    FIXED_IO_ddr_vrp : INOUT STD_LOGIC;
    FIXED_IO_ps_srstb : INOUT STD_LOGIC;
    FIXED_IO_ps_clk : INOUT STD_LOGIC;
    FIXED_IO_ps_porb : INOUT STD_LOGIC;
    aximm_mst_firmwareid_if_rready : OUT STD_LOGIC;
    aximm_mst_firmwareid_if_bvalid : IN STD_LOGIC;
    aximm_mst_firmwareid_if_bready : OUT STD_LOGIC;
    aximm_mst_firmwareid_if_awvalid : OUT STD_LOGIC;
    aximm_mst_firmwareid_if_awready : IN STD_LOGIC;
    aximm_mst_firmwareid_if_wdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    aximm_mst_firmwareid_if_rresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    aximm_mst_firmwareid_if_rvalid : IN STD_LOGIC;
    aximm_mst_firmwareid_if_araddr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    aximm_mst_firmwareid_if_arready : IN STD_LOGIC;
    aximm_mst_firmwareid_if_awaddr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    aximm_mst_firmwareid_if_wvalid : OUT STD_LOGIC;
    aximm_mst_firmwareid_if_wready : IN STD_LOGIC;
    aximm_mst_firmwareid_if_arvalid : OUT STD_LOGIC;
    aximm_mst_firmwareid_if_wstrb : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    aximm_mst_firmwareid_if_bresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    aximm_mst_firmwareid_if_rdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    GPIOSwitchesxDI_tri_i : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    GPIOResetBtnxDO_tri_o : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    aximm_mst_clpx_num_regs_if_rready : OUT STD_LOGIC;
    aximm_mst_clpx_num_regs_if_bvalid : IN STD_LOGIC;
    aximm_mst_clpx_num_regs_if_bready : OUT STD_LOGIC;
    aximm_mst_clpx_num_regs_if_awvalid : OUT STD_LOGIC;
    aximm_mst_clpx_num_regs_if_awready : IN STD_LOGIC;
    aximm_mst_clpx_num_regs_if_wdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    aximm_mst_clpx_num_regs_if_rresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    aximm_mst_clpx_num_regs_if_rvalid : IN STD_LOGIC;
    aximm_mst_clpx_num_regs_if_araddr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    aximm_mst_clpx_num_regs_if_arready : IN STD_LOGIC;
    aximm_mst_clpx_num_regs_if_awaddr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    aximm_mst_clpx_num_regs_if_wvalid : OUT STD_LOGIC;
    aximm_mst_clpx_num_regs_if_wready : IN STD_LOGIC;
    aximm_mst_clpx_num_regs_if_arvalid : OUT STD_LOGIC;
    aximm_mst_clpx_num_regs_if_wstrb : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    aximm_mst_clpx_num_regs_if_bresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    aximm_mst_clpx_num_regs_if_rdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    IoExtIICxDIO_scl_i : IN STD_LOGIC;
    IoExtIICxDIO_scl_o : OUT STD_LOGIC;
    IoExtIICxDIO_scl_t : OUT STD_LOGIC;
    IoExtIICxDIO_sda_i : IN STD_LOGIC;
    IoExtIICxDIO_sda_o : OUT STD_LOGIC;
    IoExtIICxDIO_sda_t : OUT STD_LOGIC;
    GPIOJoystickxDI_tri_i : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    Spi1MOSIxSO : OUT STD_LOGIC;
    Spi1SSxSO : OUT STD_LOGIC;
    Spi1SclkxCO : OUT STD_LOGIC;
    Usb0VBusPwrFaultxSI : IN STD_LOGIC;
    Clk125RstxRNAO : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    Clk125RstxRO : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    SAxiMstFirmwareIdClkxCO : OUT STD_LOGIC;
    SAxiMstFirmwareIdRstxRANO : OUT STD_LOGIC;
    ClkVgaxCO : OUT STD_LOGIC;
    ClkHdmixCO : OUT STD_LOGIC;
    ClkVgaRstxRO : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    ClkVgaRstxRNAO : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    ClkHdmiRstxRO : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    ClkHdmiRstxRNAO : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    Clk125PllLockedxS : OUT STD_LOGIC;
    Clk125xCO : OUT STD_LOGIC;
    SAxiMstCplxNumRegsClkxCO : OUT STD_LOGIC;
    SAxiMstCplxNumRegsRstxRANO : OUT STD_LOGIC;
    VgaHdmiClkPllLockedxSO : OUT STD_LOGIC
  );
END COMPONENT;
-- COMP_TAG_END ------  End cut for COMPONENT Declaration  ------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

-- INST_TAG     ------ Begin cut for INSTANTIATION Template ------
your_instance_name : scalp_zynqps
  PORT MAP (
    DDR_cas_n => DDR_cas_n,
    DDR_cke => DDR_cke,
    DDR_ck_n => DDR_ck_n,
    DDR_ck_p => DDR_ck_p,
    DDR_cs_n => DDR_cs_n,
    DDR_reset_n => DDR_reset_n,
    DDR_odt => DDR_odt,
    DDR_ras_n => DDR_ras_n,
    DDR_we_n => DDR_we_n,
    DDR_ba => DDR_ba,
    DDR_addr => DDR_addr,
    DDR_dm => DDR_dm,
    DDR_dq => DDR_dq,
    DDR_dqs_n => DDR_dqs_n,
    DDR_dqs_p => DDR_dqs_p,
    FIXED_IO_mio => FIXED_IO_mio,
    FIXED_IO_ddr_vrn => FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp => FIXED_IO_ddr_vrp,
    FIXED_IO_ps_srstb => FIXED_IO_ps_srstb,
    FIXED_IO_ps_clk => FIXED_IO_ps_clk,
    FIXED_IO_ps_porb => FIXED_IO_ps_porb,
    aximm_mst_firmwareid_if_rready => aximm_mst_firmwareid_if_rready,
    aximm_mst_firmwareid_if_bvalid => aximm_mst_firmwareid_if_bvalid,
    aximm_mst_firmwareid_if_bready => aximm_mst_firmwareid_if_bready,
    aximm_mst_firmwareid_if_awvalid => aximm_mst_firmwareid_if_awvalid,
    aximm_mst_firmwareid_if_awready => aximm_mst_firmwareid_if_awready,
    aximm_mst_firmwareid_if_wdata => aximm_mst_firmwareid_if_wdata,
    aximm_mst_firmwareid_if_rresp => aximm_mst_firmwareid_if_rresp,
    aximm_mst_firmwareid_if_rvalid => aximm_mst_firmwareid_if_rvalid,
    aximm_mst_firmwareid_if_araddr => aximm_mst_firmwareid_if_araddr,
    aximm_mst_firmwareid_if_arready => aximm_mst_firmwareid_if_arready,
    aximm_mst_firmwareid_if_awaddr => aximm_mst_firmwareid_if_awaddr,
    aximm_mst_firmwareid_if_wvalid => aximm_mst_firmwareid_if_wvalid,
    aximm_mst_firmwareid_if_wready => aximm_mst_firmwareid_if_wready,
    aximm_mst_firmwareid_if_arvalid => aximm_mst_firmwareid_if_arvalid,
    aximm_mst_firmwareid_if_wstrb => aximm_mst_firmwareid_if_wstrb,
    aximm_mst_firmwareid_if_bresp => aximm_mst_firmwareid_if_bresp,
    aximm_mst_firmwareid_if_rdata => aximm_mst_firmwareid_if_rdata,
    GPIOSwitchesxDI_tri_i => GPIOSwitchesxDI_tri_i,
    GPIOResetBtnxDO_tri_o => GPIOResetBtnxDO_tri_o,
    aximm_mst_clpx_num_regs_if_rready => aximm_mst_clpx_num_regs_if_rready,
    aximm_mst_clpx_num_regs_if_bvalid => aximm_mst_clpx_num_regs_if_bvalid,
    aximm_mst_clpx_num_regs_if_bready => aximm_mst_clpx_num_regs_if_bready,
    aximm_mst_clpx_num_regs_if_awvalid => aximm_mst_clpx_num_regs_if_awvalid,
    aximm_mst_clpx_num_regs_if_awready => aximm_mst_clpx_num_regs_if_awready,
    aximm_mst_clpx_num_regs_if_wdata => aximm_mst_clpx_num_regs_if_wdata,
    aximm_mst_clpx_num_regs_if_rresp => aximm_mst_clpx_num_regs_if_rresp,
    aximm_mst_clpx_num_regs_if_rvalid => aximm_mst_clpx_num_regs_if_rvalid,
    aximm_mst_clpx_num_regs_if_araddr => aximm_mst_clpx_num_regs_if_araddr,
    aximm_mst_clpx_num_regs_if_arready => aximm_mst_clpx_num_regs_if_arready,
    aximm_mst_clpx_num_regs_if_awaddr => aximm_mst_clpx_num_regs_if_awaddr,
    aximm_mst_clpx_num_regs_if_wvalid => aximm_mst_clpx_num_regs_if_wvalid,
    aximm_mst_clpx_num_regs_if_wready => aximm_mst_clpx_num_regs_if_wready,
    aximm_mst_clpx_num_regs_if_arvalid => aximm_mst_clpx_num_regs_if_arvalid,
    aximm_mst_clpx_num_regs_if_wstrb => aximm_mst_clpx_num_regs_if_wstrb,
    aximm_mst_clpx_num_regs_if_bresp => aximm_mst_clpx_num_regs_if_bresp,
    aximm_mst_clpx_num_regs_if_rdata => aximm_mst_clpx_num_regs_if_rdata,
    IoExtIICxDIO_scl_i => IoExtIICxDIO_scl_i,
    IoExtIICxDIO_scl_o => IoExtIICxDIO_scl_o,
    IoExtIICxDIO_scl_t => IoExtIICxDIO_scl_t,
    IoExtIICxDIO_sda_i => IoExtIICxDIO_sda_i,
    IoExtIICxDIO_sda_o => IoExtIICxDIO_sda_o,
    IoExtIICxDIO_sda_t => IoExtIICxDIO_sda_t,
    GPIOJoystickxDI_tri_i => GPIOJoystickxDI_tri_i,
    Spi1MOSIxSO => Spi1MOSIxSO,
    Spi1SSxSO => Spi1SSxSO,
    Spi1SclkxCO => Spi1SclkxCO,
    Usb0VBusPwrFaultxSI => Usb0VBusPwrFaultxSI,
    Clk125RstxRNAO => Clk125RstxRNAO,
    Clk125RstxRO => Clk125RstxRO,
    SAxiMstFirmwareIdClkxCO => SAxiMstFirmwareIdClkxCO,
    SAxiMstFirmwareIdRstxRANO => SAxiMstFirmwareIdRstxRANO,
    ClkVgaxCO => ClkVgaxCO,
    ClkHdmixCO => ClkHdmixCO,
    ClkVgaRstxRO => ClkVgaRstxRO,
    ClkVgaRstxRNAO => ClkVgaRstxRNAO,
    ClkHdmiRstxRO => ClkHdmiRstxRO,
    ClkHdmiRstxRNAO => ClkHdmiRstxRNAO,
    Clk125PllLockedxS => Clk125PllLockedxS,
    Clk125xCO => Clk125xCO,
    SAxiMstCplxNumRegsClkxCO => SAxiMstCplxNumRegsClkxCO,
    SAxiMstCplxNumRegsRstxRANO => SAxiMstCplxNumRegsRstxRANO,
    VgaHdmiClkPllLockedxSO => VgaHdmiClkPllLockedxSO
  );
-- INST_TAG_END ------  End cut for INSTANTIATION Template  ------

-- You must compile the wrapper file scalp_zynqps.vhd when simulating
-- the module, scalp_zynqps. When compiling the wrapper file, be sure to
-- reference the VHDL simulation library.
