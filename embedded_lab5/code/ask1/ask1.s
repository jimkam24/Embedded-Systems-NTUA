.text
.global main
.extern printf
.extern scanf

main:
    push {ip, lr}

main_loop: 
    @ prompt to the user
    ldr r0, =prompt
    bl printf

    @ input
    ldr r0, =fmt_read       @ argument 1: format string
    ldr r1, =buffer         @ argument 2: pointer to buffer
    bl scanf                @ read up to 32 chars (we can have spaces too)

    @ discard rest of the line
    ldr r0, =fmt_discard
    bl scanf


    ldr r0, =buffer
    ldrb r1, [r0]           @ r1 = first char
    ldrb r2, [r0, #1]      @ r2 = second char
    cmp r2, #0             @ is buffer[1] == '\0' ?
    bne continue_program   @ NO: not possible to have single q or Q
    orr r1, r1, #0x20      @ trick to force lowercase, do not double check
    cmp r1, #'q'            @ check for 'q'
    beq exit_program

continue_program:
    bl swap

    @ output
    ldr r0, =out_fmt           @ r0 = "%s\n"
    ldr r1, =buffer            @ r1 = pointer to string
    bl printf                  @ printf("%s\n", buffer);

    b main_loop

exit_program:
    ldr r0, =exit_msg
    bl printf
    mov r0, #0

    pop {ip, pc} @ return

swap:
    push {ip, lr}

loop:
    ldrb r1, [r0]          @ load byte
    cmp r1, #0             @ end of string?
    beq finished

    orr r2, r1, #0x20      @ trick to force lowercase (save checks)
    cmp r2, #'a'           @ >= of the ASCII value of 'a' ?
    blt check_digit        @ not a letter
    cmp r2, #'z'            @ < 'z' ?
    bgt check_digit        @ not a letter
    tst r1, #0x20          @ is the original lowercase (bit 5 set) ?
    bne to_uppercase
    orr r1, r1, #0x20      @ make lowercase 
    b store

check_digit:               @ no need to convert from ASCII, we save instructions
    cmp r1, #'0'
    blt store
    cmp r1, #'9'
    bgt store
    add     r1, r1, #5        @ add 5
    cmp     r1, #'9'          @ do we exceed 9 ?
    subgt   r1, r1, #10       @ if r1 > '9', subtract 10 (self made mod)
    b store

to_uppercase:
    bic r1, r1, #0x20      @ make uppercase

store:
    strb r1, [r0], #1          @ store modified byte and increment
    b loop

finished:
    pop {ip, pc} @ return

.data
fmt_read:          .asciz "%32[^\n]%*[^\n]"
fmt_discard: .asciz "%*c"
buffer:    .space 33        @ 32 chars + '\0'
out_fmt:    .asciz "Result is: %s\n"      @ printf format: print string + newline
prompt:     .asciz "Input a string of up to 32 chars long:"
exit_msg:     .asciz "Exiting...\n"

