#include "cbuf.h"

void cbuf_init(struct cbuf *buf)
{
    buf->tail = 0;
    buf->head = 0;
}

bool cbuf_is_empty(struct cbuf *buf)
{
    return buf->tail == buf->head;
}

void cbuf_push(struct cbuf *buf, item_t item)
{
    buf->items[buf->tail] = item;
    buf->tail = (buf->tail + 1) % BUF_SIZE;
}

item_t cbuf_pop(struct cbuf *buf)
{
    item_t item = buf->items[buf->head];
    buf->head = (buf->head + 1) % BUF_SIZE;

    return item;
}
