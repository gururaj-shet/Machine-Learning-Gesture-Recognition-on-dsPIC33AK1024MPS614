/*******************************************************************************
  ML Gesture Recognition demo — dsPIC33AK1024MPS614 GP DIM port

  File:  main.c

  Summary:
    Direct port of the dsPIC33CK ML gesture-recognition demo main loop to the
    dsPIC33AK1024MPS614 Curiosity GP DIM on the Curiosity Platform
    Development Board, using the MikroE 6DOF IMU 14 Click (ICM-42688-P).

  Behaviour:
    - Initialises system (MCC Melody) + BSP (LEDs, buttons, console).
    - Configures the ICM-42688-P over SPI at 100 Hz, ±2 g, accelerometer
      only. INT1 (Mikrobus INT pin) fires data-ready.
    - Data-ready IRQ pushes one 3-axis sample into a ring buffer.
    - Foreground loop pops frames, runs the MPLAB ML knowledge-pack
      classifier, applies a 3-of-5 majority-vote post-filter, and drives
      LEDs/UART with the winning gesture ID.

  Board wiring (Curiosity Platform Mikrobus 1):
    | Mikrobus pin  | AK DIM signal (see DIM info sheet) | Peripheral        |
    |---------------|-------------------------------------|-------------------|
    | MISO/SDO      | SPI1 SDI                            | SPI1_Host         |
    | MOSI/SDI      | SPI1 SDO                            | SPI1_Host         |
    | SCK           | SPI1 SCK                            | SPI1_Host         |
    | CS            | GPIO — user pin, named MIKRO1_CS    | GPIO out          |
    | INT           | GPIO — INT1 external interrupt      | ExtINT / CN       |
    | RST           | (unused)                            | —                 |
    | 3V3 / GND     | Bus power                           | —                 |

  Notes:
    - Verify MikroBus 1 socket signal → dsPIC AK pin mapping against the
      "dsPIC33A Curiosity Platform Development Board User Guide (Draft)"
      before flashing hardware.
    - Refer to docs/MCC_MELODY_CONFIG.md for the exact MCC Melody
      configuration to reproduce.
*******************************************************************************/

#include <xc.h>            /* for Nop() intrinsic */
#include <stddef.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "mcc_generated_files/system/system.h"
#include "mcc_generated_files/timer/tmr1.h"
#include "mcc_generated_files/uart/uart1.h"
#include "mcc_generated_files/interrupt/ext_int.h"

/* Application layer */
#include "../../app/app_config.h"
#include "../../app/ringbuffer.h"
#include "../../app/sensor.h"

/* MPLAB ML knowledge-pack */
#include "kb.h"
#include "sml_output.h"
#include "sml_recognition_run.h"

/* BSP */
#include "../../bsp/task.h"
#include "../../console.h"

/* ============================================================
   1 ms tick + timing helpers (weak-linked stubs referenced in
   sensor.h; here we provide the strong definitions).
   ============================================================ */
static volatile uint32_t g_tick_ms   = 0;
static volatile uint16_t g_led_rate  = 0;

uint64_t snsr_read_timer_ms(void) { return g_tick_ms; }
uint64_t snsr_read_timer_us(void) { return (uint64_t)g_tick_ms * 1000ULL; }

/* Coarse busy-wait using TMR1 tick — good enough for msec-scale IMU init. */
void snsr_sleep_ms(uint32_t ms)
{
    uint32_t start = g_tick_ms;
    while ((uint32_t)(g_tick_ms - start) < ms) { Nop(); }
}
void snsr_sleep_us(uint32_t us)
{
    /* At Fcy = 200 MHz, ~200 cycles/us — coarse fallback for short delays. */
    volatile uint32_t n = us * 40u;
    while (n--) { Nop(); }
}

/* ============================================================
   TMR1 tick handler — 1 ms base
   ============================================================ */
static void app_tick_handler(void)
{
    static uint32_t led_counter = 0;

    ++g_tick_ms;

    /* Task scheduler entry (BSP task.c) */
    TASK_InterruptHandler();

    if (g_led_rate == 0) {
        led_counter = 0;
    } else if (++led_counter >= g_led_rate) {
        LED_STATUS_Toggle();
        led_counter = 0;
    }
}

/* ============================================================
   Sensor sample buffer + data-ready ISR
   ============================================================ */
static struct sensor_device_t   g_sensor;
static snsr_data_t              g_snsr_buffer_data[SNSR_BUF_LEN][SNSR_NUM_AXES];
static ringbuffer_t             g_snsr_buffer;
static volatile bool            g_snsr_overrun = false;

/* Hook this from MCC's INT1 external-interrupt callback (see
 * MCC_MELODY_CONFIG.md). If your MCC-generated name differs (e.g.
 * `Ext_INT1_InterruptHandler` / `EXT_INT1_CallbackRegister`), simply
 * register `imu_drdy_isr` as its callback. */
volatile uint32_t g_isr_count = 0;   /* diagnostic: DRDY ISR entries */

void imu_drdy_isr(void)
{
    g_isr_count++;

    if ((g_sensor.status != SNSR_STATUS_OK) || g_snsr_overrun) return;

    ringbuffer_size_t writable;
    snsr_data_t *dst = ringbuffer_get_write_buffer(&g_snsr_buffer, &writable);

    if (writable == 0) {
        g_snsr_overrun = true;
        return;
    }
    g_sensor.status = sensor_read(&g_sensor, dst);
    if (g_sensor.status == SNSR_STATUS_OK) {
        ringbuffer_advance_write_index(&g_snsr_buffer, 1);
    }
}

/* ============================================================
   Majority-vote gesture post-filter (identical to CK demo)
   ============================================================ */
#define NUM_CLASSES     5
#define NUM_VOTES       5
#define MAJORITY_VOTES  ((NUM_VOTES + 1) / 2)

static const char *gesture_name(int clsid)
{
    switch (clsid) {
        case 0:  return "unknown";
        case 1:  return "idle";
        case 2:  return "up-down";
        case 3:  return "wave";
        case 4:  return "wheel";
        default: return "?";
    }
}

/* ============================================================
   Main
   ============================================================ */
int main(void)
{
    int   app_failed = 1;
    int   clsid = 1;
    int   votehist[NUM_VOTES]   = { 1 };
    int   votecounts[NUM_CLASSES] = { 0 };

    /* System init (clock, pins, TMR1, UART1, SPI1, INT1, …) */
    TASK_Initialize();
    SYSTEM_Initialize();

    /* Register 1 ms tick */
    TMR1_TimeoutCallbackRegister(app_tick_handler);
    TMR1_Start();

    /* Bring up the console */
    console.initialize(&UART1_Drv);
    console.clear();
    printf("\r\n=== dsPIC33AK1024MPS614 Gesture Recognition ===\r\n");
    printf("Sensor: %s @ %d Hz, accel=%d g, gyro=%d dps\r\n",
           SNSR_NAME, SNSR_SAMPLE_RATE, SNSR_ACCEL_RANGE, SNSR_GYRO_RANGE);

    /* Application init sequence */
    while (1) {
        if (ringbuffer_init(&g_snsr_buffer, g_snsr_buffer_data,
                            SNSR_BUF_LEN, sizeof(g_snsr_buffer_data[0]))) {
            printf("ERROR: ringbuffer_init failed\r\n");
            break;
        }

        if (sensor_init(&g_sensor) != SNSR_STATUS_OK) {
            printf("ERROR: sensor_init returned %d\r\n", g_sensor.status);
            break;
        }
        if (sensor_set_config(&g_sensor) != SNSR_STATUS_OK) {
            printf("ERROR: sensor_set_config returned %d\r\n", g_sensor.status);
            break;
        }
        printf("ICM-42688-P initialised OK\r\n");

        /* Wire the ICM-42688-P DRDY line (INT1) to imu_drdy_isr. Without this
         * the ring buffer never gets samples and no classifications happen. */
        EXT_INT1_CallbackRegister(imu_drdy_isr);
        EXT_INT1_Enable();

        /* Diagnostic: dump key sensor registers to confirm configure() actually
         * programmed the chip. Expect (per icm42688_configure):
         *   WHO_AM_I     = 0x47
         *   PWR_MGMT0    = 0x2F  (temp dis + accel LN + gyro LN)
         *   INT_CONFIG   = 0x03  (INT1 push-pull, active-hi, pulsed)
         *   INT_SOURCE0  = 0x08  (UI_DRDY_INT1_EN)
         *   INT_STATUS   = varies; bit3 (DATA_RDY) should toggle if DRDY works
         *   ACCEL_CONFIG0= 0x68  (FS=2g=3<<5, ODR=100Hz=0x08)  */
        {
            #include "../../app/icm42688p_regs.h"
            #include "../../app/mikro_spi.h"
            uint8_t r;
            uint8_t regs[] = { 0x75, 0x4E, 0x14, 0x65, 0x2D, 0x50 };
            const char *names[] = {
                "WHO_AM_I", "PWR_MGMT0", "INT_CONFIG",
                "INT_SOURCE0", "INT_STATUS", "ACCEL_CONFIG0"
            };
            for (int i = 0; i < 6; i++) {
                mikro_spi_read(0, regs[i], &r, 1);
                printf("  %-14s (0x%02X) = 0x%02X\r\n", names[i], regs[i], r);
            }
        }

        /* Knowledge pack init */
        kb_model_init();
        sml_output_init(NULL);

        const uint8_t *p = kb_get_model_uuid_ptr(0);
        printf("KP UUID: ");
        for (int i = 0; i < 16; i++) {
            printf("%02x", p[i]);
            if (i == 3 || i == 5 || i == 7 || i == 9) printf("-");
        }
        printf("\r\n");

        /* Ready state */
        g_led_rate = 0;
        LED_ALL_Off();
        LED_STATUS_On();
        g_led_rate = TICK_RATE_SLOW;

        app_failed = 0;
        break;
    }

    /* Main inference loop */
    uint32_t last_diag_ms = 0;
    uint32_t last_isr_seen = 0;
    while (!app_failed) {
        if (g_sensor.status != SNSR_STATUS_OK) {
            printf("ERROR: bad sensor status %d — halting\r\n", g_sensor.status);
            break;
        }

        /* Diagnostic heartbeat: every 1 s report ISR count delta + ring
         * buffer occupancy + raw INT1 pin state (RE7). */
        if ((uint32_t)(g_tick_ms - last_diag_ms) >= 1000u) {
            last_diag_ms = g_tick_ms;
            ringbuffer_size_t rd_avail = 0;
            (void)ringbuffer_get_read_buffer(&g_snsr_buffer, &rd_avail);
            printf("diag isr=%lu (+%lu) rb=%u int1_pin=%u\r\n",
                   (unsigned long)g_isr_count,
                   (unsigned long)(g_isr_count - last_isr_seen),
                   (unsigned)rd_avail,
                   (unsigned)PORTEbits.RE7);
            last_isr_seen = g_isr_count;
        }

        if (g_snsr_overrun) {
            printf("!! sample buffer overrun — resetting\r\n");
            g_led_rate = 0;
            LED_ALL_Off();
            LED_RED_On();
            LED_STATUS_On();
            snsr_sleep_ms(2000);
            LED_ALL_Off();
            ringbuffer_reset(&g_snsr_buffer);
            g_snsr_overrun = false;
            g_led_rate = TICK_RATE_SLOW;
            continue;
        }

        ringbuffer_size_t readable;
        const snsr_dataframe_t *frame =
            (const snsr_dataframe_t *)ringbuffer_get_read_buffer(&g_snsr_buffer, &readable);

        while (readable--) {
            int cls = sml_recognition_run((snsr_data_t *)frame, SNSR_NUM_AXES);
            ringbuffer_advance_read_index(&g_snsr_buffer, 1);
            frame++;

            if (cls < 0) continue;

            /* Rolling-window majority vote */
            votecounts[votehist[0]]--;
            for (int i = 1; i < NUM_VOTES; i++) {
                votehist[i - 1] = votehist[i];
            }
            votehist[NUM_VOTES - 1] = cls;
            votecounts[cls]++;

            if (cls != clsid) {
                int maxval = -1, maxcls = -1;
                for (int i = 0; i < NUM_CLASSES; i++) {
                    if (votecounts[i] > maxval) {
                        maxval = votecounts[i];
                        maxcls = i;
                    }
                }
                if ((maxval >= (int)MAJORITY_VOTES) && (maxcls != clsid)) {
                    clsid = maxcls;
                    g_led_rate = 0;
                    LED_ALL_Off();
                    switch (clsid) {
                        case 1: LED_GREEN_On(); break;      /* idle  */
                        case 2: g_led_rate = 100u; break;   /* up-down */
                        case 3: g_led_rate = 1000u; break;  /* wave  */
                        case 4: g_led_rate = 600u; break;   /* wheel */
                        default: g_led_rate = TICK_RATE_SLOW; break;
                    }
                    printf("Gesture: %s\r\n", gesture_name(clsid));
                }
            }
            kb_reset_model(0);
        }
    }

    /* Fatal-error indicator */
    g_led_rate = 0;
    LED_ALL_Off();
    LED_RED_On();
    while (1) { Nop(); }
    return EXIT_FAILURE;
}
