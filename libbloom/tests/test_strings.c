#include <assert.h>
#include <stdio.h>
#include "bloom.h"
#include <string.h>
#include <time.h>

void test_strings() {
	bloomfilter bf;

	create_bloomfilter(&bf, 50);
	insert(&bf, "abc");
	insert(&bf, "foo");
	insert(&bf, "bar");
	insert(&bf, "baz");
	insert(&bf, "etc");
	insert(&bf, "a");
	insert(&bf, "b");
	insert(&bf, "c");
	insert(&bf, "d");
	insert(&bf, "e");
	insert(&bf, "f");
	insert(&bf, "g");

	assert(is_in(&bf, "abc"));
	assert(is_in(&bf, "foo"));
	assert(is_in(&bf, "bar"));
	assert(is_in(&bf, "baz"));
	assert(is_in(&bf, "etc"));
	assert(is_in(&bf, "a"));
	assert(is_in(&bf, "b"));
	assert(is_in(&bf, "c"));
	assert(is_in(&bf, "d"));
	assert(is_in(&bf, "e"));
	assert(is_in(&bf, "f"));
	assert(is_in(&bf, "g"));

	assert(!is_in(&bf, "0"));
	assert(!is_in(&bf, "1"));
	assert(!is_in(&bf, "2"));
	assert(!is_in(&bf, "3"));
	assert(!is_in(&bf, "4"));
	assert(!is_in(&bf, "5"));
	assert(!is_in(&bf, "6"));
	assert(!is_in(&bf, "7"));
	assert(!is_in(&bf, "8"));
	assert(!is_in(&bf, "9"));

	free(bf.bit_array);
}

int main() {
	test_strings();
	return 0;
}

