#pragma once

#include <stdint.h>
#include <stdbool.h>

#define TIMEOUT_MS          500
#define TICK_MS             10
#define TIMEOUT_TICKS       (TIMEOUT_MS / TICK_MS)

typedef enum
{
    PIN_STATE_LOW = 0,
    PIN_STATE_HIGH = 1,
} pin_state_t;

void heartbeat_init(void);
void heartbeat_check(pin_state_t state);

