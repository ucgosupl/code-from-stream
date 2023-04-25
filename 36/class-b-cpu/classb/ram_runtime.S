.syntax unified
.thumb
.thumb_func

.text
.balign 2

.global classb_ram_runtime

/* 0xAAAAAAAA 0x55555555 */

classb_ram_runtime:
    stmdb SP!, {r4, r5, r6, r7}

    mov r7, r1

    /* Backup ram slice under test */
    mov r1, r0
    mov r5, r7
    mov r2, 64
    mov r4, 0

backup_ram_slice:
    ldr r3, [r1]
    str r3, [r5]

    add r4, 4
    cmp r2, r4
    beq backup_ram_slice_end

    add r1, 4
    add r5, 4
    b backup_ram_slice
    
backup_ram_slice_end:

    /* Prepare local variables for filling ram slice with pattern */
    mov r1, r0
    mov r2, 64
    mov r3, 0xAAAAAAAA
    mov r4, 0

fill_aa:
    /* Write pattern from r3 to address in r1 */
    str r3, [r1]

    /* add 1 to iteration cnt stored in r4 and compare with slice size in r2 */
    add r4, 4
    cmp r2, r4
    beq fill_aa_end

    /* increment address */
    add r1, 4
    b fill_aa

fill_aa_end:
    mov r1, r0
    mov r3, 0x55555555
    mov r4, 0
    mov r5, 0xAAAAAAAA

read_aa_fill_55:
    /* Read data from ram address stored in r1 and compare with pattern in r5 */
    ldr r6, [r1]
    cmp r5, r6
    bne error

    /* Store new pattern from r3 in ram address r1 */
    str r3, [r1]

    /* add 1 to iteration cnt stored in r4 and compare with slice size in r2 */
    add r4, 4
    cmp r2, r4
    beq end_read_aa_fill_55

    /* increment address */
    add r1, 4
    b read_aa_fill_55

end_read_aa_fill_55:
    mov r1, r0
    mov r4, 0

read_55:
    /* Read data from ram address stored in r1 and compare with pattern in r3 */
    ldr r6, [r1]
    cmp r3, r6
    bne error

    /* add 1 to iteration cnt stored in r4 and compare with slice size in r2 */
    add r4, 4
    cmp r2, r4
    beq end_read_55

    /* increment address */
    add r1, 4
    b read_55


end_read_55:
    /* Restore previous ram slice content from backup */
    mov r1, r0
    mov r5, r7
    mov r2, 64
    mov r4, 0

restore_ram_slice:
    ldr r3, [r5]
    str r3, [r1]

    add r4, 4
    cmp r2, r4
    beq restore_ram_slice_end

    add r1, 4
    add r5, 4
    b restore_ram_slice

restore_ram_slice_end:

    ldmia SP!, {r4, r5, r6, r7}

    mov r0, 0
    bx lr

error:
    /* Restore previous ram slice content from backup */

    ldmia SP!, {r4, r5, r6, r7}

    mov r0, -1
    bx lr
