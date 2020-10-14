#include "bloom.h"

const int NUM_HASHES = 4;        // We use 4 hash functions
uint32_t seeds[] = {1, 2, 3, 4}; // Actually murmurhash with 4 different seeds


int bf_init(bloomfilter* bf, size_t sz)
{
    if (bf == NULL)
        return 1;

    bf->blocks = NULL;
    bf->s = NULL;

    // We need to allocate at least one uint32_t
    if (sz < 4)
        return 1;

    // Hardcoded for now
    bf->k = NUM_HASHES;

    // Required number of uint32_t
    bf->blen = ceil((sz * 8) / 32.0);

    if (bf->blen < 1)
        return 1;

    // Number of bits (size of bloomfilter)
    bf->m = bf->blen * 32;

    bf->blocks = calloc(1, bf->blen * sizeof(uint32_t));
    if (bf->blocks == NULL)
        return 1;

    bf->s = calloc(1, bf->m + 1);
    if (bf->s == NULL)
    {
        free(bf->blocks);
        return 1;
    }

    return 0;
}

void bf_cleanup(bloomfilter* bf)
{
    if (bf == NULL)
        return;

    if (bf->blocks != NULL)
        free(bf->blocks);

    if (bf->s != NULL)
        free(bf->s);

    // dont free bf, caller's responsibility
    return;
}

int bf_insert(bloomfilter* bf, const char* str)
{
    uint32_t hidx;

    if (str == NULL)
        return 1;

    if (bf == NULL)
        return 1;

    if (strlen(str) == 0)
        return 1;

    for (int i = 0; i < bf->k; i++)
    {
        hidx = murmurhash(str, strlen(str), seeds[i]);
        set_bit(bf->blocks, hidx % bf->m);
    }
    return 0;
}

const char* bf_str(bloomfilter* bf)
{
    uint32_t i;

    if (bf == NULL)
        return NULL;

    for (i = 0; i < bf->m; i++)
    {
        if (test_bit(bf->blocks, i))
            bf->s[i] = '1';
        else
            bf->s[i] = '0';
    }
    bf->s[i] = '\0';
    return bf->s;
}

int bf_contains(const bloomfilter* bf, const char* str) {
    uint32_t hidx = 0;

    if (bf == NULL)
        return -1;

    if (str == NULL)
        return -1;

    if (strlen(str) == 0)
        return -1;

    for (int i = 0; i < bf->k; i++) {
        hidx = murmurhash(str, strlen(str), seeds[i]);
        if (test_bit(bf->blocks, hidx % bf->m) == 0)
        {
            return 0;
        }
    }
    return 1;
}

uint32_t test_bit(const uint32_t* blocks, uint32_t i)
{
    uint32_t block, mask;

    // Find the corresponding block
    block = blocks[i / 32];

    // Compute mask
    mask  = (1 << (i % 32));

    // Check the bit on block
    return (block & mask) ? 1 : 0;
}

void set_bit(uint32_t* blocks, uint32_t i)
{
    blocks[i / 32] |= (1 << i % 32);
}

/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2014 Joseph Werle
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
uint32_t murmurhash (const char *key, uint32_t len, uint32_t seed)
{
  uint32_t c1 = 0xcc9e2d51;
  uint32_t c2 = 0x1b873593;
  uint32_t r1 = 15;
  uint32_t r2 = 13;
  uint32_t m = 5;
  uint32_t n = 0xe6546b64;
  uint32_t h = 0;
  uint32_t k = 0;
  uint8_t *d = (uint8_t *) key; // 32 bit extract from `key'
  const uint32_t *chunks = NULL;
  const uint8_t *tail = NULL; // tail - last 8 bytes
  int i = 0;
  int l = len / 4; // chunk length

  h = seed;

  chunks = (const uint32_t *) (d + l * 4); // body
  tail = (const uint8_t *) (d + l * 4); // last 8 byte chunk of `key'

  // for each 4 byte chunk of `key'
  for (i = -l; i != 0; ++i) {
    // next 4 byte chunk of `key'
    k = chunks[i];

    // encode next 4 byte chunk of `key'
    k *= c1;
    k = (k << r1) | (k >> (32 - r1));
    k *= c2;

    // append to hash
    h ^= k;
    h = (h << r2) | (h >> (32 - r2));
    h = h * m + n;
  }

  k = 0;

  // remainder
  switch (len & 3) { // `len % 4'
    case 3: k ^= (tail[2] << 16);
    case 2: k ^= (tail[1] << 8);

    case 1:
      k ^= tail[0];
      k *= c1;
      k = (k << r1) | (k >> (32 - r1));
      k *= c2;
      h ^= k;
  }

  h ^= len;

  h ^= (h >> 16);
  h *= 0x85ebca6b;
  h ^= (h >> 13);
  h *= 0xc2b2ae35;
  h ^= (h >> 16);

  return h;
}

