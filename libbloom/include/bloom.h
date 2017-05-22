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
void create_bloomfilter(bloomfilter* bf, int n);
void print_bloomfilter(bloomfilter* bf);
void insert(bloomfilter* bf, char* str);
int is_in(bloomfilter* bf, char* str);

// helper functions
int test_bit(uint32_t* bit_array, int k);
void set_bit(uint32_t* bit_array, int k);

#endif
