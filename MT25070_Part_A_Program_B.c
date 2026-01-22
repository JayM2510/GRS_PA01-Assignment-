// MT25070_Part_A_Program_B.c

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>

// Worker function declarations 
void cpu_worker();
void mem_worker();
void io_worker();

typedef struct {
    char worker_type[8];
} thread_arg_t;

void* thread_runner(void *arg) {
    thread_arg_t *targ = (thread_arg_t *)arg;

    if (strcmp(targ->worker_type, "cpu") == 0) {
        cpu_worker();
    } else if (strcmp(targ->worker_type, "mem") == 0) {
        mem_worker();
    } else if (strcmp(targ->worker_type, "io") == 0) {
        io_worker();
    } else {
        fprintf(stderr, "Invalid worker type\n");
    }

    return NULL;
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <num_threads> <cpu|mem|io>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    int num_threads = atoi(argv[1]);
    char *worker_type = argv[2];

    if (num_threads < 1) {
        fprintf(stderr, "Number of threads must be >= 1\n");
        exit(EXIT_FAILURE);
    }

    pthread_t threads[num_threads];
    thread_arg_t args;

    strncpy(args.worker_type, worker_type, sizeof(args.worker_type) - 1);
    args.worker_type[sizeof(args.worker_type) - 1] = '\0';

    for (int i = 0; i < num_threads; i++) {
        if (pthread_create(&threads[i], NULL, thread_runner, &args) != 0) {
            perror("pthread_create failed");
            exit(EXIT_FAILURE);
        }
    }

    // Main thread waits; does no work itself
    for (int i = 0; i < num_threads; i++) {
        pthread_join(threads[i], NULL);
    }

    return 0;
}
