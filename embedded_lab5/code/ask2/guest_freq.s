        .text
        .global _start

.equ SYS_READ,   3
.equ SYS_WRITE,  4
.equ SYS_OPEN,   5
.equ SYS_EXIT,   1
.equ SYS_IOCTL,  54
.equ O_RDWR,     2

.equ TCGETS, 0x5401
.equ TCSETS, 0x5402

.equ ICANON, 0x00000002
.equ ECHO,   0x00000008
.equ ISIG,   0x00000001
.equ ICRNL,  0x00000100
.equ INLCR,  0x00000040
.equ OPOST,  0x00000001


_start:
        /* Open /dev/ttyAMA0  - open("/dev/ttyAMA0", O_RDWR)*/
        ldr r0, =devpath
        mov r1, #O_RDWR
        mov r7, #SYS_OPEN
        swi #0
        mov r4, r0          @ fd /dev/ttyAMA0

        /* termios configuretion */
        mov r0, r4
        ldr r1, =TCGETS
        ldr r2, =options
        mov r7, #SYS_IOCTL
        swi #0

        ldr r0, =options

        @ c_iflag (offset 0)
        ldr r1, [r0, #0]
        bic r1, r1, #(ICRNL | INLCR)
        str r1, [r0, #0]

        @ c_oflag (offset 4)
        ldr r1, [r0, #4]
        bic r1, r1, #OPOST
        str r1, [r0, #4]

        @ c_lflag (offset 12)
        ldr r1, [r0, #12]
        bic r1, r1, #(ICANON | ECHO | ISIG)
        str r1, [r0, #12]

        mov r0, r4
        ldr r1, =TCSETS
        ldr r2, =options
        mov r7, #SYS_IOCTL
        swi #0




        /* FLUSH OLD DATA IN SERIAL INPUT QUEUE - ioctl(fd, TCFLSH, TCIFLUSH)*/
        mov r0, r4          @ fd = /dev/ttyAMA0
        ldr r1, =0x540B     @ TCFLSH ioctl
        mov r2, #0          @ TCIFLUSH = flush input queue
        mov r7, #SYS_IOCTL
        swi #0

        /* ============= MAIN LOOP ============= */
main_loop:

        /* READ LOOP (read until newline or 64 bytes) */
        ldr r6, =buffer     @ ptr
        mov r5, #0          @ count

read_loop:
	/* read one character every time */
        mov r0, r4          @ fd
        mov r1, r6          @ current buffer position
        mov r2, #1
        mov r7, #SYS_READ
        swi #0

        cmp r0, #1
        bne read_done       @ EOF/
        ldrb r3, [r6]

        cmp r3, #'\n'
        beq read_done       @ stop at new line

        add r6, r6, #1      @move to next cha
        add r5, r5, #1
        cmp r5, #64
        blt read_loop

read_done:
        /* Zero freqs[256] */
        ldr r1, =freqs
        mov r2, #256
	
	/* fill matrix with 0*/
zero_loop:
        mov r3, #0
        strb r3, [r1], #1
        subs r2, r2, #1
        bne zero_loop

        /* Count frequencies for r5 bytes of buffer */
        ldr r1, =buffer
        mov r2, #0

count_loop:
        cmp r2, r5
        beq find_max

        ldrb r3, [r1, r2]

        cmp r3, #32         @ space
        beq skip_char
        cmp r3, #10         @ '\n'
        beq skip_char
        cmp r3, #13         @ '\r'
        beq skip_char

        ldr r0, =freqs
        ldrb r6, [r0, r3]
        add r6, r6, #1
        strb r6, [r0, r3]

skip_char:
        add r2, r2, #1
        b count_loop

find_max:
        mov r8, #0      @ best char
        mov r9, #0      @ best count

        mov r11, #1
        ldr r10, =freqs

find_loop:
        cmp r11, #255
        bgt build_output

        ldrb r12, [r10, r11]

        cmp r12, r9
        blt next_max
        beq tie

        mov r9, r12
        mov r8, r11
        b next_max
        

tie:
	/* keep the one with smallest ASCII code*/
        cmp r11, r8
        bge next_max
        mov r9, r12
        mov r8, r11

next_max:
        add r11, r11, #1
        b find_loop

/* ASCII conversion: */


build_output:
        ldr r0, =outbuf
        strb r8, [r0]         @ char
        mov r1, #' '
        strb r1, [r0,#1]

        cmp r9, #10
        blt one_digit

two_digit:
        mov r1, r9
        mov r2, #0

ten_loop:
        cmp r1, #10
        blt tens_done
        sub r1, r1, #10
        add r2, r2, #1
        b ten_loop

tens_done:
        add r3, r2, #'0'
        strb r3, [r0,#2]

        add r3, r1, #'0'
        strb r3, [r0,#3]

        mov r3, #'\n'
        strb r3, [r0,#4]

        mov r2, #5           @ length for 2digit num
        b send_reply         @write(fd, outbuf, length)

one_digit:
        add r3, r9, #'0'
        strb r3, [r0,#2]

        mov r3, #'\n'
        strb r3, [r0,#3]

        mov r2, #4           @ length for 1digit num

          /* write(fd, outbuf, length) */
send_reply:
        mov r0, r4           @ fd
        ldr r1, =outbuf
        mov r7, #SYS_WRITE
        swi #0


        b main_loop


        /* ============= DATA ============= */
        .data

devpath: .asciz "/dev/ttyAMA0"
buffer:  .space 64
freqs:   .space 256
outbuf:  .space 8

options:
    .word 0x00000000   @ c_iflag
    .word 0x00000000   @ c_oflag
    .word 0x00000000   @ c_cflag
    .word 0x00000000   @ c_lflag
    .byte 0x00         @ c_line
    .word 0x00000000   @ c_cc[0-3]
    .word 0x00000000   @ c_cc[4-7]
    .word 0x00000000   @ c_cc[8-11]
    .word 0x00000000   @ c_cc[12-15]
    .word 0x00000000   @ c_cc[16-19]
    .word 0x00000000   @ c_cc[20-23]
    .word 0x00000000   @ c_cc[24-27]
    .word 0x00000000   @ c_cc[28-31]
    .byte 0x00
    .hword 0x0000
    .word 0x00000000   @ c_ispeed
    .word 0x00000000   @ c_ospeed


