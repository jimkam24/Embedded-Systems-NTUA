.text
.align 4  @ code alignment
.global strlen @ function name
.type strlen, %function

strlen:
    mov r1, r0        @ r1 = pointer walker

load:  
    ldrb r2, [r1], #1     @ load byte and post increment
    cmp  r2, #0
    bne load

return:  
    sub r0, r1, r0    @ r0 = r1 - original pointer ...
    sub r0, r0, #1    @ ... we have also counted the null termination
    bx lr             @ return

