#include <stdio.h>
#include "bloom.h"

int main(int argc, char const *argv[]) {
    bloomfilter bf;
    create_bloomfilter(&bf, 10);

    printf("number of bits =%d\n", bf.m);

    insert(&bf, "stol");
    printf("is %s in bf? %d\n", "stol", is_in(&bf, "stol"));
    printf("is %s in bf? %d\n", "abcd", is_in(&bf, "abcd"));
    printf("is %s in bf? %d\n", "bord", is_in(&bf, "bord"));
    printf("is %s in bf? %d\n", "hejsan", is_in(&bf, "hejsan"));
    free(bf.bit_array);
    return 0;
}
