#ifndef MANDELBROT_H
#define MANDELBROT_H

#include <stddef.h>
#include <stdint.h>

int32_t float_to_fp(float f);
int mandelbrot_iter(int32_t *zr, int32_t *zi);
size_t mandelbrot_fixed(int32_t x, int32_t y);

#endif /*MANDELBROT_H*/
