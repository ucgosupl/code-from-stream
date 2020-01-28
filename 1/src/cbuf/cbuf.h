#pragma once

#include <stdint.h>
#include <stdbool.h>

#define BUF_SIZE    8

typedef uint32_t item_t;

struct cbuf
{
    uint32_t head;
    uint32_t tail;

    item_t items[BUF_SIZE];
};

void cbuf_init(struct cbuf *buf);
bool cbuf_is_empty(struct cbuf *buf);
void cbuf_push(struct cbuf *buf, item_t item);
item_t cbuf_pop(struct cbuf *buf);