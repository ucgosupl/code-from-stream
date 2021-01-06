#include "platform_specific.h"
#include "rtos_wrappers.h"

#include "core_init/core_init.h"
#include "blink_task.h"

int main(void)
{
    core_init();

    blink_task_init();
    rtos_start_scheduler();

    while (1)
        ;

    return 0;
}