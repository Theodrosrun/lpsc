# scalp_board_files

## Getting started

### Vivado board files for SCALP boards

In order to add the ```Scalp board``` support to Vivado, the ```scalp_node``` folder must be copied to the ```<Vivado directory>/<version>/data/xhub/boards/XilinxBoardStore/boards/``` folder. To create a new project targeting the ```Scalp``` board, the ```"hepia-cores.ch:scalp_node:part0:0.2"``` board tag must be used. In addition, this board definition doesn't provide a fully accurate definition of the board and must evolve in the future.

### Vivado base project for the Scalp board

The Vivado project file ```scalp_user_design.xpr``` is stored in the following folder ```scalp_board_files/scalp_revc/hw_firmware/designs/vivado/scalp_user_design/2023.2/lin64/scalp_user_design```.

> **Please note** that Windows users may encounter an error :bomb: when the project is synthesised. The reason is that Windows **doesn't support long path names** :poop:.
>
> For those using Wind :poop: ws instead of Linux :penguin:, you will find the ```Scalp board``` Vivado project in the following folder ```scalp_board_files/scalp_revc_windows/scalp_user_design```. In addition, when you extract the compressed archive file or clone the Git repository, you should do so in the root of one of your hard disk partitions.

### How to install the drivers for the ```Digilent USB JTAG cable```

**Please note** that the drivers are stored in the Vivado installation path. You will find them respectively in the following folder ```<VIVADO_INSTALLATION_PATH>/data/xicom/cable_drivers/lin64/install_script/install_drivers``` for Linux users and in the following folder ```<VIVADO_INSTALLATION_PATH>/data/xicom/cable_drivers/nt64/dlc10_win7/install_script/install_drivers``` for Windows users.

Of course — here is the **English version** ready to paste into your README.

---

# scalp_user_design

## Description

`scalp_user_design` is the **top-level VHDL module** for the user design running on the **SCALP** board based on a **Zynq-7000 XC7Z015** device.
This module connects:

* the **Zynq Processing System (PS)**
* the **Programmable Logic (PL)**
* the **GPIO interfaces** (switches, joystick, LEDs)
* the **HDMI output**
* **AXI Lite registers** accessible from the processor

The current design allows:

* receiving data from the PS through AXI Lite
* driving the **RGB LEDs** using **PWM**
* reading the **switches** and **joystick**
* generating a **720x720 @ 60 Hz HDMI video output**
* displaying a simple **Swiss flag pattern**, with colors configurable through registers

---

## Hardware target

* **Board / Target device**: `hepia-cores.ch:scalp_node:part0:0.2`
* **FPGA**: `xc7z015clg485-2`
* **Vivado version**: `2023.2`

---

## Architecture overview

The architecture is divided into two main blocks:

### 1. `PSxB`

This block contains the interface with the **Zynq Processing System**:

* DDR
* MIO
* PS reset
* USB power fault
* external I2C
* AXI Lite interfaces toward the PL
* clock and reset generation for the design

This block is based on the component:

* `scalp_zynqps_wrapper`

### 2. `PLxB`

This block contains the FPGA programmable logic:

* AXI register handling for the LEDs
* PWM generation for RGB LEDs
* switch and joystick input handling
* pattern / complex number register handling
* HDMI video generation
* pixel generation for the displayed pattern

---

## Functional organization

### `scalp_zynqps_wrapper`

Wrapper around the Zynq PS.

Main roles:

* interface with PS / DDR / MIO signals
* distribution of clocks and resets
* exposure of two **AXI Lite** interfaces:

  * `FirmwareIDAxixD`
  * `ClpxNumRegsAxixD`

---

### `scalp_firmwareid`

AXI Lite slave block used to expose firmware-related registers.

In this design, it mainly provides:

* the color registers for the **2 RGB LEDs**

Output:

* `FirmwareLedColorPortsxD`

---

### `scalp_pwm`

PWM generation block.

It is instantiated **6 times**:

* Red LED 1
* Green LED 1
* Blue LED 1
* Red LED 2
* Green LED 2
* Blue LED 2

Each channel reads one 8-bit color component from the AXI registers and converts it into a PWM signal.

---

### `scalp_cplx_num_regs`

AXI Lite slave block used to expose additional registers.

In this design, it provides:

* `PatternPortsxD(0)`: background color
* `PatternPortsxD(1)`: cross color
* `ZImInPortxD`
* `ZReInPortxD`

The last two registers are present but are not used yet in the current display logic.

---

### `scalp_hdmi`

Block responsible for HDMI stream generation.

Functions:

* generation of video timings
* production of pixel counters `HxD` / `VxD`
* transmission of TMDS signals to the HDMI output

Current configuration:

* `C_VGA_720X720_60HZ_CONFIG`

---

### `BRAM_SDP_MACRO`

Two **Xilinx Block RAMs** of type **Simple Dual Port** are used to store the display pattern/colors.

Role:

* write access from the AXI side
* read access from the video side

This provides a clean crossing between:

* the processor / AXI clock domain
* the VGA / HDMI clock domain

---

## Data flow

### LED control

The data path is:

`PS -> AXI Lite -> scalp_firmwareid -> RGB registers -> scalp_pwm -> OBUF -> LEDs`

Each RGB LED uses one 24-bit register:

* bits `[23:16]`: red
* bits `[15:8]`: green
* bits `[7:0]`: blue

---

### HDMI image generation

The data path is:

`PS -> AXI Lite -> scalp_cplx_num_regs -> BRAM -> pixel generation logic -> scalp_hdmi -> HDMI output`

The `SwissFlagxP` process generates the pixels displayed on the screen using:

* the video counters
* the background color
* the cross color

---

## Generated video pattern

The current design displays a simple pattern similar to a **Swiss flag**:

* red background
* white cross

The colors are read from AXI registers through `PatternPortsxD`.

### Default colors

Inside `ImGenxB`:

* background: `x"00ff0000"`
* cross: `x"00ffffff"`

Used format:

* `0x00RRGGBB`

---

## Display pattern details

The `SwissFlagxP` process:

1. checks that the video PLL is locked and that the VGA reset is inactive
2. waits for the rising edge of the VGA clock
3. when video is active (`VidOnxS = '1'`):

   * first applies the background color
   * then replaces it with the cross color if the current pixel belongs to one of the two cross regions:

     * vertical bar
     * horizontal bar
4. otherwise outputs `C_HDMI_VGA_PIX_IDLE`

---

## External interfaces used

### Used in this design

* Zynq PS / DDR / MIO
* USB power fault
* external I2C
* HDMI TX
* switches
* joystick
* RGB LEDs
* self reset

### Present but currently unused / commented out

* GTP serial links
* LVDS links
* additional external clocks
* several board-level high-speed interfaces

These ports are kept in the top-level entity for compatibility with the SCALP platform, but they are not actively used in the current implementation.

---

## Clock domains

The design uses at least two relevant clock domains:

### 1. AXI / processor clock domain

Used for:

* AXI Lite register access
* LED PWM generation
* pattern register write access

### 2. VGA / HDMI clock domain

Used for:

* video timing generation
* BRAM read access
* pixel generation
* HDMI transmission

The BRAM-based storage provides a safe interface between these two domains.

---

## Main internal signals

### AXI-related

* `FirmwareIDAxixD`: AXI Lite interface for firmware/LED registers
* `ClpxNumRegsAxixD`: AXI Lite interface for pattern/complex registers

### Register outputs

* `FirmwareLedColorPortsxD`: LED color registers
* `PatternPortsxD`: pattern color registers
* `ZImInPortxD`, `ZReInPortxD`: additional complex number registers

### Video

* `HdmiVgaClocksxC`: HDMI/VGA clocks
* `VgaPixCountersxD`: current pixel counters
* `PixelxD`: current pixel color
* `HdmiTxxD`: HDMI output structure

### GPIO

* `GPIOSwitchesxD`: sampled switch values
* `GPIOJoystickxD`: sampled joystick values

---

## Primitive usage

The design directly instantiates several Xilinx primitives/macros:

* `IBUF`: input buffers for switches and joystick
* `OBUF`: output buffers for RGB LEDs
* `BRAM_SDP_MACRO`: dual-port block RAM for pattern storage

This means the design is not only composed of user-defined RTL modules, but also directly uses FPGA vendor primitives.

---

## Current purpose of the design

At the moment, this design acts as a **base platform** for:

* PS/PL communication through AXI Lite
* configurable RGB LED control
* basic HDMI display generation
* future integration of more advanced image generation or computation blocks

It is a convenient starting point for projects involving:

* image generation
* pattern display
* Mandelbrot/fractal computation
* PS-controlled hardware acceleration

---

## Module summary

| Module                 | Role                                                                    |
| ---------------------- | ----------------------------------------------------------------------- |
| `scalp_zynqps_wrapper` | Connects the Zynq PS, DDR, MIO, clocks, resets, and AXI Lite interfaces |
| `scalp_firmwareid`     | Provides firmware/LED-related AXI registers                             |
| `scalp_pwm`            | Generates PWM signals for RGB LEDs                                      |
| `scalp_cplx_num_regs`  | Provides pattern and additional computation-related AXI registers       |
| `scalp_hdmi`           | Generates HDMI video timing and transmission                            |
| `BRAM_SDP_MACRO`       | Stores pattern data across AXI and video clock domains                  |

---

## Notes

* The current video generator displays a simple Swiss flag-like pattern.
* The complex number registers already exist and can be reused in future developments.
* The design structure clearly separates:

  * PS integration
  * register/control logic
  * GPIO handling
  * video generation
