transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xilinx_vip
vlib riviera/xpm
vlib riviera/xil_defaultlib

vmap xilinx_vip riviera/xilinx_vip
vmap xpm riviera/xpm
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xilinx_vip  -incr -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 "+incdir+/tools/Xilinx/2025.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib \
"/tools/Xilinx/2025.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"/tools/Xilinx/2025.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"/tools/Xilinx/2025.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"/tools/Xilinx/2025.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"/tools/Xilinx/2025.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"/tools/Xilinx/2025.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"/tools/Xilinx/2025.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"/tools/Xilinx/2025.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"/tools/Xilinx/2025.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -incr -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 "+incdir+../../../../../../../../../../../../../../../../../tools/Xilinx/2025.2/data/rsb/busdef" "+incdir+../../../../scalp_user_design.gen/sources_1/ip/vio_0/hdl/verilog" "+incdir+../../../../scalp_user_design.gen/sources_1/ip/vio_0/hdl" "+incdir+/tools/Xilinx/2025.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib \
"/tools/Xilinx/2025.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/tools/Xilinx/2025.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"/tools/Xilinx/2025.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  -incr \
"/tools/Xilinx/2025.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -93  -incr \
"../../../../scalp_user_design.gen/sources_1/ip/vio_0/sim/vio_0.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

