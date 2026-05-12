output_file="l1d_results.txt"
> "$output_file"

# List of L1 data cache sizes to test
for size in 2kB 4kB 8kB 16kB 32kB 64kB; do
    echo "Running simulation with L1D size = $size"
    
    # Run gem5 with current L1D size
    build/X86/gem5.opt configs/learning_gem5/part1/two_level.py /gem5/tables_UF/tables.exe --l1i_size=8kB --l1d_size=$size --l2_size=128kB
    
    # Extract the numCycles line
    result_line=$(grep "system.cpu.numCycles" m5out/stats.txt)
    
    # Write results to file
    {
        echo "L1D size = $size"
        echo "$result_line"
        echo ""
    } >> "$output_file"
done

echo "All results saved in $output_file"
