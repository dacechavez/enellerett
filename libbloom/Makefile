CC = gcc
SRCS = src/bloom.c src/murmurhash.c
CFLAGS += -Wall -std=c99 -I./include
OBJS=$(SRCS:.c=.o)

all: clean shared

.c.o: $<
	$(CC) $(CFLAGS) -fPIC -c $< -o $@

shared: $(OBJS)
	$(CC) $(CFLAGS)  -shared -o libbloom.so $(OBJS) -lm

install: clean shared
	cp libbloom.so /usr/lib/libbloom.so
	cp include/bloom.h /usr/include/bloom.h

clean:
	rm -f src/*.o libbloom.so *.out

test: clean shared
	$(CC) $(CFLAGS) -L. -o test.out tests/test.c -lbloom
	LD_LIBRARY_PATH=. ./test.out

test_strings: clean shared
	$(CC) $(CFLAGS) -L. -o test_strings.out tests/test_strings.c -lbloom
	LD_LIBRARY_PATH=. ./test_strings.out


test_valgrind: clean shared
	$(CC) $(CFLAGS) -L. -o test_valgrind.out tests/test_valgrind.c -lbloom
	LD_LIBRARY_PATH=. valgrind --error-exitcode=1 \
	--leak-resolution=low --quiet \
	--leak-check=full --show-possibly-lost=no \
	./test_valgrind.out
