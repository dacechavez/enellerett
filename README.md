# enellerett

Get the gender of a Swedish noun in the browser.

The components:

- libbloom: A bloom filter as a C library
- bloomd: A daemon in C that has a bloom filter in memory
- bloomcmd: A simple command line tool that speaks to bloomd
- bloomweb: A simple webserver that takes POST requests and asks bloomcmd for the noun's gender

The biggest reason for this daemon is that the bloom filter is static. It is created once and nothing else is added to it. Instead of rebuilding it all the time or reading from disk, bloomd will keep it in memory.

