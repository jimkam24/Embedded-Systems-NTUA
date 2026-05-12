# Embedded-Systems-NTUA
This repository contains the code from all lab exercises in the Embedded Systems course (2025–26). The projects involve concepts like:

* **Algorithm optimization for low power & high performance** (Lab 1) — profiling and transforming the PHODS motion estimation algorithm on a Renesas S7G2 board; Design Space Exploration over block sizes and cache configurations using Gem5
* **Dynamic Data Type Refinement – DDTR** (Lab 2) — optimizing dynamic data structures (SLL, DLL, Dynamic Array) for the Deficit Round Robin and Dijkstra algorithms, evaluated with Valgrind (Massif & Lackey) for memory footprint and memory accesses
* **High Level Synthesis (HLS) – KNN Recommendation System** (Lab 3) — accelerating a K-Nearest Neighbors movie recommender on a Zynq-7000 FPGA (Zybo) using Xilinx SDSoC, with HLS directives (pipeline, unroll, array partition) and fixed-point `ap_fixed` datatypes
* **High Level Synthesis (HLS) – GAN Image Reconstruction** (Lab 4) — FPGA acceleration of a GAN forward-propagation network for MNIST digit reconstruction; design space exploration of HLS optimizations and fixed-point precision trade-offs (4 / 8 / 10 bits), evaluated by PSNR and max pixel error
* **ARM Assembly Programming** (Lab 5) — three exercises: character transformation routines in ARM assembly, host↔guest communication over a virtual serial port (pseudoterminal / QEMU), and replacing standard C string functions (`strlen`, `strcpy`, `strcat`, `strcmp`) with hand-written ARM assembly
* **Cross-compilation for ARM** (Lab 6) — building a custom cross-compiler toolchain with crosstool-ng (arm-cortexa9_neon-linux-gnueabihf), cross-compiling with Linaro GCC, and adding a custom system call to a cross-compiled Linux kernel running on QEMU
