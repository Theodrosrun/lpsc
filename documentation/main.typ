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
  show-outline: false, //true or false
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

TODO: Mesurer le nombre d'itérations avec vio
TODO: Ajouter les scripts de test

= Introduction

The purpose of this laboratory work is to implement a hardware-based fractal image generator on an FPGA. The developed design computes a Mandelbrot/Julia-type image, stores the result in an internal video memory, and displays it through a VGA/HDMI output.

The system is written in VHDL and integrated in the `scalp_user_design` top-level module. It uses a BRAM memory as a framebuffer, a pixel coordinate generator, a Mandelbrot computation engine, an iteration unit, a color palette and a VGA interface.

Several architectures were implemented and compared. A first version uses a finite state machine and a simple iterative computation flow. A second version improves the design by using pipelining, both in the Mandelbrot iteration unit and in the picture generation architecture. The goal is to evaluate the impact of pipelining on timing performance and maximum operating frequency.

= Mathematical principle

The fractal computation is based on an iterative complex equation. For each pixel, a complex coordinate is generated. The Mandelbrot iteration is then applied until the point diverges or until the maximum number of iterations is reached.

The recurrence relation is:

$
  z_(n+1) = z_n^2 + c
$

where:

$
  z_n = z_"re" + j z_"im"
$

By separating real and imaginary parts, the equations become:

$
  z_"re"(n+1) = z_"re"(n)^2 - z_"im"(n)^2 + c_"re"
$

$
  z_"im"(n+1) = 2 z_"re"(n) z_"im"(n) + c_"im"
$

The divergence condition is:

$
  z_"re"^2 + z_"im"^2 >= 4
$

If this condition becomes true, the point is considered divergent. The number of iterations required before divergence is used as the pixel value. This value is later converted into a color by the palette module.

In the current implementation, the constant `c` is fixed inside the Mandelbrot engine:

```vhdl
reg_c_re <= to_signed(11633, DATA_W);
reg_c_im <= to_signed(11633, DATA_W);
```

The design uses fixed-point arithmetic with `FRAC_W = 15`. Therefore, the value `11633` corresponds approximately to:

$
  11633 / 2^15 approx 0.355
$

Thus, the complex constant used is approximately:

$
  c = 0.355 + j 0.355
$

= Fixed-point representation

The design uses signed fixed-point arithmetic instead of floating-point arithmetic. This is more suitable for FPGA implementation because it reduces resource usage and avoids the need for expensive floating-point operators.

The main numerical parameters are:

```vhdl
DATA_W := 18
FRAC_W := 15
```

This means that each value is represented with 18 bits, including 15 fractional bits. A real value is converted to fixed-point format by multiplying it by:

$
  2^15 = 32768
$

For example:

$
  0.355 dot 32768 approx 11633
$

The use of fixed-point arithmetic provides a good compromise between precision and hardware cost. The precision is sufficient to generate a correct fractal image, while the arithmetic units remain small enough for FPGA implementation.

= Global architecture

The complete design is composed of the following main blocks:

```text
scalp_user_design
 ├── mandelbrot_picture_gen
 ├── mandelbrot_engine
 ├── mandelbrot_iter
 ├── BRAM framebuffer
 ├── mandelbrot_palette
 └── scalp_vga_if
```

The global data flow is:

```text
Pixel coordinates
      ↓
Complex coordinate generation
      ↓
Mandelbrot engine
      ↓
Iteration count
      ↓
BRAM framebuffer
      ↓
Color palette
      ↓
VGA/HDMI output
```

The image is generated pixel by pixel. For each pixel, the picture generator computes the corresponding complex coordinate and sends it to the Mandelbrot engine. The engine performs the iterative calculation and outputs the iteration count. This value is written into the BRAM framebuffer.

During display, the VGA interface reads the framebuffer, sends the stored iteration value to the palette module, and outputs the corresponding RGB value.

= Mandelbrot picture generator

The `mandelbrot_picture_gen` block is responsible for scanning the complete image. It generates the horizontal and vertical pixel positions and converts them into complex coordinates.

Two architectures are available for this block:

```vhdl
mandelbrot_picture_gen(fsm)
mandelbrot_picture_gen(pipelined)
```

The FSM version processes one pixel at a time. It waits for the Mandelbrot engine to finish the computation of the current pixel before moving to the next one.

The pipelined version improves throughput by overlapping operations and reducing idle time. This version is more complex, but it allows the design to reach a higher operating frequency.

In the top-level design, the selected architecture is defined by the instantiation:

```vhdl
MandelbrotPictureGenxI : entity work.mandelbrot_picture_gen(pipelined)
```

To use the FSM version instead, the instantiation can be changed to:

```vhdl
MandelbrotPictureGenxI : entity work.mandelbrot_picture_gen(fsm)
```

= Mandelbrot engine

The `mandelbrot_engine` module controls the iterative computation for one pixel. It receives the initial complex coordinate and repeatedly calls the `mandelbrot_iter` block until the point diverges or the maximum number of iterations is reached.

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

This design is compatible with both the combinational and pipelined versions of the iteration unit, because the engine does not assume that the result is available immediately. It always waits for the `math_o_valid` signal.

= Mandelbrot iteration unit

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

== Combinational iteration unit

In the combinational version, all arithmetic operations are placed in one combinational path. This includes multiplications, additions, subtractions and the divergence comparison.

The advantage of this implementation is its simplicity. However, the critical path is long, which limits the maximum clock frequency.

This version is useful as a reference implementation, but it is not optimal for high-frequency operation.

== Pipelined iteration unit

In the pipelined version, the arithmetic operations are split into several stages separated by registers. This reduces the delay of each combinational stage and improves the timing performance.

The drawback is that the result is not available immediately. It appears after the pipeline latency. However, this is not a problem because the Mandelbrot engine waits for `math_o_valid` before continuing.

To explicitly select the pipelined version, the instantiation should be written as:

```vhdl
mandelbrot_iter : entity work.mandelbrot_iter(pipelined)
```

To explicitly select the combinational version, the instantiation should be:

```vhdl
mandelbrot_iter : entity work.mandelbrot_iter(combinatorial)
```

It is recommended to always specify the architecture explicitly. Otherwise, the selected architecture may depend on the compilation order in Vivado.

= Possible architecture combinations

The implemented design allows several combinations between the picture generator and the iteration unit.

The main possible combinations are:

```text
FSM picture generator + combinational iteration unit
FSM picture generator + pipelined iteration unit
Pipelined picture generator + pipelined iteration unit
```

The first combination is the simplest one. It is easy to understand and useful for validation, but it has the lowest performance.

The second combination keeps the FSM-based control but improves the arithmetic timing by using a pipelined iteration unit.

The third combination is the most optimized version. It uses both a pipelined picture generator and a pipelined iteration unit. This is the version that provides the best timing results.

= Framebuffer memory

The computed iteration count is stored in a BRAM framebuffer. Each address corresponds to one pixel of the generated image.

In this project, the framebuffer resolution is:

$
  512 times 512
$

Therefore, the total number of pixels stored in memory is:

$
  512 times 512 = 262144
$

Each pixel stores the iteration count returned by the Mandelbrot engine. The stored data width is 7 bits:

```vhdl
std_logic_vector(6 downto 0)
```

This is sufficient because the maximum number of iterations is 100, and 7 bits can represent values from 0 to 127:

$
  2^7 = 128
$

The BRAM depth is therefore configured as:

```text
Depth = 262144
```

The address width must be 18 bits, because:

$
  2^18 = 262144
$

Thus, the framebuffer constants used in the top-level design are:

```vhdl
constant C_BUFFER_WIDTH       : integer := 512;
constant C_BUFFER_HEIGHT      : integer := 512;
constant C_BRAM_ADDR_BIT_SIZE : integer := 18;
```

The Block Memory Generator is configured with:

```text
Port A Width = 7
Port A Depth = 262144

Port B Width = 7
Port B Depth = 262144
```

The width of 7 bits corresponds to the stored iteration value, while the depth of 262144 corresponds to the total number of pixels in the 512 x 512 framebuffer.

This memory organization reduces the required BRAM resources compared to storing full RGB values. The framebuffer only stores the iteration count, and the final color is generated later by the palette module during display.

= VGA scaling

The framebuffer resolution is not equal to the display resolution. In this project, the Mandelbrot image is generated and stored in a 512 x 512 BRAM framebuffer, while the active VGA display area is 720 x 720 pixels:

```vhdl
constant C_BUFFER_WIDTH    : integer := 512;
constant C_BUFFER_HEIGHT   : integer := 512;
constant C_VGA_ACTIVE_SIZE : integer := 720;
```

Therefore, the VGA interface performs a scaling operation when reading the framebuffer. The goal is to display the 512 x 512 generated image over the full 720 x 720 active area.

The horizontal and vertical display coordinates are converted into framebuffer coordinates using:

```vhdl
HxScaledxD := (to_integer(unsigned(HxCntxDI)) * C_BUFFER_WIDTH) / C_VGA_ACTIVE_SIZE;
VxScaledxD := (to_integer(unsigned(VxCntxDI)) * C_BUFFER_HEIGHT) / C_VGA_ACTIVE_SIZE;
```

Then the BRAM read address is computed with:

```vhdl
BramRdAddrxD := (VxScaledxD * C_BUFFER_WIDTH) + HxScaledxD;
```

This means that the display coordinate is mapped to the corresponding pixel in the 512 x 512 framebuffer.

The scaling factor is:

$
  720 / 512 approx 1.406
$

As a result, the 512 x 512 image is enlarged to fill the 720 x 720 display area. This approach reduces memory usage and computation time, because only 262144 pixels need to be generated instead of 518400 pixels for a full 720 x 720 framebuffer.

The trade-off is that the displayed image is slightly upscaled, but the hardware cost is significantly lower.

= Color palette

The `mandelbrot_palette` module converts the iteration count read from the framebuffer into an RGB color.

The general principle is:

```text
Iteration count → RGB value
```

Pixels that diverge quickly receive one color, while pixels that require more iterations receive another color. Points that do not diverge before the maximum number of iterations are usually displayed with a dark color.

This separation between computation and color generation is useful because the framebuffer only stores the iteration count, not the full RGB value. This reduces memory usage.

= Timing analysis

Vivado timing reports were used to evaluate the maximum operating frequency of the design. Two implementations were compared: a baseline implementation and a pipelined implementation.

The baseline implementation was constrained at 75 MHz. The corresponding clock period is:

$
  T = 1 / 75 " MHz" = 13.333 " ns"
$

Vivado reported:

```text
Worst Negative Slack = 0.512 ns
```

Because the slack is positive, all timing constraints are met. The estimated critical path delay is:

$
  13.333 " ns" - 0.512 " ns" = 12.821 " ns"
$

The estimated maximum frequency is therefore:

$
  f_"max" = 1 / 12.821 " ns" approx 78 " MHz"
$

The pipelined implementation was constrained at 125 MHz. The corresponding clock period is:

$
  T = 1 / 125 " MHz" = 8 " ns"
$

Vivado reported:

```text
Worst Negative Slack = 0.857 ns
```

The estimated critical path delay is:

$
  8 " ns" - 0.857 " ns" = 7.143 " ns"
$

The estimated maximum frequency is:

$
  f_"max" = 1 / 7.143 " ns" approx 140 " MHz"
$

The comparison is summarized below:

#table(
  columns: 6,
  align: center,
  [Architecture], [Constraint], [Period], [WNS], [Critical path], [Estimated Fmax],
  [Baseline], [75 MHz], [13.333 ns], [0.512 ns], [12.821 ns], [78 MHz],
  [Pipelined], [125 MHz], [8.000 ns], [0.857 ns], [7.143 ns], [140 MHz],
)

The operating frequency increased from 75 MHz to 125 MHz:

$
  125 / 75 = 1.67
$

This corresponds to an improvement of approximately 66.7 percent.

If the estimated maximum frequencies are compared, the improvement is:

$
  140 / 78 approx 1.79
$

which corresponds to approximately 79 percent.

This improvement is mainly due to the reduction of the critical path. In the baseline version, several arithmetic operations are chained in the same combinational path. In the pipelined version, these operations are separated by registers, which allows the FPGA to operate at a higher clock frequency.

= Frame generation time measurement

The generation time of a complete frame can be measured by adding a cycle counter and reading it with a VIO core in Vivado Hardware Manager.

The design already provides a frame-complete signal:

```vhdl
MandelbrotFrameDonexS
```

The measurement principle is:

```text
Start frame generation
      ↓
Reset cycle counter
      ↓
Increment counter every clock cycle
      ↓
Stop when MandelbrotFrameDonexS is asserted
      ↓
Read final counter value with VIO
```

A possible VHDL implementation is:

```vhdl
signal FrameCycleCntxD     : unsigned(31 downto 0) := (others => '0');
signal LastFrameCycleCntxD : unsigned(31 downto 0) := (others => '0');
signal FrameMeasuringxS    : std_logic := '0';

process(ClkUsrxC, ClkUsrRstxRNA)
begin
    if ClkUsrRstxRNA = '0' then
        FrameCycleCntxD     <= (others => '0');
        LastFrameCycleCntxD <= (others => '0');
        FrameMeasuringxS    <= '0';

    elsif rising_edge(ClkUsrxC) then

        if MandelbrotStartxS = '1' then
            FrameCycleCntxD  <= (others => '0');
            FrameMeasuringxS <= '1';

        elsif FrameMeasuringxS = '1' then
            FrameCycleCntxD <= FrameCycleCntxD + 1;
        end if;

        if MandelbrotFrameDonexS = '1' and FrameMeasuringxS = '1' then
            LastFrameCycleCntxD <= FrameCycleCntxD;
            FrameMeasuringxS    <= '0';
        end if;

    end if;
end process;
```

The signal `LastFrameCycleCntxD` is connected to an input probe of the VIO core. The value can then be read directly in Vivado Hardware Manager.

At 125 MHz, the frame generation time is:

$
  t_"frame" = "cycle count" / 125000000
$

In milliseconds:

$
  t_"frame,ms" = "cycle count" / 125000
$

For example, if the VIO reports:

```text
LastFrameCycleCntxD = 12500000
```

then the frame generation time is:

$
  12500000 / 125000000 = 0.1 " s" = 100 " ms"
$

This measurement corresponds to the time required to compute and fill the framebuffer. It does not correspond to the VGA refresh time, which is determined by the video timing.

= Discussion

The results show that the Mandelbrot algorithm is well suited for FPGA implementation. The computation is repetitive and can be mapped efficiently to hardware using fixed-point arithmetic.

The FSM-based architecture is simple and easy to debug, but its performance is limited because it processes the computation sequentially. The pipelined architecture is more complex, but it significantly improves the timing performance.

The timing comparison shows that pipelining reduces the critical path from approximately 12.821 ns to 7.143 ns. As a result, the design can run at 125 MHz with positive slack, whereas the baseline implementation was limited to approximately 75 MHz.

The framebuffer resolution also has an important impact on memory usage and generation time. In this implementation, a 512 x 512 framebuffer is used, which corresponds to 262144 pixels. This choice reduces the required BRAM size and decreases the number of pixels that must be computed for each frame.

The VGA active area is 720 x 720 pixels, but the framebuffer is scaled during display. This means that the generated 512 x 512 image is enlarged to fill the screen. This is a good compromise between image quality, memory usage and frame generation time.

= Conclusion

This laboratory work resulted in a complete FPGA-based fractal generator. The system computes a Mandelbrot/Julia-type image in hardware, stores the result in a BRAM framebuffer, and displays it using a VGA interface.

The architecture is modular. The main blocks are responsible for pixel generation, Mandelbrot iteration, framebuffer storage, color conversion and video output. This modularity made it possible to compare different implementation strategies.

The use of fixed-point arithmetic allows efficient implementation on FPGA while maintaining sufficient precision for image generation. The framebuffer decouples image generation from video display. In this implementation, a 512 x 512 framebuffer is used and scaled to the 720 x 720 active display area, reducing memory usage while still displaying the image over the full screen.

The pipelined implementation provides a significant timing improvement. Compared to the baseline implementation, the validated operating frequency increased from 75 MHz to 125 MHz, corresponding to an improvement of approximately 66.7 percent. The estimated maximum frequency increased from about 78 MHz to about 140 MHz.

Overall, the project demonstrates how an iterative mathematical algorithm can be efficiently implemented in hardware, and how architectural choices such as pipelining, memory size and fixed-point precision directly influence performance, resource usage and image quality.
