import matplotlib.pyplot as plt

# Data
unrolling_factors = [2, 4, 8, 16, 32]
cpu_cycles = [59815325, 59622462, 59465548, 59377532, 59241019]

# Create line plot
plt.figure(figsize=(8, 5))
plt.plot(unrolling_factors, cpu_cycles, marker='o', linestyle='-', linewidth=2)

# Labels and title
plt.title('Effect of Loop Unrolling on CPU Cycles', fontsize=14)
plt.xlabel('Unrolling Factor', fontsize=12)
plt.ylabel('CPU Cycles', fontsize=12)

# Grid and style
plt.grid(True, linestyle='--', alpha=0.7)
plt.xticks(unrolling_factors)
plt.tight_layout()

# Show plot
plt.show()
