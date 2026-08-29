/*******************************************************************************
  Ring buffer — portable, single-writer / single-reader.
  Ported from the dsPIC33CK gesture demo; XC-DSC / dsPIC33A branch added.

  Notes:
    - Length must be a power of two.
    - This API is safe for exactly one producer thread and one consumer thread.
      Any other use pattern requires external synchronisation.
*******************************************************************************/
#ifndef RINGBUFFER_H
#define RINGBUFFER_H

#include <stddef.h>
#include <stdint.h>

/* Compiler/memory fence primitive */
#if defined(__GNUC__)
#   if defined(__arm__)
#       define __ringbuffer_sync() __asm__ volatile ("dsb" ::: "memory")
#   else
        /* On dsPIC (XC16, XC-DSC) and other in-order architectures a compiler
         * barrier is sufficient. */
#       define __ringbuffer_sync() __asm__ volatile ("" ::: "memory")
#   endif
#else
#   define __ringbuffer_sync() do {} while (0)
#endif

#ifdef __cplusplus
extern "C" {
#endif

/* Choose the largest atomic-access integer for the platform */
#if defined(__AVR__) || defined(__XC8)
typedef uint8_t  ringbuffer_size_t;
#elif defined(__XC16) || defined(__dsPIC30__)
typedef uint16_t ringbuffer_size_t;    /* dsPIC33C (16-bit) */
#elif defined(__XC_DSC__) || defined(__dsPIC33A__)
typedef uint32_t ringbuffer_size_t;    /* dsPIC33A (32-bit) */
#elif defined(__arm__) || defined(__XC32)
typedef uint32_t ringbuffer_size_t;
#else
typedef uint32_t ringbuffer_size_t;
#endif

#define RINGBUFFER_MAX_SIZE \
        ((((ringbuffer_size_t) ~((ringbuffer_size_t) 0)) >> 1) + 1)

typedef struct ring_buffer {
    volatile ringbuffer_size_t writeIdx;
    volatile ringbuffer_size_t readIdx;
    ringbuffer_size_t          len;
    size_t                     itemsize;
    ringbuffer_size_t          _mask;
    uint8_t                   *data;
} ringbuffer_t;

int8_t              ringbuffer_init             (ringbuffer_t *, void *buf, ringbuffer_size_t len, size_t itemsize);
void                ringbuffer_reset            (ringbuffer_t *);
ringbuffer_size_t   ringbuffer_read             (ringbuffer_t *, void *dst, ringbuffer_size_t itemcount);
ringbuffer_size_t   ringbuffer_write            (ringbuffer_t *, const void *src, ringbuffer_size_t itemcount);
ringbuffer_size_t   ringbuffer_get_read_items   (ringbuffer_t *);
ringbuffer_size_t   ringbuffer_get_write_items  (ringbuffer_t *);
const void *        ringbuffer_get_read_buffer  (ringbuffer_t *, ringbuffer_size_t *itemcount);
void *              ringbuffer_get_write_buffer (ringbuffer_t *, ringbuffer_size_t *itemcount);
ringbuffer_size_t   ringbuffer_advance_write_index(ringbuffer_t *, ringbuffer_size_t itemcount);
ringbuffer_size_t   ringbuffer_advance_read_index (ringbuffer_t *, ringbuffer_size_t itemcount);

#ifdef __cplusplus
}
#endif

#endif /* RINGBUFFER_H */
