/*******************************************************************************
  Ring buffer — portable implementation.
  Byte-for-byte copy of the dsPIC33CK version (algorithm unchanged); only
  header type selection differs (see ringbuffer.h).
*******************************************************************************/
#include <stdint.h>
#include <string.h>
#include "ringbuffer.h"

int8_t ringbuffer_init(ringbuffer_t *rb, void *buffer,
                       ringbuffer_size_t len, size_t itemsize)
{
    if ((((len - 1) & len) != 0) || (len > RINGBUFFER_MAX_SIZE) || (buffer == 0))
        return 1;

    memset(rb, 0, sizeof(*rb));
    rb->len      = len;
    rb->itemsize = itemsize;
    rb->data     = buffer;
    rb->_mask    = 2 * len - 1;
    return 0;
}

void ringbuffer_reset(ringbuffer_t *rb)
{
    rb->readIdx  = 0;
    rb->writeIdx = 0;
}

ringbuffer_size_t ringbuffer_read(ringbuffer_t *rb, void *dst,
                                  ringbuffer_size_t itemcount)
{
    ringbuffer_size_t avail = ringbuffer_get_read_items(rb);
    ringbuffer_size_t buflen;
    const void *src = ringbuffer_get_read_buffer(rb, &buflen);

    if (itemcount > avail) itemcount = avail;

    if (buflen >= itemcount) {
        memcpy(dst, src, itemcount * rb->itemsize);
    } else {
        memcpy(dst, src, buflen * rb->itemsize);
        src = rb->data;
        memcpy((uint8_t *)dst + buflen * rb->itemsize,
               src, (itemcount - buflen) * rb->itemsize);
    }
    ringbuffer_advance_read_index(rb, itemcount);
    return itemcount;
}

ringbuffer_size_t ringbuffer_write(ringbuffer_t *rb, const void *src,
                                   ringbuffer_size_t itemcount)
{
    ringbuffer_size_t avail = ringbuffer_get_write_items(rb);
    ringbuffer_size_t buflen;
    void *dst = ringbuffer_get_write_buffer(rb, &buflen);

    if (itemcount > avail) itemcount = avail;

    if (buflen >= itemcount) {
        memcpy(dst, src, itemcount * rb->itemsize);
    } else {
        memcpy(dst, src, buflen * rb->itemsize);
        dst = rb->data;
        memcpy(dst, (const uint8_t *)src + buflen * rb->itemsize,
               (itemcount - buflen) * rb->itemsize);
    }
    ringbuffer_advance_write_index(rb, itemcount);
    return itemcount;
}

ringbuffer_size_t ringbuffer_get_read_items(ringbuffer_t *rb)
{
    return (rb->writeIdx - rb->readIdx) & rb->_mask;
}

ringbuffer_size_t ringbuffer_get_write_items(ringbuffer_t *rb)
{
    return rb->len - ((rb->writeIdx - rb->readIdx) & rb->_mask);
}

const void *ringbuffer_get_read_buffer(ringbuffer_t *rb,
                                       ringbuffer_size_t *itemcount)
{
    ringbuffer_size_t w = rb->writeIdx;
    ringbuffer_size_t r = rb->readIdx;
    ringbuffer_size_t avail = (w - r) & rb->_mask;

    r &= rb->len - 1;
    *itemcount = (r + avail > rb->len) ? (rb->len - r) : avail;
    return (const void *)(rb->data + r * rb->itemsize);
}

void *ringbuffer_get_write_buffer(ringbuffer_t *rb,
                                  ringbuffer_size_t *itemcount)
{
    ringbuffer_size_t r = rb->readIdx;
    ringbuffer_size_t w = rb->writeIdx;
    ringbuffer_size_t avail = rb->len - ((w - r) & rb->_mask);

    w &= rb->len - 1;
    *itemcount = (w + avail > rb->len) ? (rb->len - w) : avail;
    return (void *)(rb->data + w * rb->itemsize);
}

ringbuffer_size_t ringbuffer_advance_read_index(ringbuffer_t *rb,
                                                ringbuffer_size_t itemcount)
{
    ringbuffer_size_t r = rb->readIdx;
    ringbuffer_size_t avail = (rb->writeIdx - r) & rb->_mask;
    if (itemcount > avail) itemcount = avail;
    __ringbuffer_sync();
    rb->readIdx = (r + itemcount) & rb->_mask;
    return itemcount;
}

ringbuffer_size_t ringbuffer_advance_write_index(ringbuffer_t *rb,
                                                 ringbuffer_size_t itemcount)
{
    ringbuffer_size_t w = rb->writeIdx;
    ringbuffer_size_t avail = rb->len - ((w - rb->readIdx) & rb->_mask);
    if (itemcount > avail) itemcount = avail;
    __ringbuffer_sync();
    rb->writeIdx = (w + itemcount) & rb->_mask;
    return itemcount;
}
