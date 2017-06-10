#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <syslog.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <signal.h>
#include <sys/socket.h>
#include <sys/un.h>

#include <bloom.h>

#define SOCK_PATH "/tmp/my.sock"
#define BUFLEN 100
volatile sig_atomic_t sig_recv = 0;

int bloomd_listen(bloomfilter*, bloomfilter*);
void bloomd_signal(int);

int main(void) {
    pid_t pid;
    pid = fork();

    if (pid < 0) {
        perror("fork()");
        exit(EXIT_FAILURE);
    }

    if (pid > 0)
        exit(EXIT_SUCCESS);


    // Reset file permissions
    umask(0);

    // Open logs
    openlog("bloomd", LOG_PID, LOG_DAEMON);

    // Change to some directory that exists
    if ((chdir("/")) < 0) {
        syslog(LOG_ERR, "Failed to chdir(), errno: %s", strerror(errno));
        exit(EXIT_FAILURE);
    }

    // Close out the standard file descriptors
    close(STDIN_FILENO);
    close(STDOUT_FILENO);
    close(STDERR_FILENO);

    // Listen forever (or until we get a signal)
    signal(SIGQUIT, bloomd_signal);

    // Create two bloomfilters
    bloomfilter bf_en, bf_ett;
    bf_create(&bf_en, 200);
    bf_create(&bf_ett, 200);
    bf_insert(&bf_en, "flaska");
    bf_insert(&bf_ett, "bord");

    if ((bloomd_listen(&bf_en, &bf_ett)) == -1) {
        syslog(LOG_ERR, "bloomd_listen failed, exiting...");
        exit(EXIT_FAILURE);
    }

    syslog(LOG_NOTICE, "Caught SIGQUIT");
    syslog(LOG_NOTICE, "Exiting gracefully...");
    return 0;
}

void bloomd_signal(int sig) {
    sig_recv = sig;
}

int bloomd_listen(bloomfilter* bf_en, bloomfilter* bf_ett) {
    struct sockaddr_un local, remote;
    int fd;

    // Open unix socket
    if ((fd = socket(AF_UNIX, SOCK_STREAM, 0)) == -1) {
        syslog(LOG_ERR, "Failed to socket(), errno: %s", strerror(errno));
        return -1;
    }

    // Initialize our sockaddr
    local.sun_family = AF_UNIX;
    strncpy(local.sun_path, SOCK_PATH, sizeof(local.sun_path) - 1);
    local.sun_path[sizeof(local.sun_path) - 1] = '\0';
    unlink(local.sun_path);

    if (bind(fd, (struct sockaddr *) &local, sizeof(local)) == -1) {
        syslog(LOG_ERR, "Failed to bind(), errno: %s", strerror(errno));
        return -1;
    }

    if (listen(fd, 5) == -1) {
        syslog(LOG_ERR, "Failed to listen(), errno: %s", strerror(errno));
        return -1;
    }

    // New file descriptor for reading, don't confuse it with the fd above
    // which is still listening for other connections (i think thats the reason
    // for a new file descriptor)
    int sd;

    socklen_t socklen;
    char buf[BUFLEN];
    socklen = sizeof(remote);

    while (1) {
        if (sig_recv == SIGQUIT)
            return 0;

        syslog(LOG_NOTICE, "Waiting for a connection...");
        if ((sd = accept(fd, (struct sockaddr *) &remote, &socklen)) == -1) {
            syslog(LOG_ERR, "Failed to accept(), errno: %s", strerror(errno));
            return -1;
        }

        syslog(LOG_NOTICE, "Waiting for message from bloomcmd...");
        int rc = -1;

        // reset buf!
        memset(buf, 0, BUFLEN);

        rc = read(sd, buf, BUFLEN);
        syslog(LOG_NOTICE, "msg:[%s]\n", buf);

        if (rc < 0) {
            syslog(LOG_ERR, "Error reading from socket rc=%d, strerror=%s", rc, strerror(errno));
            return -1;
        }

        // ask libbloom
        if (bf_contains(bf_en, buf)) {
            rc = write(sd, "en", 5);
        } else if (bf_contains(bf_ett, buf)) {
            rc = write(sd, "ett", 5);
        } else {
            rc = write(sd, "error", 5);
        }

        if (rc < 0) {
            syslog(LOG_ERR, "Error writing to socket");
            return -1;
        }
    }
    return 0;
}
