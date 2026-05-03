#include <math.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <stdio.h>

#define DATA_W	 15
#define FRAC_W	 15
#define SCALE	 (1 << FRAC_W)
#define MAX_ITER 100

#define CR	 (double_to_fp(0.355))
#define CI	 (double_to_fp(0.355))

int32_t double_to_fp(double f)
{
	return (int32_t)round(f * SCALE);
}

int mandelbrot_iter(int32_t *zr, int32_t *zi)
{
	int64_t zr2_64 = (int64_t)*zr * *zr;
	int64_t zi2_64 = (int64_t)*zi * *zi;
	int64_t zrzi_64 = (int64_t)*zr * *zi;

	// Divergence check using full precision (matches VHDL sum_sq_full >> FRAC_W)
	if (((zr2_64 + zi2_64) >> FRAC_W) >= ((int64_t)4 << FRAC_W)) {
		return 1;
	}

	int32_t zr2 = (int32_t)(zr2_64 >> FRAC_W);
	int32_t zi2 = (int32_t)(zi2_64 >> FRAC_W);
	int32_t zrzi = (int32_t)(zrzi_64 >> FRAC_W);
	int32_t zrzi2 = zrzi * 2;

	*zr = zr2 - zi2 + CR;
	*zi = zrzi2 + CI;
	return 0;
}

size_t mandelbrot_fixed(int32_t x, int32_t y)
{
	int32_t zr = x;
	int32_t zi = y;

	for (size_t iter = 0; iter < MAX_ITER; iter++) {
		if (mandelbrot_iter(&zr, &zi)) {
			return iter;
		}
	}
	return 0;
}
