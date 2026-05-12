    .text
    .align 4
    .global strcmp
    .type strcmp, %function

strcmp:

compare_loop:
    ldrb r2, [r0], #1     @ load byte from s1, post-increment
    ldrb r3, [r1], #1     @ load byte from s2, post-increment

    cmp  r2, r3           @ compare characters
    bne  return_diff      @ if different, return difference

    cmp  r2, #0           @ if we reached null terminator (s1 == s2)
    bne  compare_loop     @ if not 0, continue comparing

    @ strings are identical
    mov  r0, #0
    bx lr

return_diff:
    sub  r0, r2, r3       @ return (unsigned char)s1[i] - (unsigned char)s2[i]
    bx lr
