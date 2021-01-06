#include "platform_specific.h"
#include "rtos_wrappers.h"

#include "blink_task.h"
#include "gpio_f4/gpio_f4.h"

static void blink_task(void *params);

static void led_init(void);
static void led_toggle(void);

void blink_task_init(void)
{
    led_init();

    rtos_task_create(blink_task, "blink", RTOS_TASK_STACKSIZE_MIN, RTOS_PRIORITY_MIN + 1);
}

static void blink_task(void *params)
{
    (void) params;

    tick_t delay = rtos_ms_to_ticks(500);

    while (1)
    {
        rtos_delay(delay);

        led_toggle();
    }
}

#define LED_GREEN_PIN       12
#define LED_ORANGE_PIN      13
#define LED_RED_PIN         14
#define LED_BLUE_PIN        15

static void led_init(void)
{
    RCC->AHB1ENR |= RCC_AHB1ENR_GPIODEN;

    gpio_mode_config(GPIOD, LED_GREEN_PIN, GPIO_MODE_OUTPUT);
    gpio_mode_config(GPIOD, LED_ORANGE_PIN, GPIO_MODE_OUTPUT);
    gpio_mode_config(GPIOD, LED_RED_PIN, GPIO_MODE_OUTPUT);
    gpio_mode_config(GPIOD, LED_BLUE_PIN, GPIO_MODE_OUTPUT);
}

static void led_toggle(void)
{
    GPIOD->ODR ^= 1 << LED_GREEN_PIN;
}
