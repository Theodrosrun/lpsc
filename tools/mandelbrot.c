#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <stdio.h>

#define FRAC_BITS 15
#define SCALE	  (1 << FRAC_BITS)
#define MAX_ITER  100

#define CR	  float_to_fp(0.355)
#define CI	  float_to_fp(0.355)

// Helper to convert float to fixed for testing
int32_t float_to_fp(float f)
{
	return (int32_t)(f * SCALE);
}
int mandelbrot_iter(int32_t *zr, int32_t *zi)
{
	int64_t zr2_64 = ((int64_t)*zr * *zr);
	int64_t zi2_64 = ((int64_t)*zi * *zi);
	int64_t zrzi_64 = ((int64_t)*zr * *zi);

	// Check escape condition: (zr^2 + zi^2) >= 4
	// In fixed point: (zr^2 + zi^2) >= 4 * (2^15 * 2^15)
	if ((zr2_64 + zi2_64) >= ((int64_t)4 << (2 * FRAC_BITS))) {
		return 1;
	}

	// Shift back to 15 fractional bits (Truncating shift)
	int32_t zr2 = (int32_t)(zr2_64 >> FRAC_BITS);
	int32_t zi2 = (int32_t)(zi2_64 >> FRAC_BITS);
	int32_t zrzi2 = (int32_t)((2 * zrzi_64) >> FRAC_BITS);

	// Update z
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
