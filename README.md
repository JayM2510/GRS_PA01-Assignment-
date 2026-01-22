# 🧵 GRS PA01 – Processes and Threads  
**Course:** Graduate Systems (CSE638)  
**Assignment:** PA01 – Processes and Threads  
**Roll Number:** MT25070  

---

## 📌 Assignment Objective

The goal of this assignment is to **experimentally study and compare processes and threads** under different types of workloads and to observe how system resources behave as concurrency increases.

Specifically, the assignment focuses on:
- Understanding **process vs thread creation**
- Observing **CPU, memory, and I/O behavior**
- Studying **scalability trends** using system monitoring tools

---

## 🧩 Assignment Breakdown

The assignment consists of **four major parts**:

| Part | Description |
|----|----|
| **Part A** | Process-based and thread-based program implementation |
| **Part B** | CPU, Memory, and I/O intensive worker functions |
| **Part C** | Automated measurement and data collection |
| **Part D** | Scaling experiments and visualization |

---

## 📂 Folder Structure

~~~text
MT25070_PA01/
├── MT25070_Part_A_Program_A.c # Process-based implementation
├── MT25070_Part_A_Program_B.c # Thread-based implementation
├── MT25070_Part_B_Workers.c # CPU / MEM / IO worker functions
├── MT25070_Part_C_shell.sh # Automation script (Part C)
├── MT25070_Part_C_CSV.csv # Raw measurements (Part C)
├── MT25070_Part_D_shell.sh # Scaling automation (Part D)
├── MT25070_Part_D_CSV.csv # Raw measurements (Part D)
├── MT25070_Part_D_plot.py # Plotting script (matplotlib)
├── Makefile # Build automation
├── README.md # This file
└── MT25070_Report.pdf # Final report (submitted separately)

~~~


---

## ⚙️ Part A – Program Implementation

### Program A: Process-Based Implementation
- Uses the `fork()` system call
- Creates **N child processes** (parent excluded, as per instructions)
- Each child executes one worker function
- Parent process waits using `wait()`

### Program B: Thread-Based Implementation
- Uses POSIX threads (`pthread`)
- Creates **N worker threads** (main thread excluded)
- Threads share the same address space
- Synchronization achieved using `pthread_join()`

The number of processes/threads is passed as a **command-line argument**.

---

## 🧠 Part B – Worker Functions

Each worker function represents a different system bottleneck.

### CPU-Intensive Worker (`cpu`)
- Performs long-running arithmetic computations
- Designed to keep the CPU busy with minimal I/O or memory stalls
- Represents **pure CPU burst behavior**

### Memory-Intensive Worker (`mem`)
- Allocates a large memory region
- Repeatedly accesses memory with cache-unfriendly patterns
- Stresses **RAM and cache hierarchy**

### I/O-Intensive Worker (`io`)
- Performs repeated disk write operations
- Forces synchronous I/O
- CPU frequently waits for I/O completion

Each worker runs for: (loop_count = last_digit_of_roll × 10³)


---

## 📊 Part C – Measurement & Automation

### Objective
To measure and compare **resource usage** for:
- A + cpu, A + mem, A + io
- B + cpu, B + mem, B + io

---

### Tools Used
- `top` → CPU and memory observation
- `taskset` → Pin program execution to specific CPU cores
- `time` → Execution time measurement
- `bash` → Automation and data collection

> Important:  
> `top` is used only for **observation**, not to run the program.

---

### Automation Script (`MT25070_Part_C_shell.sh`)

The script:
1. Runs each program-worker combination
2. Pins execution to a fixed CPU set
3. Samples `top` output periodically
4. Computes:
   - Average CPU utilization
   - Maximum memory usage (RSS)
   - Total execution time
5. Stores results in a CSV file

---

#### Output (Part C): MT25070_Part_C_CSV.csv

This CSV serves as **raw experimental data**.

---

## 📈 Part D – Scaling Experiments

### Objective
To study **scalability trends** by increasing concurrency:

- Program A: 2 → 5 processes
- Program B: 2 → 8 threads

Each experiment is repeated for:
- CPU worker
- Memory worker
- I/O worker

---

### Automation Script (`MT25070_Part_D_shell.sh`)

The script:
1. Iterates over increasing process/thread counts
2. Runs worker functions under controlled CPU pinning
3. Collects the same metrics as Part C
4. Stores all results in a single CSV file

---

#### Output (Part D): MT25070_Part_D_CSV.csv

---

## ▶️ How to Build

### Compile all programs
make

### Clean build files 
make clean

---
## ▶️ How to Run

### Part C – Fixed number of processes/threads
MT25070_Part_C_shell.sh

This generates: MT25070_Part_C_CSV.csv

### Part D – Scaling experiment
MT25070_Part_D_shell.sh

This generates: MT25070_Part_D_CSV.csv

---
### 📈 Plotting the Results
python3 MT25070_Part_D_plot.py

#### Output Graphs (9 total)
Execution Time vs Count (CPU / MEM / IO)

Avg CPU % vs Count (CPU / MEM / IO)

Max Memory vs Count (CPU / MEM / IO)
