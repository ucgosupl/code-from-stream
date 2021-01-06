#include "platform_specific.h"
#include "rtos_wrappers.h"

#include "buttons_task.h"
#include "gpio_f4/gpio_f4.h"
#include "motor/motor_task.h"

static void buttons_task(void *params);

static void buttons_init(void);
static uint32_t button_forward_is_pressed(void);
static uint32_t button_backward_is_pressed(void);
static uint32_t button_left_is_pressed(void);
static uint32_t button_right_is_pressed(void);

void buttons_task_init(void)
{
    buttons_init();

    rtos_task_create(buttons_task, "buttons", RTOS_TASK_STACKSIZE_MIN, RTOS_PRIORITY_MIN + 1);
}

#define BUTTON_DEBOUNCE_INTERVAL_MS     10
#define BUTTON_DEBOUNCE_THRESHOLD_MS    100
#define BUTTON_DEBOUNCE_THRESHOLD_VAL   ((BUTTON_DEBOUNCE_THRESHOLD_MS) / (BUTTON_DEBOUNCE_INTERVAL_MS))

static void buttons_task(void *params)
{
    (void) params;

    uint32_t bt_forward_state = 0;
    uint32_t bt_forward_last_state = 0;
    uint32_t bt_forward_cnt = 0;

    while (1)
    {
        rtos_delay(BUTTON_DEBOUNCE_INTERVAL_MS);

        bt_forward_state = button_forward_is_pressed();

        if (bt_forward_state != bt_forward_last_state)
        {
            bt_forward_cnt++;

            if (bt_forward_cnt >= BUTTON_DEBOUNCE_THRESHOLD_VAL)
            {
                bt_forward_cnt = 0;
                bt_forward_last_state = bt_forward_state;

                if (bt_forward_state != 0)
                {
                    motor_send_command(MOTOR_CMD_FORWARD);
                }
            }
        }
    }
}

#define BUTTON_FORWARD_PIN      0
#define BUTTON_BACKWARD_PIN     1
#define BUTTON_LEFT_PIN         2
#define BUTTON_RIGHT_PIN        3

static void buttons_init(void)
{
    RCC->AHB1ENR |= RCC_AHB1ENR_GPIOAEN;

    gpio_mode_config(GPIOA, BUTTON_FORWARD_PIN, GPIO_MODE_INPUT);
    gpio_pupd_config(GPIOA, BUTTON_FORWARD_PIN, GPIO_PUPD_NONE);

    gpio_mode_config(GPIOA, BUTTON_BACKWARD_PIN, GPIO_MODE_INPUT);
    gpio_pupd_config(GPIOA, BUTTON_BACKWARD_PIN, GPIO_PUPD_NONE);

    gpio_mode_config(GPIOA, BUTTON_LEFT_PIN, GPIO_MODE_INPUT);
    gpio_pupd_config(GPIOA, BUTTON_LEFT_PIN, GPIO_PUPD_NONE);

    gpio_mode_config(GPIOA, BUTTON_RIGHT_PIN, GPIO_MODE_INPUT);
    gpio_pupd_config(GPIOA, BUTTON_RIGHT_PIN, GPIO_PUPD_NONE);
}

static uint32_t button_forward_is_pressed(void)
{
    return 0 != (GPIOA->IDR & (1 << BUTTON_FORWARD_PIN));
}

static uint32_t button_backward_is_pressed(void)
{
    return 0 != (GPIOA->IDR & (1 << BUTTON_BACKWARD_PIN));
}

static uint32_t button_left_is_pressed(void)
{
    return 0 != (GPIOA->IDR & (1 << BUTTON_LEFT_PIN));
}

static uint32_t button_right_is_pressed(void)
{
    return 0 != (GPIOA->IDR & (1 << BUTTON_RIGHT_PIN));
}
