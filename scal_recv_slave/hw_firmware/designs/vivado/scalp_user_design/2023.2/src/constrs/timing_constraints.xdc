############################################################################
# Timing constraints                                                       #
############################################################################

##### PS_CLK (125 MHz) #####
create_clock -period 8.000 -waveform {0.000 4.000} [get_ports PSClkxCIO]

##### GTP reference clocks (125 MHz) #####
#create_clock -period 8.000 -waveform {0.000 4.000} [get_nets GTPRefClk0PxCI]
#create_clock -period 8.000 -waveform {0.000 4.000} [get_nets GTPRefClk1xC]

##### Clocks from PLLs (125 MHz) #####
#create_clock -period 8.000 -waveform {0.000 4.000} [get_nets {PLL_Clk_in_Local}]
#create_clock -period 8.000 -waveform {0.000 4.000} [get_nets {PLL_Clk_in_North}]
#create_clock -period 8.000 -waveform {0.000 4.000} [get_nets {PLL_Clk_in_South}]
#create_clock -period 8.000 -waveform {0.000 4.000} [get_nets {PLL_Clk_in_Top}]
#create_clock -period 8.000 -waveform {0.000 4.000} [get_nets {PLL_Clk_in_Bottom}]

##### Clocks from neighbours (125 MHz) #####
#create_clock -period 8.000 -waveform {0.000 4.000} [get_nets {Clk_in_North}]
#create_clock -period 8.000 -waveform {0.000 4.000} [get_nets {Clk_in_South}]
#create_clock -period 8.000 -waveform {0.000 4.000} [get_nets {Clk_in_East}]
#create_clock -period 8.000 -waveform {0.000 4.000} [get_nets {Clk_in_West}]
#create_clock -period 8.000 -waveform {0.000 4.000} [get_nets {Clk_in_Top}]
#create_clock -period 8.000 -waveform {0.000 4.000} [get_nets {Clk_in_Bottom}]

# Output delays
#create_clock -name clk_125 -period 8.000 [get_nets sys_clock_clk_125]
#set_output_delay 1.000 -clock [get_clocks clk_125] [get_ports Led12V5RxSO]
#set_output_delay 1.000 -clock [get_clocks clk_125] [get_ports Led12V5RxSO]
#set_output_delay 1.000 -clock [get_clocks clk_125] [get_ports Led12V5RxSO]





create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list Aurora.aurora_comms/aurora.aurora_support/clock_module_i/CLK]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 4 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {Aurora.aurora_comms/axis_tx[tkeep][3]} {Aurora.aurora_comms/axis_tx[tkeep][2]} {Aurora.aurora_comms/axis_tx[tkeep][1]} {Aurora.aurora_comms/axis_tx[tkeep][0]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 1 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {Aurora.aurora_comms/aurora_error[lane_up][0]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {Aurora.aurora_comms/axis_rx[tdata][31]} {Aurora.aurora_comms/axis_rx[tdata][30]} {Aurora.aurora_comms/axis_rx[tdata][29]} {Aurora.aurora_comms/axis_rx[tdata][28]} {Aurora.aurora_comms/axis_rx[tdata][27]} {Aurora.aurora_comms/axis_rx[tdata][26]} {Aurora.aurora_comms/axis_rx[tdata][25]} {Aurora.aurora_comms/axis_rx[tdata][24]} {Aurora.aurora_comms/axis_rx[tdata][23]} {Aurora.aurora_comms/axis_rx[tdata][22]} {Aurora.aurora_comms/axis_rx[tdata][21]} {Aurora.aurora_comms/axis_rx[tdata][20]} {Aurora.aurora_comms/axis_rx[tdata][19]} {Aurora.aurora_comms/axis_rx[tdata][18]} {Aurora.aurora_comms/axis_rx[tdata][17]} {Aurora.aurora_comms/axis_rx[tdata][16]} {Aurora.aurora_comms/axis_rx[tdata][15]} {Aurora.aurora_comms/axis_rx[tdata][14]} {Aurora.aurora_comms/axis_rx[tdata][13]} {Aurora.aurora_comms/axis_rx[tdata][12]} {Aurora.aurora_comms/axis_rx[tdata][11]} {Aurora.aurora_comms/axis_rx[tdata][10]} {Aurora.aurora_comms/axis_rx[tdata][9]} {Aurora.aurora_comms/axis_rx[tdata][8]} {Aurora.aurora_comms/axis_rx[tdata][7]} {Aurora.aurora_comms/axis_rx[tdata][6]} {Aurora.aurora_comms/axis_rx[tdata][5]} {Aurora.aurora_comms/axis_rx[tdata][4]} {Aurora.aurora_comms/axis_rx[tdata][3]} {Aurora.aurora_comms/axis_rx[tdata][2]} {Aurora.aurora_comms/axis_rx[tdata][1]} {Aurora.aurora_comms/axis_rx[tdata][0]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 4 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {Aurora.aurora_comms/axis_rx[tkeep][3]} {Aurora.aurora_comms/axis_rx[tkeep][2]} {Aurora.aurora_comms/axis_rx[tkeep][1]} {Aurora.aurora_comms/axis_rx[tkeep][0]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {Aurora.aurora_comms/axis_tx[tdata][31]} {Aurora.aurora_comms/axis_tx[tdata][30]} {Aurora.aurora_comms/axis_tx[tdata][29]} {Aurora.aurora_comms/axis_tx[tdata][28]} {Aurora.aurora_comms/axis_tx[tdata][27]} {Aurora.aurora_comms/axis_tx[tdata][26]} {Aurora.aurora_comms/axis_tx[tdata][25]} {Aurora.aurora_comms/axis_tx[tdata][24]} {Aurora.aurora_comms/axis_tx[tdata][23]} {Aurora.aurora_comms/axis_tx[tdata][22]} {Aurora.aurora_comms/axis_tx[tdata][21]} {Aurora.aurora_comms/axis_tx[tdata][20]} {Aurora.aurora_comms/axis_tx[tdata][19]} {Aurora.aurora_comms/axis_tx[tdata][18]} {Aurora.aurora_comms/axis_tx[tdata][17]} {Aurora.aurora_comms/axis_tx[tdata][16]} {Aurora.aurora_comms/axis_tx[tdata][15]} {Aurora.aurora_comms/axis_tx[tdata][14]} {Aurora.aurora_comms/axis_tx[tdata][13]} {Aurora.aurora_comms/axis_tx[tdata][12]} {Aurora.aurora_comms/axis_tx[tdata][11]} {Aurora.aurora_comms/axis_tx[tdata][10]} {Aurora.aurora_comms/axis_tx[tdata][9]} {Aurora.aurora_comms/axis_tx[tdata][8]} {Aurora.aurora_comms/axis_tx[tdata][7]} {Aurora.aurora_comms/axis_tx[tdata][6]} {Aurora.aurora_comms/axis_tx[tdata][5]} {Aurora.aurora_comms/axis_tx[tdata][4]} {Aurora.aurora_comms/axis_tx[tdata][3]} {Aurora.aurora_comms/axis_tx[tdata][2]} {Aurora.aurora_comms/axis_tx[tdata][1]} {Aurora.aurora_comms/axis_tx[tdata][0]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {Aurora.aurora_comms/aurora_error[channel_up]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {Aurora.aurora_comms/aurora_error[frame_err]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {Aurora.aurora_comms/aurora_error[hard_err]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {Aurora.aurora_comms/aurora_error[soft_err]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {Aurora.aurora_comms/aurora_reset[reset_out]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {Aurora.aurora_comms/axis_rx[tlast]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {Aurora.aurora_comms/axis_rx[tvalid]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {Aurora.aurora_comms/axis_tx[tlast]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {Aurora.aurora_comms/axis_tx[tready]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {Aurora.aurora_comms/axis_tx[tvalid]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list Aurora.aurora_comms/rx_resetdone_out]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list Aurora.aurora_comms/tx_resetdone_out]]
create_debug_core u_ila_1 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_1]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_1]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_1]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_1]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_1]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_1]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1]
set_property port_width 1 [get_debug_ports u_ila_1/clk]
connect_debug_port u_ila_1/clk [get_nets [list PSxB.ZynqxI/PlatformxB.ScalpZynqPSxI/sys_clock/inst/clk_125]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
set_property port_width 1 [get_debug_ports u_ila_1/probe0]
connect_debug_port u_ila_1/probe0 [get_nets [list {Aurora.aurora_comms/aurora_reset[gt_reset]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
set_property port_width 1 [get_debug_ports u_ila_1/probe1]
connect_debug_port u_ila_1/probe1 [get_nets [list {Aurora.aurora_comms/aurora_reset[usr_reset]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe2]
set_property port_width 1 [get_debug_ports u_ila_1/probe2]
connect_debug_port u_ila_1/probe2 [get_nets [list Aurora.aurora_comms/combined_reset]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe3]
set_property port_width 1 [get_debug_ports u_ila_1/probe3]
connect_debug_port u_ila_1/probe3 [get_nets [list Aurora.aurora_comms/link_reset_out]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe4]
set_property port_width 1 [get_debug_ports u_ila_1/probe4]
connect_debug_port u_ila_1/probe4 [get_nets [list Aurora.aurora_comms/tx_lock]]
create_debug_core u_ila_2 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_2]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_2]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_2]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_2]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_2]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_2]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_2]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_2]
set_property port_width 1 [get_debug_ports u_ila_2/clk]
connect_debug_port u_ila_2/clk [get_nets [list Aurora.aurora_comms/aurora.aurora_support/clock_module_i/clkin1]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe0]
set_property port_width 1 [get_debug_ports u_ila_2/probe0]
connect_debug_port u_ila_2/probe0 [get_nets [list Aurora.aurora_comms/pll_not_locked_out]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets Clk125xC]
