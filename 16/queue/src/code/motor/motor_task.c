#include "platform_specific.h"
#include "rtos_wrappers.h"

#include "motor_task.h"
#include "gpio_f4/gpio_f4.h"

static void motor_task(void *params);

static void motor_init(void);
static void motor_forward(void);
static void motor_backward(void);
static void motor_left(void);
static void motor_right(void);
static void motor_stop(void);

static queue_t motor_commands_queue = NULL;

void motor_task_init(void)
{
    motor_init();

    motor_commands_queue = rtos_queue_create(8, sizeof(enum motor_cmd));

    rtos_task_create(motor_task, "motor", RTOS_TASK_STACKSIZE_MIN, RTOS_PRIORITY_MIN + 1);
}

void motor_send_command(enum motor_cmd cmd)
{
    rtos_queue_send(motor_commands_queue, &cmd, 0);
}

static void motor_task(void *params)
{
    (void) params;

    enum motor_cmd cmd = MOTOR_CMD_NOCMD;

    while (1)
    {
        cmd = MOTOR_CMD_NOCMD;

        if (pdTRUE == rtos_queue_receive(motor_commands_queue, &cmd, portMAX_DELAY))
        {
            switch (cmd)
            {
                case MOTOR_CMD_FORWARD:
                    motor_forward();
                    break;
                case MOTOR_CMD_BACKWARD:
                    motor_backward();
                    break;
                case MOTOR_CMD_LEFT:
                    motor_left();
                    break;
                case MOTOR_CMD_RIGHT:
                    motor_right();
                    break;
                case MOTOR_CMD_STOP:
                    motor_stop();
                    break;
                default:
                    break;
            }
        }
    }
}

#define LED_GREEN_PIN       12
#define LED_ORANGE_PIN      13
#define LED_RED_PIN         14
#define LED_BLUE_PIN        15

static void motor_init(void)
{
    RCC->AHB1ENR |= RCC_AHB1ENR_GPIODEN;

    gpio_mode_config(GPIOD, LED_GREEN_PIN, GPIO_MODE_OUTPUT);
    gpio_mode_config(GPIOD, LED_ORANGE_PIN, GPIO_MODE_OUTPUT);
    gpio_mode_config(GPIOD, LED_RED_PIN, GPIO_MODE_OUTPUT);
    gpio_mode_config(GPIOD, LED_BLUE_PIN, GPIO_MODE_OUTPUT);
}

static void motor_forward(void)
{
    GPIOD->BSRRL = 1 << LED_GREEN_PIN;

    GPIOD->BSRRH = 1 << LED_ORANGE_PIN;
    GPIOD->BSRRH = 1 << LED_RED_PIN;
    GPIOD->BSRRH = 1 << LED_BLUE_PIN;
}

static void motor_backward(void)
{
    GPIOD->BSRRL = 1 << LED_ORANGE_PIN;

    GPIOD->BSRRH = 1 << LED_GREEN_PIN;
    GPIOD->BSRRH = 1 << LED_RED_PIN;
    GPIOD->BSRRH = 1 << LED_BLUE_PIN;
}

static void motor_left(void)
{
    GPIOD->BSRRL = 1 << LED_RED_PIN;

    GPIOD->BSRRH = 1 << LED_GREEN_PIN;
    GPIOD->BSRRH = 1 << LED_ORANGE_PIN;
    GPIOD->BSRRH = 1 << LED_BLUE_PIN;
}

static void motor_right(void)
{
    GPIOD->BSRRL = 1 << LED_BLUE_PIN;

    GPIOD->BSRRH = 1 << LED_GREEN_PIN;
    GPIOD->BSRRH = 1 << LED_ORANGE_PIN;
    GPIOD->BSRRH = 1 << LED_RED_PIN;
}

static void motor_stop(void)
{
    GPIOD->BSRRH = 1 << LED_GREEN_PIN;
    GPIOD->BSRRH = 1 << LED_ORANGE_PIN;
    GPIOD->BSRRH = 1 << LED_RED_PIN;
    GPIOD->BSRRH = 1 << LED_BLUE_PIN;
}
