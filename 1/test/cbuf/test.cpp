#include "catch.hpp"

extern "C"
{
#include "cbuf.h"
}

SCENARIO("buffer empty after init")
{
    struct cbuf buf;

    cbuf_init(&buf);

    REQUIRE(cbuf_is_empty(&buf));
}

SCENARIO("buffer not empty after adding item")
{
    struct cbuf buf;
    item_t item = 0xAA5500FF;

    cbuf_init(&buf);
    cbuf_push(&buf, item);

    REQUIRE_FALSE(cbuf_is_empty(&buf));
}

SCENARIO("receive the same element that was added earlier")
{
    struct cbuf buf;
    item_t item = 0xAA5500FF;

    cbuf_init(&buf);
    cbuf_push(&buf, item);

    REQUIRE(item == cbuf_pop(&buf));
}

SCENARIO("overflow")
{
    struct cbuf buf;
    item_t item = 0xAA5500FF;
    item_t item2 = 0x335500FF;

    cbuf_init(&buf);

    GIVEN("buffer is full")
    {
        for (int i = 0; i < BUF_SIZE; i++)
        {
            cbuf_push(&buf, item);
            cbuf_pop(&buf);
        }

        WHEN("added item")
        {
            cbuf_push(&buf, item2);

            THEN("the same item is read")
            {
                REQUIRE(item2 == cbuf_pop(&buf));
            }

            WHEN("added second item and read first item")
            {
                cbuf_push(&buf, item2 + 1);
                cbuf_pop(&buf);

                THEN("the same item is read")
                {
                    REQUIRE((item2 + 1) == cbuf_pop(&buf));
                }
            }
        }
    }
}

SCENARIO("read item when buffer empty")
{
    struct cbuf buf;
    item_t item = 0xAA5500FF;

    cbuf_init(&buf);
    cbuf_pop(&buf);

    REQUIRE(item == cbuf_pop(&buf));
}
