#include "mandelbrot.h"
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#define WIDTH	  (800 / 4)
#define HEIGHT	  (600 / 4)
#define MAX_ITER  100

// Fixed-point config
#define FRAC_BITS 15
#define SCALE	  (1 << FRAC_BITS)

uint8_t magma_palette[MAX_ITER][3] = {
	{ 0, 0, 5 },	  { 0, 0, 10 },	    { 0, 0, 15 },     { 1, 0, 20 },	{ 2, 0, 25 },	  { 4, 0, 30 },
	{ 6, 0, 35 },	  { 8, 0, 40 },	    { 10, 0, 45 },    { 12, 0, 50 },	{ 15, 0, 55 },	  { 17, 0, 60 },
	{ 20, 0, 65 },	  { 23, 0, 70 },    { 26, 0, 75 },    { 29, 0, 80 },	{ 32, 1, 85 },	  { 36, 1, 90 },
	{ 39, 1, 95 },	  { 43, 1, 100 },   { 46, 2, 104 },   { 50, 2, 108 },	{ 54, 2, 112 },	  { 58, 2, 116 },
	{ 62, 2, 119 },	  { 66, 3, 123 },   { 70, 3, 126 },   { 75, 3, 129 },	{ 79, 4, 132 },	  { 84, 4, 134 },
	{ 88, 4, 137 },	  { 93, 5, 139 },   { 98, 5, 141 },   { 103, 6, 143 },	{ 107, 6, 145 },  { 112, 7, 146 },
	{ 117, 7, 148 },  { 122, 8, 149 },  { 127, 9, 150 },  { 132, 10, 151 }, { 137, 10, 151 }, { 142, 11, 152 },
	{ 147, 12, 152 }, { 152, 13, 153 }, { 157, 14, 153 }, { 162, 15, 153 }, { 167, 16, 153 }, { 172, 18, 152 },
	{ 176, 19, 152 }, { 181, 21, 151 }, { 186, 22, 151 }, { 190, 24, 150 }, { 195, 26, 149 }, { 199, 28, 148 },
	{ 203, 30, 147 }, { 208, 32, 145 }, { 212, 34, 143 }, { 216, 36, 141 }, { 220, 38, 139 }, { 224, 40, 137 },
	{ 228, 43, 135 }, { 232, 45, 132 }, { 235, 47, 130 }, { 239, 50, 127 }, { 242, 53, 124 }, { 245, 55, 121 },
	{ 248, 58, 118 }, { 251, 61, 114 }, { 253, 64, 111 }, { 255, 67, 107 }, { 255, 70, 104 }, { 255, 74, 100 },
	{ 255, 77, 96 },  { 255, 80, 93 },  { 255, 84, 89 },  { 255, 87, 85 },	{ 255, 91, 81 },  { 255, 94, 77 },
	{ 255, 98, 73 },  { 255, 101, 69 }, { 255, 105, 65 }, { 255, 109, 61 }, { 255, 112, 58 }, { 255, 116, 54 },
	{ 255, 120, 50 }, { 255, 123, 46 }, { 255, 127, 42 }, { 255, 131, 39 }, { 255, 135, 35 }, { 255, 139, 32 },
	{ 255, 142, 28 }, { 255, 146, 25 }, { 255, 150, 22 }, { 255, 154, 19 }, { 255, 158, 17 }, { 255, 162, 14 },
	{ 255, 165, 12 }, { 255, 169, 10 }, { 255, 173, 8 },  { 255, 177, 6 }
};

// Map iteration count to a simple RGB color
void get_color(int iter, uint8_t *r, uint8_t *g, uint8_t *b)
{
	if (iter == MAX_ITER) {
		*r = *g = *b = 0; // Black for points inside the set
		return;
	}
	// Access Color RAM at address 'iter'
	*r = magma_palette[iter][0];
	*g = magma_palette[iter][1];
	*b = magma_palette[iter][2];
}

int main(void)
{
	// Define the complex plane window
	double x_min = -2.0, x_max = 1.0;
	double y_min = -1.2, y_max = 1.2;

	FILE *fp = fopen("mandelbrot.ppm", "w+");
	fprintf(fp, "P3\n%d %d\n255\n", WIDTH, HEIGHT);
	int32_t curr_y = double_to_fp(y_min);
	int32_t dx = (int32_t)round((x_max - x_min) / WIDTH * SCALE);
	int32_t dy = (int32_t)round((y_max - y_min) / HEIGHT * SCALE);
	int32_t x0 = (int32_t)round(x_min * SCALE);
	int32_t y0 = (int32_t)round(y_min * SCALE);

	for (int y = 0; y < HEIGHT; y++) {
		int32_t curr_x = double_to_fp(x_min);
		for (int x = 0; x < WIDTH; x++) {
			size_t iter = mandelbrot_fixed(curr_x, curr_y);
			uint8_t r, g, b;
			get_color(iter, &r, &g, &b);
			fprintf(fp, "%d %d %d\n", r, g, b);
			curr_x += dx;
		}
		curr_y += dy;
	}
	fclose(fp);
	printf("Done! Open mandelbrot.ppm to see the result.\n");
	return 0;
}
