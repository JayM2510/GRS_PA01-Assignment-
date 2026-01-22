// MT25070_Part_B_Workers.c

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <unistd.h>
#include <fcntl.h>

#define LOOP_COUNT 9000
#define MEM_SIZE   (16 * 1024 * 1024)   // 16 MB
#define IO_BUF_SIZE 4096


// CPU-intensive worker
void cpu_worker() {
    volatile double x = 0.0;

    // Repeat computation to create a long CPU burst
    for (int repeat = 0; repeat < 5; repeat++) {
        for (int i = 0; i < LOOP_COUNT; i++) {
            for (int j = 1; j < 1000; j++) {
                x += sqrt(j) * sin(j) * cos(j);
            }
        }
    }
}



// Memory-intensive worker
void mem_worker() {
    char *buffer = (char *)malloc(MEM_SIZE);
    if (!buffer) {
        perror("malloc failed");
        exit(EXIT_FAILURE);
    }

    for (int i = 0; i < LOOP_COUNT; i++) {
        for (size_t j = 0; j < MEM_SIZE; j += 64) {
            buffer[j]++;
        }
    }

    free(buffer);
}


// I/O-intensive worker
void io_worker() {
    int fd = open("io_temp_file.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    if (fd < 0) {
        perror("open failed");
        exit(EXIT_FAILURE);
    }

    char buffer[IO_BUF_SIZE];
    for (int i = 0; i < IO_BUF_SIZE; i++) {
        buffer[i] = 'A';
    }

    for (int i = 0; i < LOOP_COUNT; i++) {
        write(fd, buffer, IO_BUF_SIZE);  
    }
    fsync(fd); 
    close(fd);
}
