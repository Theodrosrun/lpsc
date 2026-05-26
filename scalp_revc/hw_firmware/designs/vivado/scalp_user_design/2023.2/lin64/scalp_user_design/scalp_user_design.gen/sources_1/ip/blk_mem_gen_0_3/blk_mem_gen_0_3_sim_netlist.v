// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
// Date        : Tue May 26 11:33:28 2026
// Host        : andre running 64-bit Fedora Linux 42 (Workstation Edition)
// Command     : write_verilog -force -mode funcsim -rename_top blk_mem_gen_0_3 -prefix
//               blk_mem_gen_0_3_ blk_mem_gen_0_sim_netlist.v
// Design      : blk_mem_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z015clg485-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_0,blk_mem_gen_v8_4_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_12,Vivado 2025.2" *) 
(* NotValidForBitStream *)
module blk_mem_gen_0_3
   (clka,
    wea,
    addra,
    dina,
    clkb,
    addrb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [13:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [6:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [13:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [6:0]doutb;

  wire [13:0]addra;
  wire [13:0]addrb;
  wire clka;
  wire clkb;
  wire [6:0]dina;
  wire [6:0]doutb;
  wire [0:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [6:0]NLW_U0_douta_UNCONNECTED;
  wire [13:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [13:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [6:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "14" *) 
  (* C_ADDRB_WIDTH = "14" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "3" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     15.319699 mW" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "1" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "blk_mem_gen_0.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "1" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "16384" *) 
  (* C_READ_DEPTH_B = "16384" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "7" *) 
  (* C_READ_WIDTH_B = "7" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "16384" *) 
  (* C_WRITE_DEPTH_B = "16384" *) 
  (* C_WRITE_MODE_A = "NO_CHANGE" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "7" *) 
  (* C_WRITE_WIDTH_B = "7" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_gen_0_3_blk_mem_gen_v8_4_12 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(NLW_U0_douta_UNCONNECTED[6:0]),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[13:0]),
        .regcea(1'b1),
        .regceb(1'b1),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[13:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[6:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2025.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
YqH9kwIC39+qbZg4PSfFsXuB9k9wnuxNryS/CfnEri6Ci9fSC6fsrQ/T/hnt3u/yolbJ8DJa1Qu6
Qnm24A9jLbA+fu3Nsmm6/rM6a4vU6OfVl/gTFd/CiWDutv6Dhn6Lim4uUNPahoOR/A2Yc4Zo2tdI
kMLO9gn9WlH2l3O2oXs=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XJYO2VHd/cnMxQd3i7/2qRhl57dl+doEKuhAunQyv3vpGRG/jlNxj8PqrgLoF0HMdqE3qJUVE/oq
kBSapqjVjLDMOrNGQ+Tc6VGsKMZH8FE/TXHQJ/IM5Iuiu2eozEwwVUomF+7cfqn+9OsVsqCONQ1M
g0oRlangiqasJDhhMfnlGGqwAwmgWRGQA6dmhTuua1s8zdvIv540zY6p5au8cAKVhqyyKK7wbxEE
SGuFqX+NYoyRV+rfWCcWM+hJEmnWS8LNAKkd13YE2+17sPYzUdZ23DmTxXK6KlAxKFW27CBySUfg
qdNXp2DSs2KAQYih27pBNMuHfGbM/ATFPWFvxg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
lYoEi/e8HsDTz6N11EDe/B/iitERmeYndlCklmCluwgb0N4W80JUGVlkd7NlRZHRNhxaNBJPkcjC
n61nO0tb17NwsMwjbY5TF8JWRYTNw1JXCFacvQYrdKv4/7QNQEtwVGiCLxFhOA8aHlWMZIrc2fri
VRMVWaEBcPwCGorlVIM=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QEw9fEsWFbdX0OQLvYs/gl+zyEOW3ak9TdQVaq+0AXXOT3LIqF7wDxJ6ZBnlf9mNbdsUVH5tAz1o
H8u7ihJl1L3THEvugW+TS8hkvVbEA9rKO2vV15KAj4Lla7UdFT/xDfe79RFarlLI7yGrubjgdoRi
QWy//UKsffG7IWNwmoSuppWiWB4ZHJtkunNyIkm70JPGyZF62VxJg1MTT+5LUbZG5vZjjuHZud9w
xJaKv1tFP/x8RVqLU5gPOqGqTW7/nKO2S+450Vo4D9vAmBVVcXpaL1EbSmCvQ+qJmcQKtf9qYFRV
Zko08hbpHjPxstqvTDro01jRzB8592m4xU2TWA==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
TC7q853CWBPPJgbRfgDV1lmjUwSAtliljShAyNFg8sfRfwDzchthzoSPH1UCHV++E2JXacEKq1lB
UWsNP92U4Xh0/Gu+6esOI0pJb8I+TRTxyBN1I4cRQEfQHcwfhbSdeH3yX9OV3opLEqYmT37hWU+J
zCawYnxVESI0FtRzEXve9gdEWlrKKckrT/hp4mvxxOjvOkOSQBvy0elgUOqh6mEOZl+JnUbsR+Wm
CoZLE1eefMZy3FnVmyDNPv3JPXi88aLXMyimal0MYFkTiS4XJiGT3eAIMIbksehXY+eYi/KFpZWQ
GHpX+lG3UmiWWLwyPakFwKEHbrBc70AlJ2eV9g==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2025.1-2029.x", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
j9nmCKgjPWNChPbpSW6EWLrMA6oCG2JGPoum8px09v0PEAh0DRXZi0J8HPzXUsZgOEMcKpA7X54u
YFcDDCLAQ+urha/eSPbQYHQh4yGCursxAQ1C6LEyNQ2wJ0eLlO2bJeAl/gof06zqsYVM2lLJVNv5
wao1k2bmgPdfpfY3c9vPD0fSMuZPS41EoRS0cQhO5GTZnKdjxm6tEUL3GnTjB8ynSCIbCJUsMtAX
4FRHNa52gudx5B5fagR+lXgFhE7e++rWTJELr7SYB+r5Es8qZLTpCH8TrQxEkV0rY/+e4sAjNE2D
gHw8GD7VcUtc15B8y1BbVmh29qc8Nd3V2i/miA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
UkCD6I/Vye4qNoNoa3hIexBXG3xyKUJPAHAjIo7UcNVCDXpMQiYEtPDqExZMfiPlJn2nswCYIfIJ
FYWqMCloKSQyyI/7yZ2EtbyWEklb/P5IyZyvGi6hhFUo/JFTb12b4bK0gZPr+bCDdlVQKTx5GVHz
wptdUJO2omSj8axVMPbLRRtVzlJIZ29dTJ2ATXVXAcBxPnFfHRAMnYYKLeeLExX61vQvpqrkLQHm
XG7hpVzJi56gYKAzxa2BLq072OCVpVS70bfWlhlSTVcSlCrUf+EcarEk4FD8+Ih2NCvrqremG6yn
TtcBn8Xr8M/6zhOYvLi6AD6eArDMKA8n+Ccv8A==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
A5y5QVZU8yjPexRVPioSiAGohCHD5DX5FVobuMyhcgQRExLUhPvnnS8HOtxTj/2IapEcz68gFMGG
Hpi+m725u85/om/Vze9pGIW9Mn328Kz2FIg3W5EvGstfGwY+48LiAGAmTR269JS4lJGVYWYOz7Xk
S8cEsFd2m7j8iyKtARJzD90+UdXq/cIIh725jC9i8nbgxB364zddvm1Z/DF3JRw1qFp6GGcuRai1
KNcJ1j8c9wtIgktpsteU3e5+bxHEw8NT3gWXUFYjm00NDq97Jals8Jjktmum2nQxoF7ivPacfEey
gnSF6jRMkTsZObzc30hAhs0CEtc33hZLhPLHSn8pQ0WyvKJLHdd5s2yckgTZtqxC1Sbwe7WEgNXe
ZMX3pIkz+aoXsAL7GBLyVBMVQcyMoF0w8QGAaTe8sqatABwPqXidYRqNROTf62IYcMpV89XYgaTv
EwIn/oni9KOFd2BFVxRZbFGGC4IjvigsTBUijI+Dk6kVnDh240clGcc4

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Omtp+lCaqUx7Z4qdFj2zrN8LpCkit2eX4hlMtig+ielGm/x4FSZkpjoFmiqdKFPi2eg0pg09MSai
XyGH68UzAR7Xrj8f1jlIoUmMKp4GcxfdqfTeuu7kWGOJEP6cvgTjSJFj2gawDv7f4yZcltnK2x0L
e4GW/rBTmGvZtKWb2ahjINLxPuh3dDaSaWdb+zVgbtyrI5FrjxBkq+aOxSjyNsqnCx1L0uWbxnkl
88NbXN3dTaECXHNm/fsleayM5hKis7kTv9BFajJMGy+BhQlmIYpE+F5zchnTTFUFJZCz1sX9Fc8e
HcY7irB8mR3ajdzjUZLBQEMktp096Nheq3U75A==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
hpeBLwN9x2ZFDwroYLlUe5GjjDepHik2l0c2s3/6S7JPCRkzQSyt2V1Ad/JewAs/QNp5SXSbYYB4
rQl0My1LDMF3xw43r0g2IbcyHVpPhGp0W5msuQdF67afnsRv90iJYWLMI3QkYGCTWAzl4HrLxFSg
3z8XZRK670IcxznOrlvgHmIKsvubZrBkuc1EynrVb9Nw16QnIx2rc4WgcEXeFf+4i1RoYLDd3gXK
NFCNMdtaRYUThunFP6Z4ViZ5UnDmKq+IMhd31jTaqIlWOBDxPI1+v5RJYxIyTbn4rxlKR2fNbl5/
z4OUjBTd+1GH3I2OXlqmAOvIhpe2Z2HH7nZu/A==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Mt2RhTSUwEIEWeNARbyL+EdfS1UF6nPaL/fKl/7oO2gina93egwCWDLl1fbBtkfaPco0cu4MJ9K3
OraAsyHRlY+MNShmJ1LzAIA1LjZx4y55lu9dlQqSUXR7AW7wVbkg1864mK+hM/1XygU0jvebKNW9
B7xSER+asLO6pxi0mt7uC2PHxLPAYEszFhmnap82TtbDGdQ2qtyekY+ngs+N2fAdsblxVwJruiMl
e6XJ127M8N1mYwhWU2HtRpBOSnnKoHgD9fG51XK/rhk8DxT66QnX9uLPB+H25eDupBJGi1Y5o6x8
hOwZiSUVlBLh7brfzevh7+eRn+7es6wBas0+3w==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 71440)
`pragma protect data_block
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
R4tY6TtA5AkH+ykIxt6mHzazgw==
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
