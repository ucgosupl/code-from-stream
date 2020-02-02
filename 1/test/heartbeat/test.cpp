#include "catch.hpp"

extern "C"
{
#include "heartbeat/heartbeat.h"
}

extern "C"
{
void mock_safestate_init(void);
uint32_t mock_safestate_cnt_get(void);
}

void simulate_one_tick_before_timeout(pin_state_t state)
{
    for (int i = 0; i < (TIMEOUT_TICKS - 1); i++)
    {
        heartbeat_check(state);
    }
}

SCENARIO("Fatal error when pin doesn't change for 500 ms")
{
    mock_safestate_init();
    heartbeat_init();

    GIVEN("pin is low")
    {
        pin_state_t state = PIN_STATE_LOW;

        WHEN("500 ms - 1 tick passed")
        {
            simulate_one_tick_before_timeout(state);
            
            THEN("fatal error not reported")
            {
                REQUIRE(0 == mock_safestate_cnt_get());
            }

            WHEN("500 ms tick passed")
            {
                heartbeat_check(state);

                THEN("fatal error reported")
                {
                    REQUIRE(1 == mock_safestate_cnt_get());
                }
            }

            WHEN("state changes")
            {
                state = PIN_STATE_HIGH;

                THEN("no fatal error")
                {
                    heartbeat_check(state);
                    REQUIRE(0 == mock_safestate_cnt_get());
                }

                WHEN("next 500 ms - 1 tick passed")
                {
                    simulate_one_tick_before_timeout(state);

                    THEN("no fatal error")
                    {
                        REQUIRE(0 == mock_safestate_cnt_get());
                    }

                    WHEN("500 ms tick passed")
                    {
                        heartbeat_check(state);

                        THEN("fatal error reported")
                        {
                            REQUIRE(1 == mock_safestate_cnt_get());
                        }
                    }
                }
            }
        }
    }
}

SCENARIO("safestate if out of bounds for 3 iterations")
{
    pin_state_t state = PIN_STATE_LOW;

    mock_safestate_init();
    heartbeat_init();

    WHEN("2 edges too early")
    {
        state = PIN_STATE_HIGH;

        for (int i = 0; i < (100 - 20)/TICK_MS - 1; i++)
        {
            heartbeat_check(state);
        }
        state = PIN_STATE_LOW;

        for (int i = 0; i < (100 - 20) / TICK_MS - 1; i++)
        {
            heartbeat_check(state);
        }
        state = PIN_STATE_HIGH;
 
        THEN("No fatal error")
        {
            heartbeat_check(state);
            REQUIRE(0 == mock_safestate_cnt_get());
        }

        WHEN("3rd edge too early")
        {
            THEN("fatal error")
            {

            }
        }

        WHEN("3rd edge in bounds")
        {
            THEN("no fatal error")
            {

            }

            WHEN("4th edge too early")
            {
                THEN("no fatal error")
                {
                }

                WHEN("5th edge too early")
                {
                    THEN("no fatal error")
                    {
                    }

                    WHEN("4th edge too early")
                    {
                        THEN("no fatal error")
                        {
                        }
                    }
                }
            }
        }
    }
}

extern "C"
{

typedef struct
{
    uint32_t cnt;
} mock_safestate_t;

static mock_safestate_t mock_safestate;

void mock_safestate_init(void)
{
    mock_safestate.cnt = 0;
}

uint32_t mock_safestate_cnt_get(void)
{
    return mock_safestate.cnt;
}

void trigger_safe_state(void)
{
    mock_safestate.cnt++;
}

}

//pin changes state every 100 ms
//tolerance +/- 20 ms
//safestate if out of bounds for 3 iterations
//pin checked every 10 ms

