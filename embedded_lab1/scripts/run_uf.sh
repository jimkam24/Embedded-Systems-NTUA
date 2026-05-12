#!/bin/bash

output_file="unrolling_results.txt"
> "$output_file"

for uf in 2 4 8 16 32; do
    echo "Running simulation with unrolling factor = $uf"
    build/X86/gem5.opt configs/learning_gem5/part1/two_level.py /gem5/tables_UF/tables_uf${uf}.exe --l1i_size=8kB --l1d_size=8kB --l2_size=128kB

    result_line=$(grep "system.cpu.numCycles" m5out/stats.txt)

    {
        echo "unrolling factor = $uf"
        echo "$result_line"
        echo ""
    } >> "$output_file"
done

