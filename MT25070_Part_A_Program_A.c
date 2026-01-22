// MT25070_Part_A_Program_A.c

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>

// Worker function declarations 
void cpu_worker();
void mem_worker();
void io_worker();

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <num_processes> <cpu|mem|io>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    int num_processes = atoi(argv[1]);
    char *worker_type = argv[2];

    if (num_processes < 1) {
        fprintf(stderr, "Number of processes must be >= 1\n");
        exit(EXIT_FAILURE);
    }

    for (int i = 0; i < num_processes; i++) {
        pid_t pid = fork();

        if (pid < 0) {
            perror("fork failed");
            exit(EXIT_FAILURE);
        }

        if (pid == 0) { // Child process
            if (strcmp(worker_type, "cpu") == 0) {
                cpu_worker();
            } else if (strcmp(worker_type, "mem") == 0) {
                mem_worker();
            } else if (strcmp(worker_type, "io") == 0) {
                io_worker();
            } else {
                fprintf(stderr, "Invalid worker type: %s\n", worker_type);
                exit(EXIT_FAILURE);
            }
            exit(EXIT_SUCCESS);
        }
    }

    // Parent waits for all children
    for (int i = 0; i < num_processes; i++) {
        wait(NULL);
    }

    return 0;
}
