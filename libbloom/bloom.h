#ifndef _BLOOM
#define _BLOOM

#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <stdint.h>
#include <assert.h>

typedef struct {
    // Number of hash functions
    uint32_t k;

    // Size of bit array
    uint32_t m;

    // Bits are stored inside integers: "blocks"
    uint32_t* blocks;

    // Number of uint32_t required to store bits
    size_t blen;

    // String representation of bits
    char* s;

} bloomfilter;

int bf_init(bloomfilter* bf, size_t sz);
void bf_cleanup(bloomfilter* bf);
const char* bf_str(bloomfilter* bf);
int bf_insert(bloomfilter* bf, const char* str);
int bf_contains(const bloomfilter* bf, const char* str);

uint32_t test_bit(const uint32_t* bits, uint32_t i);
void set_bit(uint32_t* bits, uint32_t i);
uint32_t murmurhash (const char *key, uint32_t len, uint32_t seed);


#endif
