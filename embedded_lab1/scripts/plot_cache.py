import matplotlib.pyplot as plt

# Data
l1d_sizes = [2, 4, 8, 16, 32, 64]  # in kB
cpu_cycles = [60022867, 59925409, 59829295, 43002223, 42771449, 42922847]

# Create line plot
plt.figure(figsize=(8, 5))
plt.plot(l1d_sizes, cpu_cycles, marker='o', linestyle='-', linewidth=2)

# Labels and title
plt.title('Effect of L1D Cache Size on CPU Cycles', fontsize=14)
plt.xlabel('L1D Cache Size (kB)', fontsize=12)
plt.ylabel('CPU Cycles', fontsize=12)

# Grid and formatting
plt.grid(True, linestyle='--', alpha=0.7)
plt.xticks(l1d_sizes)
plt.tight_layout()

# Show plot
plt.show()
