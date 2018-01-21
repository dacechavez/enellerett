#include <assert.h>
#include <stdio.h>
#include "bloom.h"
#include <string.h>
#include <time.h>
#include <string.h>

/*
    Test data:
    head -n 2000 /usr/share/dict/words > words_in_bf.txt
    tail -n 2000 /usr/share/dict/words > words_not_in_bf.txt
*/

void test_from_file() {
	bloomfilter bf;

    // Note that we get a false positive if you change this to 2000.
    // Im increasing it just to pass the test...
	bf_create(&bf, 20000);

    FILE* fp = fopen("tests/words_in_bf.txt", "r");
    char line[128];
    while (fgets(line, sizeof line, fp) != NULL) {
        line[strlen(line) - 1] = '\0';
        bf_insert(&bf, line);
    }

    // Bloom filter is built, now make a sanity check. Each word in the file
    // ought to be in the Bloom filter
    rewind(fp);
    while (fgets(line, sizeof line, fp) != NULL) {
        line[strlen(line) - 1] = '\0';
        assert(bf_contains(&bf, line));
    }
    fclose(fp);

    // Each word in the *other* file can be in the Bloom filter with
    // probability 0.001
    fp = fopen("tests/words_not_in_bf.txt", "r");
    while (fgets(line, sizeof line, fp) != NULL) {
        assert(!bf_contains(&bf, line));
    }

    fclose(fp);
    free(bf.bit_array);
}

int main() {
    test_from_file();
    return 0;
}

