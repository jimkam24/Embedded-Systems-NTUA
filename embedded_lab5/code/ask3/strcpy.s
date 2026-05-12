.text
.align 4  @ code alignment
.global strcpy @ function name
.type strcpy, %function

strcpy:
    mov     r2, r0          @ do not change original dst

copy_loop:
    ldrb r3, [r1], #1   @ load byte from src and post-increment
    strb r3, [r2], #1   @ store byte to dst and post-increment
    cmp  r3, #0         @ was it the null terminator?
    bne  copy_loop      @ if not, continue
    bx lr
