/*  MPLAB ML — classification result JSON emitter (identical to CK demo).
 *  Uses printf(), which is redirected to UART1 by MCC's `_write` hook or
 *  the standard MPLAB Melody stdio adapter. If MCC hasn't wired stdio to
 *  UART1, either enable "Redirect STDIO to UART" in the UART1 module or
 *  implement _write() to call UART1_Write() for each byte.
 */
#include "sml_output.h"
#include "kb.h"

#include <string.h>
#include <stdio.h>
#include <stdint.h>

#define SERIAL_OUT_CHARS_MAX 512

static char    serial_out_buf[SERIAL_OUT_CHARS_MAX];
static uint8_t recent_fv[MAX_VECTOR_SIZE];
static uint8_t recent_fv_len;
static uint8_t write_features = 0;

void sml_output_results(uint16_t model, uint16_t classification)
{
    int32_t written = 0;
    memset(serial_out_buf, 0, SERIAL_OUT_CHARS_MAX);

    written += snprintf(serial_out_buf, sizeof(serial_out_buf) - 1,
                        "{\"ModelNumber\":%d,\"Classification\":%d",
                        model, classification);

    if (write_features) {
        written += snprintf(&serial_out_buf[written],
                            sizeof(serial_out_buf) - written,
                            ",\"FeatureLength\":%d,\"FeatureVector\":[",
                            recent_fv_len);
        for (int32_t j = 0; j < recent_fv_len; j++) {
            written += snprintf(&serial_out_buf[written],
                                sizeof(serial_out_buf) - written,
                                "%d", recent_fv[j]);
            if (j < recent_fv_len - 1) {
                serial_out_buf[written++] = ',';
            }
        }
        serial_out_buf[written++] = ']';
    }
    serial_out_buf[written++] = '}';

    printf("%s\r\n", serial_out_buf);
}

uint32_t sml_output_init(void *p_module)
{
    (void)p_module;
    return 0;
}
