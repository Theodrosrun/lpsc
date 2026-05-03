#include <stdio.h>
#include <stdlib.h>
#include "mandelbrot.h"

int main(int argc, char **argv)
{
	if (argc < 3) {
		printf("Usage %s <x> <y>\n", argv[0]);
		return EXIT_FAILURE;
	}
	float x = atof(argv[1]);
	float y = atof(argv[2]);

	size_t iter = mandelbrot_fixed(float_to_fp(x), float_to_fp(y));
	printf("<%f, %f>: %zu\n", x, y, iter);
	return EXIT_SUCCESS;
}
