OUTPUT_CSV="MT25070_Part_D_CSV.csv"
PROGRAM_A="./programA"
PROGRAM_B="./programB"

CPU_SET="0-2"          # pin to 2 CPUs
TOP_DELAY=0.5          
TOP_SAMPLES=20         

echo "Program,Worker,Count,Avg_CPU,Max_Mem_KB,Exec_Time_sec" > "$OUTPUT_CSV"

run_test() {
    PROGRAM=$1
    WORKER=$2
    COUNT=$3
    LABEL=$4

    echo "Running Program $LABEL | Worker $WORKER | Count $COUNT"

    START_TIME=$(date +%s.%N)

    # Run program
    taskset -c $CPU_SET $PROGRAM $COUNT $WORKER &
    PID=$!

    sleep 0.2   # allow processes/threads to spawn

    # Collect PIDs (parent + children)
    CHILD_PIDS=$(pgrep -P $PID | tr '\n' ',')
    PIDS="${PID},${CHILD_PIDS%,}"

    
    # Observe using top
    top -b -d $TOP_DELAY -n $TOP_SAMPLES -p $PIDS > top_$LABEL_$WORKER_$COUNT.txt

    wait $PID
    END_TIME=$(date +%s.%N)

    
    # Avg CPU %
    AVG_CPU=$(awk '
        /^[ ]*[0-9]/ { sum += $9; n++ }
        END { if (n>0) printf "%.2f", sum/n; else print 0 }
    ' top_$LABEL_$WORKER_$COUNT.txt)


    # Max RSS (KB)
    MAX_MEM=$(awk '
        /^[ ]*[0-9]/ { if ($6 > max) max = $6 }
        END { if (max>0) print max; else print 0 }
    ' top_$LABEL_$WORKER_$COUNT.txt)

    EXEC_TIME=$(awk "BEGIN {printf \"%.2f\", $END_TIME - $START_TIME}")

    echo "$LABEL,$WORKER,$COUNT,$AVG_CPU,$MAX_MEM,$EXEC_TIME" >> "$OUTPUT_CSV"

    rm -f top_$LABEL_$WORKER_$COUNT.txt
}


# Program A – Processes (2–5)
for W in cpu mem io; do
  for P in 2 3 4 5; do
    run_test "$PROGRAM_A" "$W" "$P" "A"
  done
done


# Program B – Threads (2–8)
for W in cpu mem io; do
  for T in 2 3 4 5 6 7 8; do
    run_test "$PROGRAM_B" "$W" "$T" "B"
  done
done


