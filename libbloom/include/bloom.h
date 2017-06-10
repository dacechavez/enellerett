#ifndef _BLOOM
#define _BLOOM

#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <stdint.h>

typedef struct {
    uint32_t* bit_array;

    // Using same variable names as
    // https://en.wikipedia.org/wiki/Bloom_filter
    int n, m, k;
} bloomfilter;

// the bloomc api
int bf_create(bloomfilter* bf, int n);
void bf_print(bloomfilter* bf);
void bf_insert(bloomfilter* bf, char* str);
int bf_contains(bloomfilter* bf, char* str);

// helper functions
int test_bit(uint32_t* bit_array, int k);
void set_bit(uint32_t* bit_array, int k);

#endif
