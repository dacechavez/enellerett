#include <sys/socket.h>
#include <sys/un.h>
#include <errno.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <getopt.h>
#include <unistd.h>

int ask_daemon(char*);
void usage(char*);

int main(int argc, char *argv[]) {
  int c;
  char* word = 0x0;

  while (1) {
    int option_index = 0;
    static struct option long_options[] = {
      {"word",    required_argument, 0,  'w' },
      {0,         0,                 0,  0 }
    };

    c = getopt_long(argc, argv, "w:",
                    long_options, &option_index);
    if (c == -1)
      break;

    switch (c) {
    case 'w':
      word = optarg;
      break;
    case '?':
      usage(argv[0]);
      break;
    default:
      usage(argv[0]);
    }
  }

  if (!word)
    usage(argv[0]);

  return ask_daemon(word);
}

int ask_daemon(char* word) {
  int sockfd, len, n;
  char answer[6]; // answer can be "error", "en" or "ett"
  char *socket_path = "/tmp/my.sock";
  struct sockaddr_un remote;

  if ((sockfd = socket(AF_UNIX, SOCK_STREAM, 0)) == -1) {
    perror("socket()");
    return -1;
  }

  remote.sun_family = AF_UNIX;
  strcpy(remote.sun_path, socket_path);
  len = strlen(remote.sun_path) + sizeof(remote.sun_family);
  if (connect(sockfd, (struct sockaddr *)&remote, len) == -1) {
    perror("connect()");
    fprintf(stderr, "Is bloomd running?\n");
    exit(1);
  }

  n = write(sockfd, word, strlen(word));

  if (n < 0) {
    perror("Error writing to socket");
    exit(1);
  }

  bzero(answer, 6);
  n = read(sockfd, answer, 5);
  close(sockfd);

  if (n < 0) {
    perror("Error reading from socket");
    exit(1);
  }

  printf("bloomd returned: [%s]\n", answer);

  // Return with return code 2, 3, 4, 5 (err, en, ett, en+ett respectively)
  if (0 == strcmp(answer, "en")) {
    return 3;
  } else if (0 == strcmp(answer, "ett")) {
    return 4;
  } else if (0 == strcmp(answer, "enett")) {
    return 5;
  }

  return 2;
}

void usage(char* progname) {
  fprintf(stderr, "Usage: %s -w word\n", progname);
  exit(1);
}
