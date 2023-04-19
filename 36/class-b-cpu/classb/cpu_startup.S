.syntax unified
.thumb
.thumb_func

.data
tmp: .long 0

.text
.balign 2


.global classb_cpu_startup

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

classb_cpu_startup:
    STMDB SP!, {R4, R5, R6, R7, R8, R9, R10, R11}

    ldr r0, =tmp
    str lr, [r0]

    MOVS R0, #0x00000000      /* Set Z(ero) Flag */
    BNE.W error         /* Fails if Z clear */
    SUBS R0,#1                /* Set N(egative) Flag */
    BPL.W error         /* Fails if N clear */
    ADDS R0,#2                /* Set C(arry) Flag and do not set Z */
    BCC.W error         /* Fails if C clear */
    MOVS R0, #0x80000000      /* Prepares Overflow test */
    ADDS R0, R0, R0           /* Set V(overflow) Flag */
    BVC.W error         /* Fails if V clear */
    MOVS R0, #0xFFFFFFFF      /* Prepares Saturation test */
    USAT R1,#10,R0            /* Set Q(saturation) Flag */
    MRS R0, APSR              /* Get Status register */
    CMP R0, #0xB8000000       /* Verifies that N=C=V=Q=1 */
    BNE.W error         /* Fails if Q+N+C=V clear */

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
    mov lr, 0xAAAAAAAA

    cmp_and_set lr, 0xAAAAAAAA 0x55555555
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
    cmp_and_set lr, 0x55555555 0x00000000

    cmp_and_set lr,0x00000000 0xFFFFFFFF
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
    cmp_reg lr, 0xFFFFFFFF

  /* Process Stack pointer (banked Register R13) */
    MRS R0, PSP         /* Save process stack value */
    MOVW R1, #0xAAA8     /* Test is different (PSP is word aligned) */
    MOVT R1, #0xAAAA    /* Load in two times and 2 least significant bits cleared */
    MSR PSP, R1         /* load process stack value */
    MRS R2, PSP         /* Get back process stack value */
    CMP R2, R1          /* Verify value */
    bne error
    MOVW R1, #0x5554     /* Test is different (PSP is word aligned) */
    MOVT R1, #0x5555    /* Load in two times and 2 least significant bits cleared */
    MSR PSP, R1         /* load process stack value */
    MRS R2, PSP         /* Get back process stack value */
    CMP R2, R1          /* Verify value */
    bne error
    MSR PSP, R0         /* Restore process stack value */

  /* Stack pointer (Register R13) */
    MRS R0, MSP         /* Save process stack value */
    MOVW R1, #0xAAA8     /* Test is different (MSP is word aligned) */
    MOVT R1, #0xAAAA    /* Load in two times and 2 least significant bits cleared */
    MSR MSP, R1         /* load process stack value */
    MRS R2, MSP         /* Get back process stack value */
    CMP R2, R1          /* Verify value */
    bne error
    MOVW R1, #0x5554     /* Test is different (MSP is word aligned) */
    MOVT R1, #0x5555    /* Load in two times and 2 least significant bits cleared */
    MSR MSP, R1         /* load process stack value */
    MRS R2, MSP         /* Get back process stack value */
    CMP R2, R1          /* Verify value */
    bne error
    MSR MSP, R0         /* Restore process stack value */

    ldr r0, =tmp
    ldr lr, [r0]

    LDMIA SP!, {R4, R5, R6, R7, R8, R9, R10, R11}

    mov r0, 0
    bx lr

error:
    LDMIA SP!, {R4, R5, R6, R7, R8, R9, R10, R11}

    mov r0, -1
    bx lr
