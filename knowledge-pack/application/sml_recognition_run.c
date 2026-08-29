/*  MPLAB ML — model runner (identical logic to the CK demo).
 *  The compiled `libmplabml.a` / source-format .c files supply kb_run_model()
 *  and kb_reset_model(); regenerate the pack targeting dsPIC33AK when
 *  producing the deliverable — the CK-built archive is XC16 (16-bit ISA)
 *  and will NOT link with XC-DSC (32-bit dsPIC33A ISA).
 */
#include "kb.h"
#include "kb_output.h"
#include "sml_recognition_run.h"

#include <string.h>
#include <stdio.h>
#include <stdbool.h>

#define KB_MODEL_INDEX 0

#define SERIAL_OUT_CHARS_MAX 256
static char serial_out_buf[SERIAL_OUT_CHARS_MAX];

__attribute__((unused))
static void sml_output_results(uint16_t model, uint16_t classification)
{
    memset(serial_out_buf, 0, SERIAL_OUT_CHARS_MAX);
    kb_sprint_model_result(model, serial_out_buf, false, false, true);
    printf("%s\r\n", serial_out_buf);
}

int32_t sml_recognition_run(int16_t *data, int32_t num_sensors)
{
    int32_t ret = kb_run_model(data, num_sensors, KB_MODEL_INDEX);
    if (ret >= 0) {
        /* Verbose per-classification serial output. Include the JSON detail
         * (Distance/Threshold via include_debug=1) so we can see how close
         * each window falls to its nearest centroid. */
        char buf[256];
        kb_sprint_model_result(KB_MODEL_INDEX, buf, 0, 1, 1);
        printf("%s", buf);
        kb_reset_model(KB_MODEL_INDEX);
    }
    return ret;
}
