/*******************************************************************************
  External Interrupt Driver — dsPIC33AK1024MPS614
  Hand-written register-level driver (no MCC support yet)

  File:      ext_int.h
  Purpose:   Data-ready interrupt from the ICM-42688-P routed to INT1 via PPS
             remap on RP72 (RE7 on the DIM = MikroBUS A INT pin).

  PPS routing done in system/src/pins.c: RPINR0bits.INT1R = 72;
*******************************************************************************/
#ifndef EXT_INT_H
#define EXT_INT_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Configure INT1: rising edge, priority 4. IRQ remains DISABLED — call
 * EXT_INT1_Enable() when you're ready to receive callbacks.
 * Must be called AFTER PINS_Initialize() (which sets up the PPS remap).
 */
void EXT_INT1_Initialize(void);

/**
 * Register (or clear, with NULL) the callback invoked from the INT1 ISR.
 */
void EXT_INT1_CallbackRegister(void (*handler)(void));

/**
 * Enable / disable the INT1 IRQ (bit `INT1IE`). Also clears any pending flag.
 */
void EXT_INT1_Enable(void);
void EXT_INT1_Disable(void);

#ifdef __cplusplus
}
#endif

#endif /* EXT_INT_H */
