#include <assert.h>
#include <stdio.h>
#include "bloom.h"
#include <string.h>
#include <time.h>

int fail = 0;
int ok = 0;

void eq_int(const char* desc, uint32_t x, uint32_t y)
{
    if (x == y)
    {
        printf("OK   %s [%u == %u]\n", desc, x, y);
        ok++;
    }
    else
    {
        printf("FAIL %s [%u != %u]\n", desc, x, y);
        fail++;
    }

}

void neq_int(const char* desc, uint32_t x, uint32_t y)
{
    if (x != y)
    {
        printf("OK   %s [%u != %u]\n", desc, x, y);
        ok++;
    }
    else
    {
        printf("FAIL %s [%u == %u]\n", desc, x, y);
        fail++;
    }

}

void eq_str(const char* desc, const char* s1, const char* s2)
{
    if (strcmp(s1, s2) == 0)
    {
        printf("OK   %s [%s == %s]\n", desc, s1, s2);
        ok++;
    }
    else
    {
        printf("FAIL %s [%s != %s]\n", desc, s1, s2);
        fail++;
    }
}

void neq_str(const char* desc, const char* s1, const char* s2)
{
    if (strcmp(s1, s2) != 0)
    {
        printf("OK   %s [%s != %s]\n", desc, s1, s2);
        ok++;
    }
    else
    {
        printf("FAIL %s [%s == %s]\n", desc, s1, s2);
        fail++;
    }
}

void test_3bytes()
{
    bloomfilter bf;
    printf("START %s\n", __func__);

    // 4 bytes is the minimum...
    eq_int("bf_init", bf_init(&bf, 3), 1);
    bf_cleanup(&bf);
    printf("END %s\n\n", __func__);
}


void test_4bytes()
{
    bloomfilter bf;
    printf("START %s\n", __func__);

    // Only one uint32_t block i.e. 4 bytes
    eq_int("bf_init", bf_init(&bf, 4), 0);

    eq_int("hardcoded hashfuns", bf.k, 4);
    eq_int("num bits m", bf.m, 32);
    eq_int("num blocks blen", bf.blen, 1);
    eq_str("str", bf_str(&bf), "00000000000000000000000000000000");
    bf_cleanup(&bf);

    printf("END %s\n\n", __func__);
}

void test_5bytes()
{
    bloomfilter bf;
    printf("START %s\n", __func__);

    // Two uint32_t blocks
    eq_int("bf_init", bf_init(&bf, 5), 0);

    eq_int("hardcoded hashfuns", bf.k, 4);
    eq_int("num bits m", bf.m, 64);
    eq_int("num blocks blen", bf.blen, 2);
    eq_str("str", bf_str(&bf), "00000000000000000000000000000000"
                               "00000000000000000000000000000000");
    bf_cleanup(&bf);

    printf("END %s\n\n", __func__);
}

void test_6bytes()
{
    bloomfilter bf;
    printf("START %s\n", __func__);

    // Two uint32_t blocks
    eq_int("bf_init", bf_init(&bf, 6), 0);

    eq_int("hardcoded hashfuns", bf.k, 4);
    eq_int("num bits m", bf.m, 64);
    eq_int("num blocks blen", bf.blen, 2);
    eq_str("str", bf_str(&bf), "00000000000000000000000000000000"
                               "00000000000000000000000000000000");
    bf_cleanup(&bf);

    printf("END %s\n\n", __func__);
}


void test_9bytes()
{
    bloomfilter bf;
    printf("START %s\n", __func__);

    // Three uint32_t blocks
    eq_int("bf_init", bf_init(&bf, 9), 0);

    eq_int("hardcoded hashfuns", bf.k, 4);
    eq_int("num bits m", bf.m, 96);
    eq_int("num blocks blen", bf.blen, 3);
    eq_str("str", bf_str(&bf), "00000000000000000000000000000000"
                               "00000000000000000000000000000000"
                               "00000000000000000000000000000000");
    bf_cleanup(&bf);

    printf("END %s\n\n", __func__);
}

void test_test_bit()
{
    uint32_t zero = 0;
    uint32_t five = 5;
    uint32_t max = UINT32_MAX;
    uint32_t arr[3] = {0, 1, 2};

    // Test all bits inside zero
    for (int i = 0; i < 32; i++)
    {
        eq_int("test_bit", test_bit(&zero, i), 0);
    }

    // Only two bits in five will be set to 1
    for (int i = 0; i < 32; i++)
    {
        if (i == 0)
        {
            eq_int("test_bit", test_bit(&five, i), 1);
        }
        else if (i == 2)
        {
            eq_int("test_bit", test_bit(&five, i), 1);
        }
        else
        {
            eq_int("test_bit", test_bit(&five, i), 0);
        }
    }

    // All bits should be set here
    for (int i = 0; i < 32; i++)
    {
        eq_int("test_bit", test_bit(&max, i), 1);
    }

    // Three uint32_t here: 0, 1, 2
    // We test that these bits are set 00000000...00000001...00000010
    for (int i = 0; i < (32*3); i++)
    {
        if (i == 32)
        {
            eq_int("test_bit", test_bit(arr, i), 1);
        }
        else if (i == 65)
        {
            eq_int("test_bit", test_bit(arr, i), 1);
        }
        else
        {
            eq_int("test_bit", test_bit(arr, i), 0);
        }
    }
}

void test_set_bit()
{
    uint32_t zero = 0;

    set_bit(&zero, 0);
    set_bit(&zero, 2);

    // Test all bits inside zero except two of them
    for (int i = 0; i < 32; i++)
    {
        if (i == 0)
        {
            eq_int("test_bit", test_bit(&zero, i), 1);
        }
        else if (i == 2)
        {
            eq_int("test_bit", test_bit(&zero, i), 1);

            // This should just set the bit again, shouldnt matter
            set_bit(&zero, 2);
            eq_int("test_bit", test_bit(&zero, i), 1);
        }
        else
        {
            eq_int("test_bit", test_bit(&zero, i), 0);
        }
    }
}

void test_murmurhash()
{
    eq_int("murmurhash1", murmurhash("", 0, 4711), murmurhash("", 0, 4711));
    neq_int("murmurhash1", murmurhash("", 0, 4711), murmurhash("", 0, 4712));

    eq_int("murmurhash1", murmurhash("hej", 3, 4711), murmurhash("hej", 3, 4711));
    neq_int("murmurhash1", murmurhash("hej", 3, 4711), murmurhash("hej", 3, 4712));

}

void test_bf_insert()
{
    bloomfilter bf;
    printf("START %s\n", __func__);

    // Three uint32_t blocks
    eq_int("bf_init", bf_init(&bf, 9), 0);

    eq_int("bf_insert null", bf_insert(&bf, NULL), 1);
    eq_int("bf_insert empty str", bf_insert(&bf, ""), 1);
    eq_int("bf_insert hej", bf_insert(&bf, "hej"), 0);

    neq_str("bf_str should have ones", bf_str(&bf),
            "00000000000000000000000000000000"
            "00000000000000000000000000000000"
            "00000000000000000000000000000000");

    // Re-insert the same string
    const char* after = bf_str(&bf);
    eq_int("bf_insert hej again", bf_insert(&bf, "hej"), 0);
    eq_str("bf_str should remain the same", after, bf_str(&bf));

    bf_cleanup(&bf);

    printf("END %s\n\n", __func__);
}

void test_bf_contains()
{
    bloomfilter bf;
    printf("START %s\n", __func__);

    // Three uint32_t blocks
    eq_int("bf_init", bf_init(&bf, 9), 0);

    eq_int("bf_contains does not yet contain hej", bf_contains(&bf, "hej"), 0);
    eq_int("bf_insert hej", bf_insert(&bf, "hej"), 0);

    eq_int("bf_contains hej", bf_contains(&bf, "hej"), 1);
    eq_int("bf_contains empty str is error", bf_contains(&bf, ""), -1);
    eq_int("bf_contains NULL is error", bf_contains(&bf, NULL), -1);
    eq_int("bf_contains does not contain HEJ", bf_contains(&bf, "HEJ"), 0);
    eq_int("bf_contains does not contain a", bf_contains(&bf, "a"), 0);
    eq_int("bf_contains does not contain b", bf_contains(&bf, "b"), 0);
    eq_int("bf_contains does not contain c", bf_contains(&bf, "c"), 0);
    eq_int("bf_contains does not contain 1", bf_contains(&bf, "1"), 0);
    eq_int("bf_contains does not contain 2", bf_contains(&bf, "2"), 0);
    eq_int("bf_contains does not contain 3", bf_contains(&bf, "3"), 0);
    eq_int("bf_contains does not contain foo", bf_contains(&bf, "foo"), 0);

    bf_cleanup(&bf);

    printf("END %s\n\n", __func__);
}

int main()
{
    test_3bytes();
    test_4bytes();
    test_5bytes();
    test_6bytes();
    test_9bytes();
    test_test_bit();
    test_set_bit();
    test_murmurhash();
    test_bf_insert();
    test_bf_contains();

    printf("OK=%d FAIL=%d\n", ok, fail);
    return 0;
}

