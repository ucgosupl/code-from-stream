.syntax unified
.thumb
.thumb_func

.text
.balign 2


.global classb_cpu_runtime

.macro cmp_and_set reg, val1, val2
    cmp \reg, \val1
    bne error
    mov \reg, \val2
.endm

.macro cmp_reg reg, val
    cmp \reg, \val
    bne error
.endm

/*
0xAAAAAAAA
0x55555555
0xFFFFFFFF
0x00000000
0x0F0F0F0F
0xF0F0F0F0
*/

classb_cpu_runtime:
    STMDB SP!, {R4, R5, R6, R7, R8, R9, R10, R11}

    mov r0, 0xAAAAAAAA
    mov r1, 0xAAAAAAAA
    mov r2, 0xAAAAAAAA
    mov r3, 0xAAAAAAAA
    mov r4, 0xAAAAAAAA
    mov r5, 0xAAAAAAAA
    mov r6, 0xAAAAAAAA
    mov r7, 0xAAAAAAAA
    mov r8, 0xAAAAAAAA
    mov r9, 0xAAAAAAAA
    mov r10, 0xAAAAAAAA
    mov r11, 0xAAAAAAAA
    mov r12, 0xAAAAAAAA

    cmp_and_set r12, 0xAAAAAAAA 0x55555555
    cmp_and_set r11, 0xAAAAAAAA 0x55555555
    cmp_and_set r10, 0xAAAAAAAA 0x55555555
    cmp_and_set r9, 0xAAAAAAAA 0x55555555
    cmp_and_set r8, 0xAAAAAAAA 0x55555555
    cmp_and_set r7, 0xAAAAAAAA 0x55555555
    cmp_and_set r6, 0xAAAAAAAA 0x55555555
    cmp_and_set r5, 0xAAAAAAAA 0x55555555
    cmp_and_set r4, 0xAAAAAAAA 0x55555555
    cmp_and_set r3, 0xAAAAAAAA 0x55555555
    cmp_and_set r2, 0xAAAAAAAA 0x55555555
    cmp_and_set r1, 0xAAAAAAAA 0x55555555
    cmp_and_set r0, 0xAAAAAAAA 0x55555555

    cmp_and_set r0, 0x55555555 0x00000000 
    cmp_and_set r1, 0x55555555 0x00000000
    cmp_and_set r2, 0x55555555 0x00000000
    cmp_and_set r3, 0x55555555 0x00000000
    cmp_and_set r4, 0x55555555 0x00000000
    cmp_and_set r5, 0x55555555 0x00000000
    cmp_and_set r6, 0x55555555 0x00000000
    cmp_and_set r7, 0x55555555 0x00000000
    cmp_and_set r8, 0x55555555 0x00000000
    cmp_and_set r9, 0x55555555 0x00000000
    cmp_and_set r10, 0x55555555 0x00000000
    cmp_and_set r11, 0x55555555 0x00000000
    cmp_and_set r12, 0x55555555 0x00000000

    cmp_and_set r12,0x00000000 0xFFFFFFFF
    cmp_and_set r11,0x00000000 0xFFFFFFFF
    cmp_and_set r10,0x00000000 0xFFFFFFFF
    cmp_and_set r9, 0x00000000 0xFFFFFFFF
    cmp_and_set r8, 0x00000000 0xFFFFFFFF
    cmp_and_set r7, 0x00000000 0xFFFFFFFF
    cmp_and_set r6, 0x00000000 0xFFFFFFFF
    cmp_and_set r5, 0x00000000 0xFFFFFFFF
    cmp_and_set r4, 0x00000000 0xFFFFFFFF
    cmp_and_set r3, 0x00000000 0xFFFFFFFF
    cmp_and_set r2, 0x00000000 0xFFFFFFFF
    cmp_and_set r1, 0x00000000 0xFFFFFFFF
    cmp_and_set r0, 0x00000000 0xFFFFFFFF

    cmp_reg r0,  0xFFFFFFFF
    cmp_reg r1,  0xFFFFFFFF
    cmp_reg r2,  0xFFFFFFFF
    cmp_reg r3,  0xFFFFFFFF
    cmp_reg r4,  0xFFFFFFFF
    cmp_reg r5,  0xFFFFFFFF
    cmp_reg r6,  0xFFFFFFFF
    cmp_reg r7,  0xFFFFFFFF
    cmp_reg r8,  0xFFFFFFFF
    cmp_reg r9,  0xFFFFFFFF
    cmp_reg r10, 0xFFFFFFFF
    cmp_reg r11, 0xFFFFFFFF
    cmp_reg r12, 0xFFFFFFFF

    LDMIA SP!, {R4, R5, R6, R7, R8, R9, R10, R11}

    mov r0, 0
    bx lr

error:
    LDMIA SP!, {R4, R5, R6, R7, R8, R9, R10, R11}

    mov r0, -1
    bx lr
