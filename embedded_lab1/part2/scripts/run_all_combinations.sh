#!/bin/bash

# Output CSV file
output_file="all_results.csv"
echo "l1d cache size,l1i cache size,l2 cache size,unrolling factor,number of cycles" > "$output_file"

# Parameter lists
l1_sizes=("2kB" "4kB" "8kB" "16kB" "32kB" "64kB")
l2_sizes=("128kB" "256kB" "512kB" "1024kB")
unroll_factors=(2 4 8 16 32)

# Loop over all combinations
for l1i in "${l1_sizes[@]}"; do
  for l1d in "${l1_sizes[@]}"; do
    for l2 in "${l2_sizes[@]}"; do
      for uf in "${unroll_factors[@]}"; do
        
        echo "Running: UF=$uf, L1I=$l1i, L1D=$l1d, L2=$l2"
        
        # Run gem5
        build/X86/gem5.opt configs/learning_gem5/part1/two_level.py /gem5/tables_UF/tables_uf${uf}.exe \
          --l1i_size=$l1i --l1d_size=$l1d --l2_size=$l2
        
        # Extract just the numeric value of numCycles
        num_cycles=$(grep "system.cpu.numCycles" m5out/stats.txt | awk '{print $2}')
        
        # Append results to CSV
        echo "$l1d,$l1i,$l2,$uf,$num_cycles" >> "$output_file"
        
      done
    done
  done
done

echo "✅ All results saved in $output_file"
