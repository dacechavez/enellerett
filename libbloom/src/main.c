#include <stdio.h>
#include "bloom.h"

int main(int argc, char const *argv[]) {
    bloomfilter bf;
    bf_create(&bf, 10);

    printf("number of bits =%d\n", bf.m);

    bf_insert(&bf, "stol");
    printf("is %s in bf? %d\n", "stol", bf_contains(&bf, "stol"));
    printf("is %s in bf? %d\n", "abcd", bf_contains(&bf, "abcd"));
    printf("is %s in bf? %d\n", "bord", bf_contains(&bf, "bord"));
    printf("is %s in bf? %d\n", "hejsan", bf_contains(&bf, "hejsan"));
    free(bf.bit_array);
    return 0;
}
