#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
WORKDIR="$SCRIPT_DIR/work"
WAVEDIR="$SCRIPT_DIR/waves"
PPMDIR="$SCRIPT_DIR/ppm"
GHDL_FLAGS="--std=08"

DATE=$(date +%Y%m%d_%H%M%S)

ENGINE_OUTPUT_FILE="$PPMDIR/output_engine_$DATE.ppm"
ENGINE_PIPELINED_OUTPUT_FILE="$PPMDIR/output_engine_pipeline_$DATE.ppm"
PICTURE_GEN_OUTPUT_FILE="$PPMDIR/output_engine_$DATE.ppm"
PICTURE_GEN_PIPELINED_OUTPUT_FILE="$PPMDIR/output_engine_pipeline_$DATE.ppm"

mkdir -p "$WORKDIR" "$WAVEDIR" "$PPMDIR"

analyse() {
    echo "Analysing $1..."
    ghdl -a $GHDL_FLAGS --workdir="$WORKDIR" "$1"
}

simulate() {
    local tb="$1"
    local stop_time="${2:-10us}"
    echo "── Running $tb ──"
    ghdl -e $GHDL_FLAGS --workdir="$WORKDIR" -o "$WORKDIR/$tb" "$tb"
    "$WORKDIR/$tb" --vcd="$WAVEDIR/$tb.vcd" --stop-time="$stop_time"
}

# ── Sources (order matters) ───────────────────────────────────────────────────
analyse "$SCRIPT_DIR/../hdl/mandelbrot_iter.vhd"
analyse "$SCRIPT_DIR/../hdl/mandelbrot_iter_combinatorial.vhd"
analyse "$SCRIPT_DIR/../hdl/mandelbrot_engine.vhd"
analyse "$SCRIPT_DIR/../hdl/mandelbrot_picture_gen.vhd"

analyse "$SCRIPT_DIR/../hdl/mandelbrot_iter_pipelined.vhd"
analyse "$SCRIPT_DIR/../hdl/mandelbrot_picture_gen_pipelined.vhd"

# ── Testbenches ───────────────────────────────────────────────────────────────
analyse "$SCRIPT_DIR/tb_mandelbrot_iter.vhd"
analyse "$SCRIPT_DIR/tb_mandelbrot_engine.vhd"
analyse "$SCRIPT_DIR/tb_mandelbrot_picture_gen.vhd"

analyse "$SCRIPT_DIR/tb_mandelbrot_iter_pipelined.vhd"
analyse "$SCRIPT_DIR/tb_mandelbrot_picture_gen_pipelined.vhd"

# ── Simulate ───────────────────────────────────────────────────────────────
# simulate tb_mandelbrot_iter
#simulate tb_mandelbrot_iter_pipelined
# simulate tb_mandelbrot_engine 10000ms
# mv output.ppm $ENGINE_OUTPUT_FILE

# simulate tb_mandelbrot_picture_gen 10000ms # Generates output.ppm
# mv output.ppm $PICTURE_GEN_OUTPUT_FILE

simulate tb_mandelbrot_picture_gen_pipelined 100ms # Generates output.ppm
mv output.ppm $PICTURE_GEN_PIPELINED_OUTPUT_FILE
echo "Moved to $PICTURE_GEN_PIPELINED_OUTPUT_FILE"
icat $PICTURE_GEN_PIPELINED_OUTPUT_FILE

# cmp $ENGINE_OUTPUT_FILE $PICTURE_GEN_OUTPUT_FILE
# cmp $PICTURE_GEN_PIPELINED_OUTPUT_FILE $PICTURE_GEN_OUTPUT_FILE
