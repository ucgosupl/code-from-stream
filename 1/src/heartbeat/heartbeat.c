#include "heartbeat.h"
#include "safe_state.h"

typedef uint32_t timeout_t;

static timeout_t timeout = 0;

void heartbeat_init(void)
{
    timeout = 0;
}

void heartbeat_check(pin_state_t state)
{
    static pin_state_t old_state = PIN_STATE_LOW;

    if (state != old_state)
    {
        timeout = 0;
        old_state = state;
    }

    if(timeout >= (TIMEOUT_TICKS - 1))
    {
        trigger_safe_state();
    }

    timeout++;
}

