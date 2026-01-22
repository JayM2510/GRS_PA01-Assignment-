import csv
import matplotlib.pyplot as plt


# Read CSV data
data = []
with open("MT25070_Part_D_CSV.csv", newline="") as f:
    reader = csv.DictReader(f)
    for row in reader:
        data.append({
            "Program": row["Program"],
            "Worker": row["Worker"],
            "Count": int(row["Count"]),
            "Avg_CPU": float(row["Avg_CPU"]),
            "Max_Mem_KB": float(row["Max_Mem_KB"]),
            "Exec_Time_sec": float(row["Exec_Time_sec"])
        })


# Global plotting style (BOXED)
plt.style.use("default")
plt.rcParams.update({
    "axes.spines.top": True,
    "axes.spines.right": True,
    "axes.spines.left": True,
    "axes.spines.bottom": True,
    "axes.linewidth": 1.2,
    "grid.color": "#b0b0b0",
    "grid.linestyle": "--",
    "grid.linewidth": 0.6,
})

MARKERS = {"A": "o", "B": "x"}
COLORS = {
    "A": "#7B2CBF",   # purple
    "B": "#0FA3B1"    # teal
}


# Plot helper
def plot_metric(worker, metric, ylabel, filename, title):
    fig, ax = plt.subplots(figsize=(9, 6))

    all_x = []
    all_y = []

    for program in ["A", "B"]:
        xs = [d["Count"] for d in data if d["Program"] == program and d["Worker"] == worker]
        ys = [d[metric] for d in data if d["Program"] == program and d["Worker"] == worker]

        all_x.extend(xs)
        all_y.extend(ys)

        ax.plot(
            xs, ys,
            marker=MARKERS[program],
            markersize=7,
            linewidth=2.2,
            color=COLORS[program],
            label=f"Program {program} ({'Processes' if program == 'A' else 'Threads'})"
        )

    
    # Axis handling (CENTERED DATA)
    ax.set_xlim(left=min(all_x))

    y_min = min(all_y)
    y_max = max(all_y)
    padding = (y_max - y_min) * 0.2
    ax.set_ylim(y_min - padding, y_max + padding)

    
    # Labels & styling
    ax.set_xlabel("Number of Processes / Threads", fontsize=12)
    ax.set_ylabel(ylabel, fontsize=12)
    ax.set_title(title, fontsize=14, fontweight="bold")
    ax.grid(True)

    # Legend outside
    ax.legend(loc="upper left", bbox_to_anchor=(1.02, 1))

    plt.tight_layout()
    plt.savefig(filename, dpi=200, bbox_inches="tight")
    plt.close()


# EXECUTION TIME
plot_metric("cpu", "Exec_Time_sec", "Execution Time (seconds)",
            "exec_time_cpu.png", "Execution Time Scaling (CPU Worker)")

plot_metric("mem", "Exec_Time_sec", "Execution Time (seconds)",
            "exec_time_mem.png", "Execution Time Scaling (Memory Worker)")

plot_metric("io", "Exec_Time_sec", "Execution Time (seconds)",
            "exec_time_io.png", "Execution Time Scaling (I/O Worker)")


# AVG CPU UTILIZATION
plot_metric("cpu", "Avg_CPU", "Average CPU Utilization (%)",
            "avg_cpu_cpu.png", "CPU Utilization Scaling (CPU Worker)")

plot_metric("mem", "Avg_CPU", "Average CPU Utilization (%)",
            "avg_cpu_mem.png", "CPU Utilization Scaling (Memory Worker)")

plot_metric("io", "Avg_CPU", "Average CPU Utilization (%)",
            "avg_cpu_io.png", "CPU Utilization Scaling (I/O Worker)")


# MAX MEMORY USAGE
plot_metric("cpu", "Max_Mem_KB", "Maximum Memory Usage (KB)",
            "max_mem_cpu.png", "Memory Usage Scaling (CPU Worker)")

plot_metric("mem", "Max_Mem_KB", "Maximum Memory Usage (KB)",
            "max_mem_mem.png", "Memory Usage Scaling (Memory Worker)")

plot_metric("io", "Max_Mem_KB", "Maximum Memory Usage (KB)",
            "max_mem_io.png", "Memory Usage Scaling (I/O Worker)")

