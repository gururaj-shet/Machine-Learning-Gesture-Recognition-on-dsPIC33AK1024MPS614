/*******************************************************************************
  Application-level config for the ML Gesture demo on dsPIC33AK1024MPS614

  File:  app_config.h

  Summary:
    Central configuration for sensor rate/range, ML pipeline sample layout,
    LED behaviour and platform stubs. Mirrors the CK-side app_config.h and is
    intentionally structured so the ML knowledge pack is bit-compatible with
    the CK model (same feature-extractor inputs and units).
*******************************************************************************/
#ifndef APP_CONFIG_H
#define APP_CONFIG_H

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>

/* ---------- IMU sample rate & full-scale ------------------------------ */
/* IMPORTANT: These values MUST match the training data used for the
 * knowledge pack. The CK demo trained at 100 Hz, accel ±2 g, so we keep the
 * same on the AK port. */
#define SNSR_SAMPLE_RATE        100    /* Hz  */
#define SNSR_ACCEL_RANGE        2      /* g   */
#define SNSR_GYRO_RANGE         2000   /* dps (unused when SNSR_USE_GYRO=false) */

/* Enable/disable axes */
#define SNSR_USE_ACCEL          true
#define SNSR_USE_GYRO           false

/* Sensor sample-buffer depth (power of 2, in samples) */
#define SNSR_BUF_LEN            256

/* Base type used for sample words */
#define SNSR_DATA_TYPE          int16_t

/* Samples per stream packet (kept for parity with CK demo) */
#define SNSR_SAMPLES_PER_PACKET 1

/* LED tick rates (ms) used by main.c as state indicators */
#define TICK_RATE_FAST          100u
#define TICK_RATE_SLOW          500u

/* ---------- Derived defines ------------------------------------------- */
#define SNSR_NUM_AXES   (3 * SNSR_USE_ACCEL + 3 * SNSR_USE_GYRO)

#if (SNSR_BUF_LEN % SNSR_SAMPLES_PER_PACKET) > 0
#  error "SNSR_SAMPLES_PER_PACKET must be a factor of SNSR_BUF_LEN"
#endif

/* Timing helpers used by sensor.h weak decls */
extern uint64_t snsr_read_timer_us(void);
extern uint64_t snsr_read_timer_ms(void);
extern void     snsr_sleep_us(uint32_t us);
extern void     snsr_sleep_ms(uint32_t ms);

/* Fixed sensor identity/reporting */
#define SNSR_NAME  "icm42688p"

/* ---------- Platform (AK Curiosity GP DIM) LED aliases ---------------- */
/* The AK BSP exposes LEDs as function-pointer structs (`led3.on()` etc). To
 * keep main.c readable and to preserve the shape of the CK code, provide
 * simple #define aliases that map to those calls.
 *
 * Board mapping (Curiosity Platform + AK GP DIM):
 *   led3 → alive / status
 *   ledRed / ledGreen / ledBlue → RGB LED for gesture indication */
#include "../bsp/led3.h"
#include "../bsp/led_red.h"
#include "../bsp/led_green.h"
#include "../bsp/led_blue.h"

#define LED_STATUS_On()     do { led3.on();       } while (0)
#define LED_STATUS_Off()    do { led3.off();      } while (0)
#define LED_STATUS_Toggle() do { led3.toggle();   } while (0)

#define LED_GREEN_On()      do { ledGreen.on();   } while (0)
#define LED_GREEN_Off()     do { ledGreen.off();  } while (0)
#define LED_GREEN_Toggle()  do { ledGreen.toggle(); } while (0)

#define LED_RED_On()        do { ledRed.on();     } while (0)
#define LED_RED_Off()       do { ledRed.off();    } while (0)
#define LED_RED_Toggle()    do { ledRed.toggle(); } while (0)

#define LED_BLUE_On()       do { ledBlue.on();    } while (0)
#define LED_BLUE_Off()      do { ledBlue.off();   } while (0)
#define LED_BLUE_Toggle()   do { ledBlue.toggle(); } while (0)

#define LED_ALL_Off()   do { LED_STATUS_Off(); LED_RED_Off(); \
                             LED_GREEN_Off();  LED_BLUE_Off(); } while (0)

/* Convenience typedefs used by main / ringbuffer wiring */
typedef SNSR_DATA_TYPE snsr_data_t;
typedef SNSR_DATA_TYPE snsr_dataframe_t[SNSR_NUM_AXES];
typedef SNSR_DATA_TYPE snsr_datapacket_t[SNSR_NUM_AXES * SNSR_SAMPLES_PER_PACKET];

#endif /* APP_CONFIG_H */
