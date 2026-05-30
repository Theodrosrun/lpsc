## Students

* André Miguel Serzedelo Costa
* Theodros Mulugeta

## Lecture / School / Year

MA – LPSC
Master of Science in Engineering (MSE), Lausanne
Academic year 2025–2026

## Project Description

This project consists of developing a hardware-accelerated Mandelbrot/Julia fractal generator on the SCALP FPGA platform. The design computes the fractal in VHDL using fixed-point arithmetic, stores the result in BRAM framebuffers, and displays it through VGA/HDMI. Several architectures were compared, from a simple FSM version to a pipelined and parallelized implementation using multiple generators to improve the frame generation time.


## VHDL Source Files

All VHDL source files for the Mandelbrot engine and related modules can be found in the following directory:

`scalp_revc/hw_firmware/designs/vivado/scalp_user_design/2023.2/src/hdl/`

Direct links to the main VHDL source files:

- [scalp_vga_if.vhd](scalp_revc/hw_firmware/designs/vivado/scalp_user_design/2023.2/src/hdl/scalp_vga_if.vhd)
- [mandelbrot_picture_gen_fsm.vhd](scalp_revc/hw_firmware/designs/vivado/scalp_user_design/2023.2/src/hdl/mandelbrot_picture_gen_fsm.vhd)
- [mandelbrot_iter_combinatorial.vhd](scalp_revc/hw_firmware/designs/vivado/scalp_user_design/2023.2/src/hdl/mandelbrot_iter_combinatorial.vhd)
- [mandelbrot_picture_gen_pipelined.vhd](scalp_revc/hw_firmware/designs/vivado/scalp_user_design/2023.2/src/hdl/mandelbrot_picture_gen_pipelined.vhd)
- [mandelbrot_zoom.vhd](scalp_revc/hw_firmware/designs/vivado/scalp_user_design/2023.2/src/hdl/mandelbrot_zoom.vhd)
- [mandelbrot_palette.vhd](scalp_revc/hw_firmware/designs/vivado/scalp_user_design/2023.2/src/hdl/mandelbrot_palette.vhd)
- [mandelbrot_pkg.vhd](scalp_revc/hw_firmware/designs/vivado/scalp_user_design/2023.2/src/hdl/mandelbrot_pkg.vhd)
- [mandelbrot_engine.vhd](scalp_revc/hw_firmware/designs/vivado/scalp_user_design/2023.2/src/hdl/mandelbrot_engine.vhd)
- [mandelbrot_iter_pipelined.vhd](scalp_revc/hw_firmware/designs/vivado/scalp_user_design/2023.2/src/hdl/mandelbrot_iter_pipelined.vhd)
- [scalp_user_design.vhd](scalp_revc/hw_firmware/designs/vivado/scalp_user_design/2023.2/src/hdl/scalp_user_design.vhd)
- [mandelbrot_iter.vhd](scalp_revc/hw_firmware/designs/vivado/scalp_user_design/2023.2/src/hdl/mandelbrot_iter.vhd)
- [mandelbrot_picture_gen.vhd](scalp_revc/hw_firmware/designs/vivado/scalp_user_design/2023.2/src/hdl/mandelbrot_picture_gen.vhd)