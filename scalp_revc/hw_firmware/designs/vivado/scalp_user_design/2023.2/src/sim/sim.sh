#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
WORKDIR="$SCRIPT_DIR/work"
WAVEDIR="$SCRIPT_DIR/waves"
PPMDIR="$SCRIPT_DIR/ppm"
GHDL_FLAGS="--std=08"

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
analyse "$SCRIPT_DIR/../hdl/mandelbrot_engine.vhd"

# ── Testbenches ───────────────────────────────────────────────────────────────
analyse "$SCRIPT_DIR/tb_mandelbrot_iter.vhd"
simulate tb_mandelbrot_iter

analyse "$SCRIPT_DIR/tb_mandelbrot_engine.vhd"
simulate tb_mandelbrot_engine 10000ms # Generates output.ppm
mv output.ppm "$PPMDIR/output_$(date +%Y%m%d_%H%M%S).ppm"
