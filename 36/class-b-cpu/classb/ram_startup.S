.syntax unified
.thumb
.thumb_func

.equ RAM_START, 0x20000000
.equ RAM_END, 0x20020000

.text
.balign 2

.global classb_ram_startup


classb_ram_startup:
    
    mov r0, RAM_START
    movw r2, #0x0000
    movt r2, #0x2002
    mov r1, 0x00000000

fill_zero:
    /* Check if end address reached */
    cmp r0, r2
    beq fill_zero_end

    /* Write new pattern */
    str r1, [r0]
    add r0, 4

    b fill_zero

fill_zero_end:
    mov r0, RAM_START
    mov r4, 0x00000000
    mov r1, 0xFFFFFFFF

read_0_write_1_up:
    /* Check if end address reached */
    cmp r0, r2
    beq read_0_write_1_up_end

    /* Check if previous pattern read */
    ldr r3, [r0]
    cmp r3, r4
    bne error

    /* Write new pattern */
    str r1, [r0]
    add r0, 4

    b read_0_write_1_up

read_0_write_1_up_end:
    mov r0, RAM_START
    mov r1, 0x00000000
    mov r4, 0xFFFFFFFF

read_1_write_0_up:
    /* Check if end address reached */
    cmp r0, r2
    beq read_1_write_0_up_end

    /* Check if previous pattern read */
    ldr r3, [r0]
    cmp r3, r4
    bne error

    /* Write new pattern */
    str r1, [r0]
    add r0, 4

    b read_1_write_0_up

read_1_write_0_up_end:
    mov r2, RAM_START
    mov r1, 0xFFFFFFFF
    mov r4, 0

read_0_write_1_down:
    sub r0, 4

    /* Check if start address reached */
    cmp r0, r2
    beq read_0_write_1_down_end

    /* Check if previous pattern read */
    ldr r3, [r0]
    cmp r3, r4
    bne error

    /* Write new pattern */
    str r1, [r0]

    b read_0_write_1_down

read_0_write_1_down_end:
    mov r2, RAM_START
    movw r0, #0x0000
    movt r0, #0x2002
    mov r1, 0x00000000
    mov r4, 0xFFFFFFFF

read_1_write_0_down:
    sub r0, 4

    /* Check if start address reached */
    cmp r0, r2
    beq read_1_write_0_down_end

    /* Check if previous pattern read */
    ldr r3, [r0]
    cmp r3, r4
    bne error

    /* Write new pattern */
    str r1, [r0]

    b read_1_write_0_down

read_1_write_0_down_end:
    mov r0, RAM_START
    movw r2, #0x0000
    movt r2, #0x2002
    mov r4, 0x00000000

read_0:
    cmp r0, r2
    beq read_0_end

    /* Check if previous pattern read */
    ldr r3, [r0]
    cmp r3, r4
    bne error

    add r0, 4

    b read_0

read_0_end:
    mov r0, 0
    bx lr

error:
    mov r0, -1
    bx lr