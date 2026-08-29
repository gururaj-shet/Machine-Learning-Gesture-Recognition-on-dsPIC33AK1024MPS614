#ifndef SML_OUTPUT_H
#define SML_OUTPUT_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

uint32_t sml_output_init(void *p_module);
void     sml_output_results(uint16_t model, uint16_t classification);

#ifdef __cplusplus
}
#endif

#endif /* SML_OUTPUT_H */
