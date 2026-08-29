/*******************************************************************************
  Sensor abstraction — AK port (ICM-42688-P only).
*******************************************************************************/
#ifndef SENSOR_H
#define SENSOR_H

#include <stdint.h>
#include "sensor_config.h"
#include "icm42688p.h"

/* Success code used by main.c to gate on any status returned by adapter. */
#define SNSR_STATUS_OK ICM42688_OK

#define SNSR_COM_BUF_SIZE   64u

#ifdef __cplusplus
extern "C" {
#endif

struct sensor_device_t {
    struct icm42688_dev device;
    volatile int        status;
};

/* Weakly-linked timing helpers (provided by main.c). */
extern uint64_t __attribute__((weak)) snsr_read_timer_ms(void);
extern uint64_t __attribute__((weak)) snsr_read_timer_us(void);
extern void     __attribute__((weak)) snsr_sleep_ms(uint32_t ms);
extern void     __attribute__((weak)) snsr_sleep_us(uint32_t us);

/* Prototypes (resolved via sensor_config.h #defines to icm42688_sensor_*). */
int icm42688_sensor_init      (struct sensor_device_t *s);
int icm42688_sensor_set_config(struct sensor_device_t *s);
int icm42688_sensor_read      (struct sensor_device_t *s, snsr_data_t *ptr);

#ifdef __cplusplus
}
#endif

#endif /* SENSOR_H */
