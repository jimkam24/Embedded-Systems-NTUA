    .text
    .align 4
    .global strcat
    .type strcat, %function

strcat:
    mov r2, r0        @ r2 = dst walker (to find end)

find_end:
    ldrb r3, [r2], #1     @ load byte from dst and post-increment
    cmp  r3, #0
    bne find_end

    sub r2, r2, #1    @ move one step behind to overwrite \0

copy_src:
    ldrb r3, [r1], #1 @ load from src, post-increment
    strb r3, [r2], #1 @ store to end of dst, post-increment
    cmp  r3, #0       @ stop once null terminator copied
    bne copy_src

    bx lr            @ return dst (still in r0)
