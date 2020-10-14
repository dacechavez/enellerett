CC = gcc
SRCS = bloom.c
CFLAGS += -Wall -Werror -std=c99
OBJS=$(SRCS:.c=.o)

all: clean shared

.c.o: $<
	$(CC) $(CFLAGS) -fPIC -c $< -o $@

shared: $(OBJS)
	$(CC) $(CFLAGS)  -shared -o libbloom.so $(OBJS) -lm

install: clean shared
	cp libbloom.so /usr/lib/libbloom.so
	cp bloom.h /usr/include/bloom.h

clean:
	rm -f *.o *.so *.out

test: clean shared
	$(CC) $(CFLAGS) -L. -o test.out tests/test.c -lbloom
	LD_LIBRARY_PATH=. ./test.out

valgrind: clean shared
	$(CC) $(CFLAGS) -L. -o test.out tests/test.c -lbloom
	LD_LIBRARY_PATH=. valgrind --error-exitcode=1 \
	--quiet --leak-check=full --show-possibly-lost=no \
	--track-origins=yes \
	./test.out

test_from_file: clean shared
	$(CC) $(CFLAGS) -L. -o test_from_file.out tests/test_from_file.c -lbloom
	LD_LIBRARY_PATH=. ./test_from_file.out

