#include "platform_specific.h"
#include "rtos_wrappers.h"

#include "classb_task.h"

#include <string.h>

#define RAM_TEST_SLICE  64
#define RAM_START       0x20000000
#define RAM_END         0x20020000

extern int classb_cpu_runtime(void);
extern int classb_ram_runtime(uintptr_t addr, void * backup_addr);

static void classb_task(void *params);
static void runtime_tests(void);

enum test_step {TEST_CPU, TEST_RAM, TEST_FLASH, TEST_STACK};

static enum test_step current_step;

static uint8_t  ram_backup[2][RAM_TEST_SLICE] __attribute__((aligned(64)));
static uintptr_t current_addr;


void classb_task_init(void)
{
    current_step = TEST_CPU;
    current_addr = RAM_START;
    rtos_task_create(classb_task, "classb", RTOS_TASK_STACKSIZE_MIN, RTOS_PRIORITY_MIN + 2);
}


void safe_state_runtime(void)
{
	while (1)
		;
}


static void classb_task(void *params)
{
	while (1)
	{
        tick_t ticks = rtos_tick_count_get();

        taskENTER_CRITICAL();
        runtime_tests();
        taskEXIT_CRITICAL();

		rtos_delay_until(&ticks, rtos_ms_to_ticks(100));
	}
}

static void runtime_tests(void)
{
    switch (current_step)
    {
        case TEST_CPU:
        {
            if (0 != classb_cpu_runtime())
            {
                safe_state_runtime();
            }

            current_step = TEST_RAM;
            break;
        }

        case TEST_RAM:
        {
            uint8_t *backup_ptr = ram_backup[0];

            if (current_addr == ram_backup[0])
            {
                backup_ptr = ram_backup[1];
            }

            if (0 != classb_ram_runtime(current_addr, backup_ptr))
            {
                safe_state_runtime();
            }

            current_addr += RAM_TEST_SLICE;
            if (RAM_END == current_addr)
            {
                current_step = TEST_CPU;
                current_addr = RAM_START;
            }

            break;
        }

    }






}

