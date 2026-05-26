#import "@preview/latexlike-report:1.0.0": *

#show: latexlike-report.with(
  // ======== Cover ============
  //Use content [] or none, except in author.
  author: "Andrè Costa & Theodros Mulugeta",
  title: [LPSC],
  subtitle: [Laboratoire],

  participants: [],

  affiliation: [Computer Science],
  year: [2026],
  class: [Master of Science HES - Engineering],
  other: none,

  date: [#datetime.today().display("[day].[month].[year]")],

  logo: image("images/logo.svg", width: 4cm),

  //==========Theme ===============
  theme-color: rgb("#000000"),
  lang: "fr",
  participants-supplement: "Auteurs:",


  //=========Font =================
  title-font: "New Computer Modern",
  font: "New Computer Modern",
  font-size: 13pt,
  font-weight: 400,

  //============ Math =============

  math-font: "New Computer Modern Math",
  math-weight: 400,
  math-ref-supplement: auto, //Use none for no supplement, auto for language based or any other function or string you like
  math-numbering: "(1.1)", // The numbering style you like

  // ---- Equate package ---
  // For more information, you can refer to equate documentation

  math-number-mode: "label", //Can be "label" or "line"
  math-sub-numbering: true, // true or false

  //===========Page style===============
  pagebreak-section: false, //For pagebreak after adding a new level one heading (=)
  show-outline: true, //true or false
  page-paper: "a4",

  //-----chic header package----
  // customize the left/center/right header and left/center/right footer
  // you can add images, text, the number of the current page, etc, or put none if you don't want some part of the header or footer.
  //some usefull function: chic-page-number(), chic-heading-name()

  h-l: [#smallcaps[GesSec - Labo 3]],
  h-r: [#image("images/logo.svg", width: 25%)],
  h-c: none,

  f-l: [],
  f-r: [],
  f-c: chic-page-number(),
  //=======================================
  //For more customitation you can check the documentation. !! Enjoy :D !!
)

///////////////////////////Document starts/////////////////////////////
///////////////////////////
= Introduction

The purpose of this laboratory work is to implement and optimize a hardware-based fractal image generator on an FPGA. The developed design computes a Mandelbrot/Julia-type image, stores the result in internal video memory, and displays it through a VGA/HDMI output.

The system is written in VHDL and integrated in the `scalp_user_design` top-level module. It uses BRAM memories as framebuffers, a pixel coordinate generator, a Mandelbrot computation engine, an iteration unit, a color palette and a VGA interface.

Several architectures were implemented and compared. The first version uses a finite state machine and a sequential computation flow. The second version improves the design by using pipelining in the computation path and in the picture generation architecture. The final version adds spatial parallelism by using four pipelined Mandelbrot picture generators working in parallel on four independent parts of the image.

The objective is to evaluate the impact of fixed-point arithmetic, pipelining, memory partitioning and parallel computation on timing performance, FPGA resource usage and frame generation time.

= Global system architecture

The complete design is composed of the following main blocks:

```text
scalp_user_design
 ├── Zynq processing system
 ├── Clock and reset generation
 ├── mandelbrot_zoom
 ├── mandelbrot_picture_gen
 ├── mandelbrot_engine
 ├── mandelbrot_iter
 ├── BRAM framebuffers
 ├── scalp_vga_if
 └── mandelbrot_palette
```

The global computation and display flow is:

#align(center)[
  #image("images/architecture.png", width: 50%)
]

The image is generated pixel by pixel. For each pixel, the picture generator computes the corresponding complex coordinate and sends it to the Mandelbrot engine. The engine performs the iterative calculation and outputs the iteration count. This value is written into the BRAM framebuffer.

The design was first implemented with a single picture generator writing to one framebuffer. The final version improves the throughput by using four Mandelbrot picture generators in parallel. Each generator computes one quarter of the image and writes the result to its own BRAM region.

During display, the VGA interface reads the framebuffer, sends the stored iteration value to the palette module, and outputs the corresponding RGB value.

= Mandelbrot computation architecture

== Mandelbrot picture generator

The `mandelbrot_picture_gen` block is responsible for scanning an image region. It generates the horizontal and vertical pixel positions and converts them into complex coordinates.

Two architectures are available for this block:

```vhdl
mandelbrot_picture_gen(fsm)
mandelbrot_picture_gen(pipelined)
```

=== FSM picture generator

The FSM version processes one pixel at a time. It waits for the Mandelbrot engine to finish the computation of the current pixel before moving to the next one.

The control flow is sequential:

#align(center)[
  #image("images/fsm.png", width: 50%)
]

This architecture is simple and easy to debug, but the throughput is limited because the next pixel cannot start until the current pixel has finished.

=== Single pipelined picture generator

The single pipelined version improves throughput by overlapping operations and reducing idle time. It allows the design to reach a higher operating frequency and a shorter frame generation time.

The selected architecture can be controlled by the instantiation:

```vhdl
MandelbrotPictureGenxI : entity work.mandelbrot_picture_gen(pipelined)
```

or, for the FSM version:

```vhdl
MandelbrotPictureGenxI : entity work.mandelbrot_picture_gen(fsm)
```

=== Parallel pipelined picture generator

The final implementation uses four pipelined picture generators in parallel. The complete 512 x 512 framebuffer is divided into four horizontal regions:

```text
Generator 0 -> rows 0 to 127
Generator 1 -> rows 128 to 255
Generator 2 -> rows 256 to 383
Generator 3 -> rows 384 to 511
```

Each generator receives the same horizontal start coordinate `x0` and horizontal step `dx`, but receives a different vertical start coordinate `y0`. This allows each generator to compute a different part of the complex plane.

Each generator computes:

$
  512 * 128 = 65536
$

pixels instead of the complete 512 x 512 image. A full frame is considered complete only when all four generators have asserted their individual `FrameDone` signal.

== Mandelbrot engine

The `mandelbrot_engine` module controls the iterative computation for one pixel. It receives the initial complex coordinate and repeatedly calls the `mandelbrot_iter` block until the point diverges or the maximum number of iterations is reached.

#align(center)[
  #image("images/engine.png", width: 80%)
]

The engine is implemented as a finite state machine with three states:

```vhdl
type state_t is (IDLE, ITERATE, FINISH);
```

The role of each state is:

```text
IDLE    : wait for a new input pixel
ITERATE : perform Mandelbrot iterations
FINISH  : output the final iteration count
```

In the `IDLE` state, the engine waits for `i_valid`. When a new pixel is available, the input coordinate is stored, the iteration counter is reset, and the first iteration is started by asserting `math_i_valid`.

In the `ITERATE` state, the engine waits for `math_o_valid`, which indicates that the iteration unit has produced a valid result. If the point has diverged, or if the maximum number of iterations has been reached, the engine moves to the `FINISH` state. Otherwise, the newly computed value is fed back into the iteration unit for another iteration.

In the `FINISH` state, the engine outputs the final iteration count on `o_iter` and asserts `o_valid`.

The engine is compatible with both the combinational and pipelined versions of the iteration unit, because it waits for the `math_o_valid` signal before continuing.

== Mandelbrot iteration unit

The `mandelbrot_iter` block performs one step of the Mandelbrot recurrence:

$
  z_(n+1) = z_n^2 + c
$

It also computes the divergence condition:

$
  z_"re"^2 + z_"im"^2 >= 4
$

Two architectures are available:

```vhdl
mandelbrot_iter(combinatorial)
mandelbrot_iter(pipelined)
```

In the combinational version, all arithmetic operations are placed in one combinational path. This is simple, but it creates a long critical path.

In the pipelined version, the arithmetic operations are split into several stages separated by registers. This reduces the delay of each combinational stage and improves the timing performance. The drawback is additional latency, but this latency is handled by the valid/ready control signals.

= Framebuffer memory

The computed iteration count is stored in BRAM. Each address corresponds to one pixel of the generated image.

The framebuffer resolution is:

$
  512 * 512
$

Therefore, the total number of pixels stored in memory is:

$
  512 * 512 = 262144
$

Each pixel stores the iteration count returned by the Mandelbrot engine. The stored data width is 7 bits:

```vhdl
std_logic_vector(6 downto 0)
```

This is sufficient because the maximum number of iterations is 100, and 7 bits can represent values from 0 to 127:

$
  2^7 = 128
$

== Single-BRAM organization

In the first versions, the complete framebuffer is stored in one BRAM. The required depth is:

```text
Depth = 262144
```

The address width is 18 bits, because:

$
  2^18 = 262144
$

The Block Memory Generator is configured with:

```text
Port A Width = 7
Port A Depth = 262144

Port B Width = 7
Port B Depth = 262144
```

== Parallel BRAM organization

In the final parallel version, the framebuffer is split into four independent BRAMs. Each BRAM stores one quarter of the image:

$
  262144 / 4 = 65536
$

Therefore, each BRAM has:

```text
Width = 7 bits
Depth = 65536
```

Since:

$
  65536 = 2^16
$

each BRAM uses a 16-bit address. This is why the picture generators use:

```vhdl
C_BRAM_ADDR_BIT_SIZE => C_BRAM_ADDR_BIT_SIZE - 2
```

because:

$
  18 - 2 = 16
$

The four BRAMs together still store the complete 512 x 512 framebuffer:

```text
BRAM 0 -> 65536 pixels
BRAM 1 -> 65536 pixels
BRAM 2 -> 65536 pixels
BRAM 3 -> 65536 pixels
Total  -> 262144 pixels
```

This organization has the same total framebuffer capacity as the single-BRAM version, but it allows the four Mandelbrot generators to write their results independently and in parallel.

#align(center)[
  #image("images/parallelism.png", width: 80%)
]

= VGA scaling and display

The framebuffer resolution is not equal to the display resolution. The Mandelbrot image is generated and stored in a 512 x 512 framebuffer, while the active VGA display area is 720 x 720 pixels:

```vhdl
constant C_BUFFER_WIDTH    : integer := 512;
constant C_BUFFER_HEIGHT   : integer := 512;
constant C_VGA_ACTIVE_SIZE : integer := 720;
```

Therefore, the VGA interface performs a scaling operation when reading the framebuffer. The horizontal and vertical display coordinates are converted into framebuffer coordinates using:

```vhdl
HxScaledxD := (to_integer(unsigned(HxCntxDI)) * C_BUFFER_WIDTH) / C_VGA_ACTIVE_SIZE;
VxScaledxD := (to_integer(unsigned(VxCntxDI)) * C_BUFFER_HEIGHT) / C_VGA_ACTIVE_SIZE;
```

Then the global framebuffer read address is computed with:

```vhdl
BramRdAddrxD := (VxScaledxD * C_BUFFER_WIDTH) + HxScaledxD;
```

The scaling factor is:

$
  720 / 512 ≈ 1.406
$

In the parallel BRAM version, the two most significant bits of the read address select which BRAM must be read. The remaining lower address bits select the pixel inside the selected BRAM. This allows the VGA interface to see the four BRAMs as one logical 512 x 512 framebuffer.

The trade-off is that the displayed image is slightly upscaled, but the hardware cost is significantly lower than computing and storing a full 720 x 720 framebuffer.

= Color palette

The `mandelbrot_palette` module converts the iteration count read from the framebuffer into an RGB color.

The general principle is:

```text
Iteration count -> RGB value
```

Pixels that diverge quickly receive one color, while pixels that require more iterations receive another color. Points that do not diverge before the maximum number of iterations are usually displayed with a dark color.

This separation between computation and color generation is useful because the framebuffer only stores the iteration count, not the full RGB value. This reduces memory usage.

= Simulation and test script

A simulation script was created to automate the validation of the Mandelbrot VHDL blocks. The script uses GHDL to compile the sources, run the testbenches and generate VCD waveform files.

The script is located in:

```text
sim.sh
```

It compiles the Mandelbrot iteration unit, the Mandelbrot engine, the FSM picture generator and the pipelined picture generator in the correct order. Then, it runs the corresponding testbenches:

```bash
simulate tb_mandelbrot_iter
simulate tb_mandelbrot_iter_pipelined
simulate tb_mandelbrot_engine 10000ms
simulate tb_mandelbrot_picture_gen 10000ms
simulate tb_mandelbrot_picture_gen_pipelined 100ms
```

The testbenches generate PPM image files. These files are then compared with `cmp` to verify that the different architectures produce the same image:

```bash
cmp $ENGINE_OUTPUT_FILE $PICTURE_GEN_OUTPUT_FILE
cmp $PICTURE_GEN_PIPELINED_OUTPUT_FILE $PICTURE_GEN_OUTPUT_FILE
```

The first comparison checks that the Mandelbrot engine and the FSM picture generator produce the same result. The second comparison checks that the pipelined picture generator produces the same image as the FSM version.

If all comparisons succeed, the script prints:

```text
All tests passed
```

This confirms that the tested Mandelbrot blocks are functionally correct. The parallel version reuses the validated pipelined generator several times and distributes the framebuffer into independent regions.

= Timing analysis

Vivado timing reports were used to evaluate the maximum operating frequency of the design. Three implementations were compared: the FSM implementation, the single pipelined implementation, and the final parallel pipelined implementation.

== FSM implementation

The FSM implementation was constrained at 75 MHz. The corresponding clock period is:

$
  T = 1 / 75 "MHz" = 13.333 "ns"
$

Vivado reported:

```text
Worst Negative Slack = 0.512 ns
```

Because the slack is positive, all timing constraints are met. The estimated critical path delay is:

$
  13.333 "ns" - 0.512 "ns" = 12.821 "ns"
$

The estimated maximum frequency is therefore:

$
  f_"max" = 1 / 12.821 "ns" ≈ 78 "MHz"
$

== Single pipelined implementation

The single pipelined implementation was constrained at 125 MHz. The corresponding clock period is:

$
  T = 1 / 125 "MHz" = 8 "ns"
$

Vivado reported:

```text
Worst Negative Slack = 0.857 ns
```

Because the slack is positive, all timing constraints are met. The estimated critical path delay is:

$
  8 "ns" - 0.857 "ns" = 7.143 "ns"
$

The estimated maximum frequency is therefore:

$
  f_"max" = 1 / 7.143 "ns" ≈ 140 "MHz"
$

== Parallel pipelined implementation

The parallel pipelined implementation was also constrained at 125 MHz. The corresponding clock period is:

$
  T = 1 / 125 "MHz" = 8 "ns"
$

Vivado reported:

```text
Worst Negative Slack = 0.105 ns
```

Because the slack is positive, all timing constraints are met. The estimated critical path delay is:

$
  8 "ns" - 0.105 "ns" = 7.895 "ns"
$

The estimated maximum frequency is therefore:

$
  f_"max" = 1 / 7.895 "ns" ≈ 126.7 "MHz"
$

The parallel pipelined version still meets timing at 125 MHz, but with a smaller timing margin than the single pipelined version. This is expected because the design duplicates the Mandelbrot computation path four times and adds extra logic for BRAM selection, frame synchronization and framebuffer partitioning.

== Timing comparison

The comparison is summarized below:

#table(
  columns: 6,
  align: center,
  [Architecture], [Constraint], [Period], [WNS], [Critical path], [Estimated Fmax],
  [FSM], [75 MHz], [13.333 ns], [0.512 ns], [12.821 ns], [78 MHz],
  [Single pipelined], [125 MHz], [8.000 ns], [0.857 ns], [7.143 ns], [140 MHz],
  [Parallel pipelined], [125 MHz], [8.000 ns], [0.105 ns], [7.895 ns], [126.7 MHz],
)

All implementations meet timing because all WNS values are positive. The FSM version was validated at 75 MHz, while both pipelined versions were validated at 125 MHz.

The single pipelined version has the highest estimated maximum frequency. The parallel pipelined version has a lower estimated maximum frequency because it uses four computation paths in parallel and requires additional control and memory selection logic. However, it provides the best frame generation time because four image regions are computed simultaneously.

= FPGA resource utilization

Vivado resource reports were used to evaluate the hardware cost of the final pipelined and parallelized implementation. The most important resources are LUTs, flip-flops, BRAMs and DSP blocks.

The resource utilization of the final implementation is summarized below:

#table(
  columns: 5,
  align: center,
  [Resource], [Used], [Available], [Utilization], [Comment],
  [LUT], [~6000], [46200], [13%], [Logic, control and arithmetic],
  [Flip-Flop], [~6500], [92400], [7%], [Pipeline and control registers],
  [BRAM], [~56], [95], [59%], [Framebuffer memories],
  [DSP], [~18], [160], [11%], [Fixed-point multiplications],
)

The final implementation uses a moderate amount of LUTs and flip-flops. The LUT utilization is approximately 13%, while the flip-flop utilization is approximately 7%. These resources are mainly used for control logic, address generation, synchronization between the four generators, and pipeline registers.

The most used resource is BRAM, with approximately 59% utilization. This is expected because the design stores the complete 512 x 512 framebuffer in FPGA memory. In the final parallel version, the framebuffer is divided into four independent BRAM regions. Each region stores one quarter of the image, which allows the four Mandelbrot generators to write their results independently and in parallel.

The DSP utilization is approximately 11%. These DSP blocks are mainly used by the fixed-point multiplications inside the Mandelbrot iteration units. Since the final architecture instantiates four pipelined Mandelbrot generators, several multiplication paths are active in parallel, which increases DSP usage compared to a single-generator version.

The parallel pipelined version uses more resources than the FSM and single pipelined versions. This is expected because the computation path is replicated four times and additional logic is required for BRAM selection, frame synchronization and framebuffer partitioning. However, the resource usage remains within the available FPGA limits.

This resource increase is justified by the performance improvement. The final parallel pipelined version reduces the frame generation time to approximately 34.6 ms, corresponding to about 28.9 FPS, while still meeting timing at 125 MHz.

= Frame generation time

The frame generation time was measured for the implemented architectures. The measurement corresponds to the time required to compute one complete 512 x 512 framebuffer.

Three versions are compared:

```text
FSM version
Single pipelined version
Parallel pipelined version with four generators
```

In the parallel pipelined version, the framebuffer is split into four independent parts. Four Mandelbrot picture generators run in parallel, and each generator computes one quarter of the image. Each generator writes to its own BRAM. A frame is considered complete only when all four generators have finished their part.


== Frame generation comparison

The comparison is summarized below:

#table(
  columns: 5,
  align: center,
  [Architecture], [Clock], [Cycles per frame], [Frame time], [Frame rate],
  [FSM], [75 MHz], [27,400,456], [365 ms], [2.74 FPS],
  [Single pipelined], [125 MHz], [12,993,601], [104 ms], [9.62 FPS],
  [Parallel pipelined], [125 MHz], [4,326,949], [34.6 ms], [28.9 FPS],
)

Compared to the FSM version, the single pipelined version improves the frame generation time by:

$
  365 / 104 ≈ 3.51
$

Therefore, the single pipelined version is approximately 3.5 times faster than the FSM version.

Compared to the single pipelined version, the parallel pipelined version improves the frame generation time by:

$
  104 / 34.6 ≈ 3.01
$

Therefore, the parallel pipelined version is approximately 3.0 times faster than the single pipelined version.

Compared to the original FSM version, the parallel pipelined version improves the frame generation time by:

$
  365 / 34.6 ≈ 10.55
$

Therefore, the final parallel pipelined version is approximately 10.5 times faster than the FSM version.

This improvement comes from two effects. First, the pipelined versions run at a higher clock frequency. Second, the parallel pipelined version divides the image into four independent regions, which are computed simultaneously by four Mandelbrot generators.
