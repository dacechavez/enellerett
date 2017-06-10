#include <assert.h>
#include <stdio.h>
#include "bloom.h"
#include <string.h>
#include <time.h>

void test_strings() {
	bloomfilter bf;

	bf_create(&bf, 50);
	bf_insert(&bf, "abc");
	bf_insert(&bf, "foo");
	bf_insert(&bf, "bar");
	bf_insert(&bf, "baz");
	bf_insert(&bf, "etc");
	bf_insert(&bf, "a");
	bf_insert(&bf, "b");
	bf_insert(&bf, "c");
	bf_insert(&bf, "d");
	bf_insert(&bf, "e");
	bf_insert(&bf, "f");
	bf_insert(&bf, "g");

	assert(bf_contains(&bf, "abc"));
	assert(bf_contains(&bf, "foo"));
	assert(bf_contains(&bf, "bar"));
	assert(bf_contains(&bf, "baz"));
	assert(bf_contains(&bf, "etc"));
	assert(bf_contains(&bf, "a"));
	assert(bf_contains(&bf, "b"));
	assert(bf_contains(&bf, "c"));
	assert(bf_contains(&bf, "d"));
	assert(bf_contains(&bf, "e"));
	assert(bf_contains(&bf, "f"));
	assert(bf_contains(&bf, "g"));

	assert(!bf_contains(&bf, "0"));
	assert(!bf_contains(&bf, "1"));
	assert(!bf_contains(&bf, "2"));
	assert(!bf_contains(&bf, "3"));
	assert(!bf_contains(&bf, "4"));
	assert(!bf_contains(&bf, "5"));
	assert(!bf_contains(&bf, "6"));
	assert(!bf_contains(&bf, "7"));
	assert(!bf_contains(&bf, "8"));
	assert(!bf_contains(&bf, "9"));

	free(bf.bit_array);
}

int main() {
	test_strings();
	return 0;
}

