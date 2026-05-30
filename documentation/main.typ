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

The system is written in VHDL and integrated in the scalp_user_design top-level module. It uses BRAM memories as framebuffers, a pixel coordinate generator, Mandelbrot picture generators, iteration units, a color palette and a VGA interface.

Several architectures were implemented and compared. The first version uses a finite state machine and a sequential computation flow. The second version improves the design by using pipelining in the computation path and in the picture generation architecture. The final version adds spatial parallelism by using thirty-two pipelined Mandelbrot picture generators working in parallel on thirty-two independent parts of the image.

The objective is to evaluate the impact of fixed-point arithmetic, pipelining, memory partitioning and parallel computation on timing performance, FPGA resource usage and frame generation time.

#pagebreak()

= Global system architecture

The complete design is composed of the following main blocks:

The global computation and display flow is:

#align(center)[
  #image("images/architecture.png", width: 50%)
]

The image is generated region by region. For each pixel, the picture generator computes the corresponding complex coordinate and sends it to the Mandelbrot iteration unit. The iteration unit performs one iteration of the Mandelbrot/Julia recurrence and outputs the next complex value as well as the divergence flag. The picture generator repeats this operation until the pixel diverges or the maximum number of iterations is reached. The final iteration count is then written into the corresponding BRAM framebuffer.

The design was first implemented with a single picture generator writing to one framebuffer. The final version improves the throughput by using thirty-two Mandelbrot picture generators in parallel. Each generator computes one thirty-second of the image and writes the result to its own independent BRAM region.

During display, the VGA interface reads the framebuffer, sends the stored iteration value to the palette module, and outputs the corresponding RGB value.

= Mandelbrot computation architecture

== Mandelbrot picture generator

The mandelbrot_picture_gen block is responsible for scanning an image region. It generates the horizontal and vertical pixel positions and converts them into complex coordinates.

Two architectures are available for this block:

#raw(
  block: true,
  lang: "vhdl",
  "mandelbrot_picture_gen(fsm)
mandelbrot_picture_gen(pipelined)",
)

=== FSM picture generator

The FSM version processes one pixel at a time. It waits for the computation of the current pixel to finish before moving to the next one.

The control flow is sequential:

#align(center)[
  #image("images/fsm.png", width: 50%)
]

This architecture is simple and easy to debug, but the throughput is limited because the next pixel cannot start until the current pixel has finished.

=== Single pipelined picture generator

The single pipelined version improves throughput by overlapping operations and reducing idle time. It allows the design to reach a higher operating frequency and a shorter frame generation time.

#align(center)[
  #image("images/pipeline.png", width: 100%)
]

In the pipelined version, the generator uses internal slots to keep track of several pixels that are currently being processed. Each slot stores the context of one pixel, including its position, current complex value, iteration count and state. This allows several pixels to share the same pipelined iteration unit without losing their context.

#align(center)[
  #image("images/slot.png", width: 100%)
]

#pagebreak()

A slot can be in one of three states:

#raw(
  block: true,
  lang: "vhdl",
  "type slot_state_t is (INACTIVE, READY, ACTIVE);",
)

The meaning of each state is:

#raw(
  block: true,
  lang: "text",
  "INACTIVE : the slot is free and can receive a new pixel
READY : the slot contains a pixel ready to enter the iteration unit
ACTIVE : the slot has been sent to the pipeline and is waiting for the result",
)

The iteration unit only performs one iteration. If the pixel has not diverged, the new complex value is written back into the corresponding slot, the iteration counter is incremented, and the slot becomes ready again for another iteration. If the pixel has diverged or has reached the maximum number of iterations, the final iteration count is written to BRAM and the slot becomes inactive.

The slot mechanism is required because the pipelined iterator has latency. A result comes out several clock cycles after the input was applied. Therefore, the generator must remember which pixel the result belongs to. This is done with a tag pipeline, which carries the slot index through the same latency as the iterator.

=== Parallel pipelined picture generator

The final implementation uses thirty-two pipelined picture generators in parallel. The complete 512 x 512 framebuffer is divided into thirty-two horizontal regions.

Since the framebuffer height is 512 pixels and the number of generators is 32, each generator computes:

$
  512 / 32 = 16
$

rows of the image.

The image is therefore divided as follows:

#raw(
  block: true,
  lang: "text",
  "Generator 0 -> rows 0 to 15
Generator 1 -> rows 16 to 31
Generator 2 -> rows 32 to 47
...
Generator 31 -> rows 496 to 511",
)

Each generator receives the same horizontal start coordinate x0 and horizontal step dx, but receives a different vertical start coordinate y0. This allows each generator to compute a different horizontal band of the complex plane.

Each generator computes:

$
  512 * 16 = 8192
$

pixels instead of the complete 512 x 512 image.

A full frame is considered complete only when all thirty-two generators have asserted their individual FrameDone signal.

== Mandelbrot iteration unit

The mandelbrot_iter block performs one step of the Mandelbrot/Julia recurrence:

$
  z_(n+1) = z_n^2 + c
$

It also computes the divergence condition:

$
  z_"re"^2 + z_"im"^2 >= 4
$

Two architectures are available:

#raw(
  block: true,
  lang: "vhdl",
  "mandelbrot_iter(combinatorial)
mandelbrot_iter(pipelined)",
)

In the combinational version, all arithmetic operations are placed in one combinational path. This is simple, but it creates a long critical path.

In the pipelined version, the arithmetic operations are split into several stages separated by registers. This reduces the delay of each combinational stage and improves the timing performance. The drawback is additional latency, but this latency is handled by the valid signal and by the slot/tag mechanism in the pipelined picture generator.

The pipelined iteration unit is divided into three main stages:

#raw(
  block: true,
  lang: "text",
  "Stage 1 : fixed-point multiplications
Stage 2 : fixed-point slicing and arithmetic
Stage 3 : output generation and divergence comparison",
)

In the first stage, the unit computes:

$
  z_"re"^2
$

$
  z_"im"^2
$

$
  z_"re" * z_"im"
$

In the second stage, the next complex value is computed:

$
  z_"re,next" = z_"re"^2 - z_"im"^2 + c_"re"
$

$
  z_"im,next" = 2 * z_"re" * z_"im" + c_"im"
$

The squared magnitude is also computed:

$
  |z|^2 = z_"re"^2 + z_"im"^2
$

In the third stage, the squared magnitude is compared with the divergence threshold:

$
  |z|^2 >= 4
$

If the condition is true, the output div is asserted. Otherwise, the pixel must continue iterating.

The iteration unit only computes one iteration. The repeated loop over multiple iterations is managed by the picture generator and its slots.

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

Each pixel stores the iteration count returned by the Mandelbrot computation. The stored data width is 7 bits:

#raw(
  block: true,
  lang: "vhdl",
  "std_logic_vector(6 downto 0)",
)

This is sufficient because the maximum number of iterations is 100, and 7 bits can represent values from 0 to 127:

$
  2^7 = 128
$

== Single-BRAM organization

In the first versions, the complete framebuffer is stored in one BRAM. The required depth is:

#raw(
  block: true,
  lang: "text",
  "Depth = 262144",
)

The address width is 18 bits, because:

$
  2^18 = 262144
$

The Block Memory Generator is configured with:

#raw(
  block: true,
  lang: "text",
  "Port A Width = 7
Port A Depth = 262144

Port B Width = 7
Port B Depth = 262144",
)

== Parallel BRAM organization

In the final parallel version, the framebuffer is split into 32 independent BRAMs. Each BRAM stores one thirty-second of the image:

$
  262144 / 32 = 8192
$

Therefore, each BRAM has:

#raw(
  block: true,
  lang: "text",
  "Width = 7 bits
Depth = 8192",
)

Since:

$
  8192 = 2^13
$

each BRAM uses a 13-bit address. This is why the picture generators use:

#raw(
  block: true,
  lang: "vhdl",
  "C_BRAM_ADDR_BIT_SIZE => C_BRAM_ADDR_BIT_SIZE - 5",
)

because:

$
  18 - 5 = 13
$

The 32 BRAMs together still store the complete 512 x 512 framebuffer:

#raw(
  block: true,
  lang: "text",
  "BRAM 0 -> 8192 pixels
BRAM 1 -> 8192 pixels
BRAM 2 -> 8192 pixels
...
BRAM 31 -> 8192 pixels
Total -> 262144 pixels",
)

This organization has the same total framebuffer capacity as the single-BRAM version, but it allows the 32 Mandelbrot generators to write their results independently and in parallel. The schema represents an example of four parallel generators which is duplicated eight times to reach the final thirty-two generators:

#align(center)[
  #image("images/parallelism.png", width: 80%)
]

= VGA scaling and display

The framebuffer resolution is not equal to the display resolution. The Mandelbrot image is generated and stored in a 512 x 512 framebuffer, while the active VGA display area is 720 x 720 pixels:

#raw(
  block: true,
  lang: "vhdl",
  "constant C_BUFFER_WIDTH : integer := 512;
constant C_BUFFER_HEIGHT : integer := 512;
constant C_VGA_ACTIVE_SIZE : integer := 720;",
)

Therefore, the VGA interface performs a scaling operation when reading the framebuffer. The horizontal and vertical display coordinates are converted into framebuffer coordinates using:

#raw(
  block: true,
  lang: "vhdl",
  "HxScaledxD := (to_integer(unsigned(HxCntxDI)) * C_BUFFER_WIDTH) / C_VGA_ACTIVE_SIZE;
VxScaledxD := (to_integer(unsigned(VxCntxDI)) * C_BUFFER_HEIGHT) / C_VGA_ACTIVE_SIZE;",
)

Then the global framebuffer read address is computed with:

#raw(
  block: true,
  lang: "vhdl",
  "BramRdAddrxD := (VxScaledxD * C_BUFFER_WIDTH) + HxScaledxD;",
)

The scaling factor is:

$
  720 / 512 ≈ 1.406
$

In the parallel BRAM version, the five most significant bits of the read address select which BRAM must be read. The remaining lower address bits select the pixel inside the selected BRAM.

Since the complete framebuffer contains 262144 pixels, the global address width is 18 bits. With 32 BRAMs, each BRAM stores 8192 pixels, which requires 13 address bits. Therefore, the address is split as follows:

#raw(
  block: true,
  lang: "text",
  "Global address width = 18 bits
BRAM select bits = 5 bits
Local BRAM address = 13 bits",
)

This allows the VGA interface to access the thirty-two BRAMs as one logical 512 x 512 framebuffer.

The trade-off is that the displayed image is slightly upscaled, but the hardware cost is significantly lower than computing and storing a full 720 x 720 framebuffer.

= Color palette

The mandelbrot_palette module converts the iteration count read from the framebuffer into an RGB color.

The general principle is:

#raw(
  block: true,
  lang: "text",
  "Iteration count -> RGB value",
)

Pixels that diverge quickly receive one color, while pixels that require more iterations receive another color. Points that do not diverge before the maximum number of iterations are usually displayed with a dark color.

This separation between computation and color generation is useful because the framebuffer only stores the iteration count, not the full RGB value. This reduces memory usage.

= Simulation and test script

A simulation script was created to automate the validation of the Mandelbrot VHDL blocks. The script uses GHDL to compile the sources, run the testbenches and generate VCD waveform files.

The script is located in:

#raw(
  block: true,
  lang: "text",
  "sim.sh",
)

It compiles the Mandelbrot iteration unit, the FSM picture generator and the pipelined picture generator in the correct order. Then, it runs the corresponding testbenches:

#raw(
  block: true,
  lang: "bash",
  "simulate tb_mandelbrot_iter
simulate tb_mandelbrot_iter_pipelined
simulate tb_mandelbrot_picture_gen 10000ms
simulate tb_mandelbrot_picture_gen_pipelined 100ms",
)

The testbenches generate PPM image files. These files are then compared with cmp to verify that the different architectures produce the same image:

#raw(
  block: true,
  lang: "bash",
  "cmp $PICTURE_GEN_PIPELINED_OUTPUT_FILE $PICTURE_GEN_OUTPUT_FILE",
)

The comparison checks that the pipelined picture generator produces the same image as the FSM version.

If all comparisons succeed, the script prints:

#raw(
  block: true,
  lang: "text",
  "All tests passed",
)

This confirms that the tested Mandelbrot blocks are functionally correct. The parallel version reuses the validated pipelined generator thirty-two times and distributes the framebuffer into independent regions.

= Timing analysis

Vivado timing reports were used to evaluate the maximum operating frequency of the design. Three implementations were compared: the FSM implementation, the single pipelined implementation, and the final parallel pipelined implementation.

== FSM implementation

The FSM implementation was constrained at 75 MHz. The corresponding clock period is:

$
  T = 1 / 75 "MHz" = 13.333 "ns"
$

Vivado reported:

#raw(
  block: true,
  lang: "text",
  "Worst Negative Slack = 0.512 ns",
)

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

#raw(
  block: true,
  lang: "text",
  "Worst Negative Slack = 0.857 ns",
)

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

#raw(
  block: true,
  lang: "text",
  "Worst Negative Slack = 0.105 ns",
)

Because the slack is positive, all timing constraints are met. The estimated critical path delay is:

$
  8 "ns" - 0.105 "ns" = 7.895 "ns"
$

The estimated maximum frequency is therefore:

$
  f_"max" = 1 / 7.895 "ns" ≈ 126.7 "MHz"
$

The parallel pipelined version still meets timing at 125 MHz, but with a smaller timing margin than the single pipelined version. This is expected because the design duplicates the Mandelbrot computation path thirty-two times and adds extra logic for BRAM selection, frame synchronization and framebuffer partitioning.

== Timing comparison

The comparison is summarized below:

#table(
  columns: 6,
  align: center,
  [Architecture], [Constraint], [Period], [WNS], [Critical path], [Estimated Fmax],
  [FSM], [75 MHz], [13.333 ns], [0.512 ns], [12.821 ns], [78 MHz],
  [Single pipelined], [125 MHz], [8.000 ns], [0.857 ns], [7.143 ns], [140 MHz],
  [Parallel pipelined, 32 generators], [125 MHz], [8.000 ns], [0.105 ns], [7.895 ns], [126.7 MHz],
)

All implementations meet timing because all WNS values are positive. The FSM version was validated at 75 MHz, while both pipelined versions were validated at 125 MHz.

The single pipelined version has the highest estimated maximum frequency. The parallel pipelined version has a lower estimated maximum frequency because it uses thirty-two computation paths in parallel and requires additional control and memory selection logic. However, it provides the best frame generation time because thirty-two image regions are computed simultaneously.

= FPGA resource utilization

Vivado resource reports were used to evaluate the hardware cost of the final pipelined and parallelized implementation. The most important resources are LUTs, flip-flops, BRAMs and DSP blocks.

The resource utilization of the final implementation is summarized below:

#table(
  columns: 5,
  align: center,
  [Resource], [Used], [Available], [Utilization], [Comment],
  [LUT], [~6000], [46200], [13%], [Logic, control and arithmetic],
  [Flip-Flop], [~6500], [92400], [7%], [Pipeline and control registers],
  [BRAM], [~65], [95], [68%], [Framebuffer memories],
  [DSP], [~128], [160], [80%], [Fixed-point multiplications],
)

The final implementation uses a moderate amount of LUTs and flip-flops. The LUT utilization is approximately 13%, while the flip-flop utilization is approximately 7%. These resources are mainly used for control logic, address generation, synchronization between the thirty-two generators, and pipeline registers.

The BRAM utilization is approximately 68%. This is expected because the design stores the complete 512 x 512 framebuffer in FPGA memory. In the final parallel version, the framebuffer is divided into thirty-two independent BRAM regions. Each region stores one thirty-second of the image, which allows the thirty-two Mandelbrot generators to write their results independently and in parallel.

The DSP utilization is approximately 80%. These DSP blocks are mainly used by the fixed-point multiplications inside the Mandelbrot iteration units. Since the final architecture instantiates thirty-two pipelined Mandelbrot generators, many multiplication paths are active in parallel. This explains the high DSP usage compared to the FSM and single pipelined versions.

The parallel pipelined version uses more resources than the FSM and single pipelined versions. This is expected because the computation path is replicated thirty-two times and additional logic is required for BRAM selection, frame synchronization, and framebuffer partitioning. However, the resource usage remains within the available FPGA limits.

This resource increase is justified by the performance improvement. The final parallel pipelined version reduces the frame generation time to approximately 6.41 ms, corresponding to about 156 FPS, while still meeting timing at 125 MHz.

= Frame generation time

The frame generation time was measured for the implemented architectures. The measurement corresponds to the time required to compute one complete 512 x 512 framebuffer.

Three versions are compared:

#raw(
  block: true,
  lang: "text",
  "FSM version
Single pipelined version
Parallel pipelined version with thirty-two generators",
)

In the parallel pipelined version, the framebuffer is split into thirty-two independent parts. Thirty-two Mandelbrot picture generators run in parallel, and each generator computes one thirty-second of the image. Each generator writes to its own BRAM. A frame is considered complete only when all thirty-two generators have finished their part.

== Frame generation comparison

The comparison is summarized below:

#table(
  columns: 5,
  align: center,
  [Architecture], [Clock], [Cycles per frame], [Frame time], [Frame rate],
  [FSM], [75 MHz], [27,400,456], [365 ms], [2.74 FPS],
  [Single pipelined], [125 MHz], [12,993,601], [104 ms], [9.62 FPS],
  [Parallel pipelined, 32 generators], [125 MHz], [801,282], [6.41 ms], [156 FPS],
)

The FSM implementation is the slowest version, with a frame generation time of 365 ms, corresponding to 2.74 FPS.

The single pipelined implementation reduces the frame generation time to 104 ms, corresponding to 9.62 FPS. Compared to the FSM implementation, this gives an improvement of:

$
  365 / 104 ≈ 3.51
$

Therefore, the single pipelined version is approximately 3.5 times faster than the FSM version.

The parallel pipelined implementation further reduces the frame generation time to 6.41 ms, corresponding to 156 FPS. Compared to the single pipelined implementation, this gives an improvement of:

$
  104 / 6.41 ≈ 16.22
$

Therefore, the parallel pipelined version is approximately 16.2 times faster than the single pipelined version.

Overall, compared to the original FSM implementation, the final parallel pipelined version improves the frame generation time by:

$
  365 / 6.41 ≈ 56.94
$

Therefore, the final parallel pipelined version is approximately 56.9 times faster than the original FSM version.

This overall improvement is the result of two successive optimizations. The first improvement comes from replacing the FSM-based architecture with a pipelined architecture, which also allows the design to run at a higher clock frequency. The second improvement comes from the parallel pipelined architecture, where the image is divided into thirty-two independent regions computed simultaneously by thirty-two Mandelbrot generators.

= Conclusion

This laboratory work demonstrates the implementation and optimization of a hardware fractal image generator on an FPGA. Starting from a simple FSM-based architecture, the design was progressively improved using pipelining and spatial parallelism.

The FSM implementation is simple and functionally correct, but its throughput is limited because pixels are processed sequentially. The pipelined implementation improves the computation rate by reducing idle time and by allowing the design to run at a higher frequency. The final parallel pipelined implementation further improves performance by dividing the framebuffer into thirty-two independent regions and computing them simultaneously with thirty-two pipelined Mandelbrot picture generators.

The final architecture combines two levels of optimization: temporal parallelism inside each pipelined picture generator, and spatial parallelism across thirty-two independent Mandelbrot picture generators. Each generator computes a 512 x 16 region of the framebuffer and writes to its own BRAM, allowing the complete 512 x 512 image to be generated much faster.

The results show that the final implementation achieves a frame generation time of approximately 6.41 ms, corresponding to about 156 FPS, while still meeting timing at 125 MHz. This represents an overall speedup of approximately 56.9 compared to the original FSM implementation.

The increased performance comes at the cost of higher resource usage, especially DSP and BRAM utilization. However, the final implementation remains within the available FPGA resources and demonstrates that fixed-point arithmetic, pipelining, memory partitioning and parallel computation are effective techniques for accelerating fractal image generation in hardware.
