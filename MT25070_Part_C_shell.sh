OUTPUT_CSV="MT25070_Part_C_CSV.csv"
PROGRAM_A="./programA"
PROGRAM_B="./programB"

CPU_SET="0-1"
TOP_SAMPLES=20     # 20 × 0.2s = 4 seconds
TOP_DELAY=0.2

echo "Program,Worker,Avg_CPU,Max_Mem_KB,Exec_Time_sec" > "$OUTPUT_CSV"

run_test() {
    PROGRAM=$1
    LABEL=$2
    WORKER=$3

    echo "Running $LABEL ($WORKER)"

    START_TIME=$(date +%s.%N)

    # Launch program
    taskset -c $CPU_SET $PROGRAM 2 $WORKER &
    PID=$!

    sleep 0.1   # allow fork/thread creation

    # Capture parent + child PIDs
    CHILD_PIDS=$(pgrep -P $PID | tr '\n' ',')
    PIDS="${PID},${CHILD_PIDS%,}"

    # Observe using top
    top -b -d $TOP_DELAY -n $TOP_SAMPLES -p $PIDS > top_$LABEL.txt

    wait $PID
    END_TIME=$(date +%s.%N)


    # Average CPU %
    AVG_CPU=$(awk '
        /^[ ]*[0-9]/ { sum += $9; n++ }
        END { if (n>0) printf "%.2f", sum/n; else print 0 }
    ' top_$LABEL.txt)


    # Max Memory (RSS in KB)
    MAX_MEM=$(awk '
        /^[ ]*[0-9]/ {
            if ($6 > max) max = $6
        }
        END {
            if (max > 0) print max;
            else print 0
        }
    ' top_$LABEL.txt)


    # Execution Time
    EXEC_TIME=$(awk "BEGIN {printf \"%.2f\", $END_TIME - $START_TIME}")

    echo "$LABEL,$WORKER,$AVG_CPU,$MAX_MEM,$EXEC_TIME" >> "$OUTPUT_CSV"

    rm -f top_$LABEL.txt
}


# Program A
run_test "$PROGRAM_A" "A_cpu" cpu
run_test "$PROGRAM_A" "A_mem" mem
run_test "$PROGRAM_A" "A_io"  io


# Program B
run_test "$PROGRAM_B" "B_cpu" cpu
run_test "$PROGRAM_B" "B_mem" mem
run_test "$PROGRAM_B" "B_io"  io


