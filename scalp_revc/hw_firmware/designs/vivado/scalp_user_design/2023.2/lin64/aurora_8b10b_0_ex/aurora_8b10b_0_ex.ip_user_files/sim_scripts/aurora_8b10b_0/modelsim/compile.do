vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/xil_defaultlib

vmap xpm modelsim_lib/msim/xpm
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xpm -64 -incr -mfcu  -sv "+incdir+../../../../../../../../../../../../../../../../vivado/2025.2/data/rsb/busdef" \
"/home/andre/vivado/2025.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/home/andre/vivado/2025.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"/home/andre/vivado/2025.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93  \
"/home/andre/vivado/2025.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -64 -93  \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_aurora_pkg.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_reset_logic.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0_core.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_aurora_lane_4byte.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_axi_to_ll.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_channel_err_detect.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_channel_init_sm.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_chbond_count_dec_4byte.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_err_detect_4byte.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_global_logic.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_hotplug.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_idle_and_ver_gen.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_lane_init_sm_4byte.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_left_align_control.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_left_align_mux.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_ll_to_axi.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_output_mux.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_output_switch_control.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_rx_ll_deframer.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_rx_ll_nfc.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_rx_ll_pdu_datapath.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_rx_ll.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_sideband_output.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_standard_cc_module.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_storage_ce_control.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_storage_count_control.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_storage_mux.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_storage_switch_control.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_sym_dec_4byte.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_sym_gen_4byte.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_cdc_sync.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/gt/aurora_8b10b_0_tx_startup_fsm.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/gt/aurora_8b10b_0_rx_startup_fsm.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/gt/aurora_8b10b_0_gtrxreset_seq.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/gt/aurora_8b10b_0_gt.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/gt/aurora_8b10b_0_multi_gt.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/gt/aurora_8b10b_0_transceiver_wrapper.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_tx_ll_control.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_tx_ll_datapath.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_tx_ll.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0/src/aurora_8b10b_0_valid_data_counter.vhd" \
"../../../../aurora_8b10b_0_ex.gen/sources_1/ip/aurora_8b10b_0/aurora_8b10b_0.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

