# Makefile for GRS_PA01
# Roll No: MT25070

CC = gcc
CFLAGS = -Wall -O0
LDFLAGS = -lm -lpthread

PROGRAM_A = programA
PROGRAM_B = programB

SRC_A = MT25070_Part_A_Program_A.c MT25070_Part_B_Workers.c
SRC_B = MT25070_Part_A_Program_B.c MT25070_Part_B_Workers.c

all: $(PROGRAM_A) $(PROGRAM_B)

$(PROGRAM_A): $(SRC_A)
	$(CC) $(CFLAGS) -o $(PROGRAM_A) $(SRC_A) $(LDFLAGS)

$(PROGRAM_B): $(SRC_B)
	$(CC) $(CFLAGS) -o $(PROGRAM_B) $(SRC_B) $(LDFLAGS)

clean:
	rm -f $(PROGRAM_A) $(PROGRAM_B)
