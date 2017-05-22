#include <assert.h>
#include "bloom.h"

void test_n() {
	bloomfilter bf;
	// The bloomfilter array can allocate minimum of an int (4 bytes)
	// When this reaches 33 bits we need to allocate 8 bytes.
	int bits = 10;
	create_bloomfilter(&bf, bits);
	assert(bf.n == bits);
	free(bf.bit_array);
}

int main() {
	test_n();
	return 0;
}

