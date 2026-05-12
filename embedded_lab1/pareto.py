import pandas as pd
from paretoset import paretoset
import matplotlib.pyplot as plt

def to_kb(size_str):
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

# Rename cycles column
df["latencyCC"] = df["number of cycles"]

df.to_csv("results/all_results_gen.csv", index=False)

mask = paretoset(df[["totalMemoryKB", "latencyCC"]], sense=["min", "min"])
pareto_df = df[mask]

    
plt.figure(figsize=(10,6))

# Plot all points in light gray
plt.scatter(df["totalMemoryKB"], df["latencyCC"], color="gray", alpha=0.5, label="All Designs")

# Plot Pareto frontier points in red
plt.scatter(pareto_df["totalMemoryKB"], pareto_df["latencyCC"], color='red', s=80, label="Pareto frontier", edgecolor='k')

plt.xlabel("Total Memory (KB)")
plt.ylabel("Latency (cycles)")
plt.title(f"Pareto Frontier")
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.show()
