# enellerett

Get the gender of a Swedish noun. Try it out: https://enellerett.se

The components:

- libbloom: A bloom filter library
- bloomd: A daemon with a bloom filter in memory
- bloomcmd: A command line tool that speaks to bloomd
- bloomweb: A webserver that takes POST requests and asks bloomcmd for the noun's gender

