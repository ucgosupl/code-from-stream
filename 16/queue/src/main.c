#include "platform_specific.h"
#include "rtos_wrappers.h"

#include "core_init/core_init.h"
#include "buttons/buttons_task.h"
#include "motor/motor_task.h"

int main(void)
{
    core_init();

    buttons_task_init();
    motor_task_init();

    rtos_start_scheduler();

    while (1)
        ;

    return 0;
}