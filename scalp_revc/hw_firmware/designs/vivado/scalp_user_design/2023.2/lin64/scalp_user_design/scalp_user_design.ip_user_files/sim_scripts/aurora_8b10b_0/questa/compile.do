vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xilinx_vip
vlib questa_lib/msim/xpm
vlib questa_lib/msim/xil_defaultlib

vmap xilinx_vip questa_lib/msim/xilinx_vip
vmap xpm questa_lib/msim/xpm
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xilinx_vip -64 -incr -mfcu  -sv -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+/home/andre/vivado/2025.2/data/xilinx_vip/include" \
"/home/andre/vivado/2025.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"/home/andre/vivado/2025.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"/home/andre/vivado/2025.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"/home/andre/vivado/2025.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"/home/andre/vivado/2025.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"/home/andre/vivado/2025.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"/home/andre/vivado/2025.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"/home/andre/vivado/2025.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"/home/andre/vivado/2025.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm -64 -incr -mfcu  -sv -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+../../../../../../../../../../../../../../../../vivado/2025.2/data/rsb/busdef" "+incdir+/home/andre/vivado/2025.2/data/xilinx_vip/include" \
"/home/andre/vivado/2025.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/home/andre/vivado/2025.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93  \
"/home/andre/vivado/2025.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -64 -93  \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_aurora_pkg.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_reset_logic.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0_core.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_aurora_lane_4byte.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_axi_to_ll.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_channel_err_detect.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_channel_init_sm.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_chbond_count_dec_4byte.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_err_detect_4byte.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_global_logic.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_hotplug.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_idle_and_ver_gen.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_lane_init_sm_4byte.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_left_align_control.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_left_align_mux.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_ll_to_axi.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_output_mux.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_output_switch_control.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_rx_ll_deframer.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_rx_ll_nfc.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_rx_ll_pdu_datapath.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_rx_ll.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_sideband_output.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_standard_cc_module.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_storage_ce_control.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_storage_count_control.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_storage_mux.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_storage_switch_control.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_sym_dec_4byte.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_sym_gen_4byte.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_cdc_sync.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/gt/aurora_8b10b_0_tx_startup_fsm.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/gt/aurora_8b10b_0_rx_startup_fsm.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/gt/aurora_8b10b_0_gtrxreset_seq.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/gt/aurora_8b10b_0_gt.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/gt/aurora_8b10b_0_multi_gt.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/gt/aurora_8b10b_0_transceiver_wrapper.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_tx_ll_control.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_tx_ll_datapath.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_tx_ll.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_valid_data_counter.vhd" \
"../../../../scalp_user_design.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

