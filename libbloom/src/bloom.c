#include "bloom.h"
#include "murmurhash.h"

// We use 4 hash functions (actually only murmurhash with 4 different seeds),
// this parameter can be tweaked
const int NUM_HASHES = 4;
uint32_t seeds[] = {1, 2, 3, 4};

int pos_ceil(int x, int y) {
    return (x / y) + (x % y != 0);
}

int calculate_m(int n, float p) {
    // assuming you are using an optimal k
    return ceil((n * log(p)) / log(1.0 / (pow(2.0, log(2.0)))));
}

int create_bloomfilter(bloomfilter* bf, int n) {
    bf->n = n;
    bf->k = NUM_HASHES;

    float fp_probability = 0.001;

    // array length in bits
    bf->m = calculate_m(n, fp_probability);
    // If we want 10 bits (m = 10) then one int is the minimum we can allocate
    int bytes_needed = pos_ceil(bf->m, (sizeof(int) * 8)) * sizeof(int);
    bf->bit_array = calloc(1, bytes_needed);

    // calloc success?
    if (NULL == bf->bit_array) {
        return -1;
    }

    return 0;
}

void insert(bloomfilter* bf, char* str) {
    for (int i = 0; i < NUM_HASHES; ++i) {
        uint32_t h = murmurhash(str, strlen(str), seeds[i]);
        set_bit(bf->bit_array, h % (bf->m));
    }
}

int is_in(bloomfilter* bf, char* str) {
    int hits = 0;
    for (int i = 0; i < NUM_HASHES; ++i) {
        uint32_t h = murmurhash(str, strlen(str), seeds[i]);
        hits += test_bit(bf->bit_array, h % (bf->m));
    }
    return hits == NUM_HASHES;
}

int test_bit(uint32_t* bit_array, int k) {
    return ( (bit_array[k / 32] & (1 << (k % 32) )) != 0 );
}

void set_bit(uint32_t* bit_array, int k) {
    bit_array[k / 32] |= (1 << k % 32);
}
