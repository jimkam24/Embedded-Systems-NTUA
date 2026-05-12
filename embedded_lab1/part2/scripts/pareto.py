import pandas as pd
from paretoset import paretoset
import matplotlib.pyplot as plt

def to_kb(size_str):
    """Convert sizes like '2kB', '512kB', '1024kB' to integer KB."""
    size_str = size_str.strip().lower().replace('b', '')
    return int(size_str.replace('k', ''))

# Read the CSV
df = pd.read_csv("results/all_results.csv")

# Convert sizes to KB and compute total
df["L1I_KB"] = df["l1i cache size"].apply(to_kb)
df["L1D_KB"] = df["l1d cache size"].apply(to_kb)
df["L2_KB"]  = df["l2 cache size"].apply(to_kb)

# Compute total memory in KB
df["totalMemoryKB"] = df["L1I_KB"] + df["L1D_KB"] + df["L2_KB"]

# Rename cycles column for clarity
df["latencyCC"] = df["number of cycles"]

df.to_csv("results/all_results_gen.csv", index=False)

mask = paretoset(df[["totalMemoryKB", "latencyCC"]], sense=["min", "min"])
pareto_df = df[mask]




for uf, group in df.groupby("unrolling factor"):
    mask = paretoset(group[["totalMemoryKB", "latencyCC"]], sense=["min", "min"])
    pareto_df = group[mask]
    pareto_df.to_csv(f"results/pareto_frontier_uf{uf}.csv", index=False)
    
    # plt.figure(figsize=(10,6))

    # # Plot all points in light gray
    # plt.scatter(group["totalMemoryKB"], group["latencyCC"], color='lightgray', label="All points")

    # # Plot Pareto frontier points in red
    # plt.scatter(pareto_df["totalMemoryKB"], pareto_df["latencyCC"], color='red', s=80, label="Pareto frontier", edgecolor='k')

    # plt.xlabel("Total Memory (KB)")
    # plt.ylabel("Latency (cycles)")
    # plt.title(f"Pareto Frontier for Unrolling Factor {uf}")
    # plt.legend()
    # plt.grid(True)
    # plt.tight_layout()
    # plt.show()