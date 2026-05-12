# Embedded-Systems-NTUA
This repository contains the code from all lab exercises in the Embedded Systems course (2025–26). The projects involve concepts like:

### Lab 1 – Algorithm Optimization for Low Power & High Performance
- Profiling and transforming the PHODS motion estimation algorithm on a Renesas S7G2 board
- Design Space Exploration over block sizes and cache configurations using Gem5

### Lab 2 – Dynamic Data Type Refinement (DDTR)
- Optimizing dynamic data structures (SLL, DLL, Dynamic Array) for the Deficit Round Robin and Dijkstra algorithms
- Evaluation with Valgrind (Massif & Lackey) for memory footprint and memory accesses

### Lab 3 – High Level Synthesis: KNN Recommendation System
- Accelerating a K-Nearest Neighbors movie recommender on a Zynq-7000 FPGA (Zybo) using Xilinx SDSoC
- HLS directives (pipeline, unroll, array partition) and fixed-point `ap_fixed` datatypes

### Lab 4 – High Level Synthesis: GAN Image Reconstruction
- FPGA acceleration of a GAN forward-propagation network for MNIST digit reconstruction
- Design space exploration of HLS optimizations and fixed-point precision trade-offs
- Output quality evaluation via PSNR and max pixel error

### Lab 5 – ARM Assembly Programming
- Character transformation routines in ARM assembly
- Host↔guest communication over a virtual serial port (pseudoterminal / QEMU)
- Replacing standard C string functions (`strlen`, `strcpy`, `strcat`, `strcmp`) with hand-written ARM assembly

### Lab 6 – Cross-compilation for ARM
- Building a custom cross-compiler toolchain with crosstool-ng
- Cross-compiling with Linaro GCC
- Adding a custom system call to a cross-compiled Linux kernel running on QEMU
