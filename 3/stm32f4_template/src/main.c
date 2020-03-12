/*
 * File: main.c
 * Author: GAndaLF
 * Brief: Main file for main_program target.
 */

#include "platform_specific.h"

#include "core_init/core_init.h"

#include "classb_vars/test_var.h"

void main(void)
{
    core_init();

    /* Place your initialisation code here. */
    classb_test_var_init();

    /* Place your application code here. */

    while (1)
    {
        volatile uint32_t safety_var = classb_test_var_get();
        safety_var++;
        classb_test_var_set(safety_var);
    }
}
