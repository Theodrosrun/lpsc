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

vlog -work xpm -64 -incr -mfcu  -sv -L axi_vip_v1_1_22 -L processing_system7_vip_v1_0_24 -L xilinx_vip "+incdir+../../../../../../../../../../../../../../../../vivado/2025.2/data/rsb/busdef" "+incdir+../../../../scalp_user_design.gen/sources_1/ip/vio_0/hdl/verilog" "+incdir+../../../../scalp_user_design.gen/sources_1/ip/vio_0/hdl" "+incdir+/home/andre/vivado/2025.2/data/xilinx_vip/include" \
"/home/andre/vivado/2025.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/home/andre/vivado/2025.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"/home/andre/vivado/2025.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93  \
"/home/andre/vivado/2025.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -64 -93  \
"../../../../scalp_user_design.gen/sources_1/ip/vio_0/sim/vio_0.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

