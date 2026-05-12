import pandas as pd
import matplotlib.pyplot as plt
import re

# ----------- Load data -----------

filename = "memory_dij_report.txt"

rows = []
with open(filename, "r") as f:
    for line in f:
        line = line.strip()
        if not line or line.startswith("qHead"):
            continue
        
        parts = re.split(r"\s+", line)

        qHead = parts[0]
        mem_access = int(parts[1])
        mem_footprint = float(parts[2])

        rows.append([qHead, mem_access, mem_footprint])

df = pd.DataFrame(rows, columns=["qHead", "memory_accesses", "memory_footprint_KB"])

# ----------- Plot 1: Memory Accesses -----------

plt.figure(figsize=(8, 5))
plt.bar(df["qHead"], df["memory_accesses"])
plt.xticks(rotation=25, ha="right")
plt.ylabel("Memory accesses")
plt.title("Memory Access Comparison")
plt.tight_layout()
plt.savefig("qhead_memory_accesses.png", dpi=200)
plt.close()

# ----------- Plot 2: Memory Footprint (KB) -----------

plt.figure(figsize=(8, 5))
plt.bar(df["qHead"], df["memory_footprint_KB"])
plt.xticks(rotation=25, ha="right")
plt.ylabel("Memory footprint (KB)")
plt.title("Memory Footprint Comparison")
plt.tight_layout()
plt.savefig("qhead_memory_footprint.png", dpi=200)
plt.close()

print("Generated: qhead_memory_accesses.png and qhead_memory_footprint.png")
