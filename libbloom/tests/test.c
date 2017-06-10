#include <assert.h>
#include <stdio.h>
#include "bloom.h"
#include <string.h>
#include <time.h>

void test_n() {
    bloomfilter bf;
    bf_create(&bf, 10);
    assert(bf.n == 10);
    free(bf.bit_array);
}

void test_set_bits() {
    bloomfilter bf;

    bf_create(&bf, 4); // State: 0000

    set_bit(bf.bit_array, 0); // State: 1000
    assert(test_bit(bf.bit_array, 0));
    assert(!test_bit(bf.bit_array, 1));
    assert(!test_bit(bf.bit_array, 2));
    assert(!test_bit(bf.bit_array, 3));

    // Setting the same bit again should not change anything
    set_bit(bf.bit_array, 0); // State: 1000
    assert(test_bit(bf.bit_array, 0));
    assert(!test_bit(bf.bit_array, 1));
    assert(!test_bit(bf.bit_array, 2));
    assert(!test_bit(bf.bit_array, 3));

    // Set some other bit
    set_bit(bf.bit_array, 2); // State: 1010
    assert(test_bit(bf.bit_array, 0));
    assert(!test_bit(bf.bit_array, 1));
    assert(test_bit(bf.bit_array, 2));
    assert(!test_bit(bf.bit_array, 3));

    // XXX If some assert above fails we won't free anything
    // and get core-dumped
    free(bf.bit_array);
}

void test_bf_insert() {
    bloomfilter bf;

    bf_create(&bf, 4); // State: 0000
    int bits = test_bit(bf.bit_array, 0) +
               test_bit(bf.bit_array, 1) +
               test_bit(bf.bit_array, 2) +
               test_bit(bf.bit_array, 3);
    assert(bits == 0);
    bf_insert(&bf, "hej"); // set some bit
    assert(bits == 1);
}

void test_bf_contains() {
    bloomfilter bf;
    bf_create(&bf, 4);
    assert(!bf_contains(&bf, "foo"));
    bf_insert(&bf, "foo");
    assert(bf_contains(&bf, "foo"));
}


int main() {
    test_n();
    test_set_bits();
    return 0;
}

