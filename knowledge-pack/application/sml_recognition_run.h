/*  Wraps kb_run_model() for one model, allowing main.c to stay decoupled
 *  from knowledge-pack model indices. */
#ifndef SML_RECOGNITION_RUN_H
#define SML_RECOGNITION_RUN_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

int32_t sml_recognition_run(int16_t *data, int32_t num_sensors);

#ifdef __cplusplus
}
#endif

#endif /* SML_RECOGNITION_RUN_H */
