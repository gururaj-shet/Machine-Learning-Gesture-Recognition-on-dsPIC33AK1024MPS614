/*******************************************************************************
  Mikrobus SPI wrapper for dsPIC33AK1024MPS614 GP DIM

  File:       mikro_spi.h

  Summary:
    Thin binding between the ICM-42688-P driver's serif callbacks and the MCC
    Melody-generated SPI1 driver on the AK Curiosity Platform. Manages the
    Mikrobus 1 CS GPIO and the SPI read/write direction bit.

  Prerequisites (configure in MCC Melody):
    - SPI1 module present. Custom name may remain "SPI1_Host"; the wrapper
      only requires the following symbols from `spi1.h` (or your named
      instance):
          void  SPI1_ByteExchange (uint8_t data, uint8_t *received);
          void  SPI1_Initialize   (void);
      If your MCC output exposes different names, adjust the two calls in
      mikro_spi.c accordingly.
    - Mikrobus 1 CS pin configured as digital output, custom name
      `MIKRO1_CS` (macros `MIKRO1_CS_SetHigh()` / `MIKRO1_CS_SetLow()` will
      be produced automatically in `system/pins.h`).
    - SPI clock ≤ 24 MHz, CPOL=0 CPHA=0 (Mode 0), MSB first, 8-bit.

  NOTE: The ICM-42688-P sits at the receiving end of a 4-wire SPI bus and does
        NOT tolerate CS staying low across multiple transactions (it uses
        rising CS edge to reset internal state); the wrapper always brackets
        one transaction with CS low → transfer → CS high.
*******************************************************************************/
#ifndef MIKRO_SPI_H
#define MIKRO_SPI_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Read `len` bytes from ICM-42688-P register `reg` (7-bit).
 * Returns 0 on success. */
int mikro_spi_read (void *ctx, uint8_t reg, uint8_t *dst,       uint16_t len);

/* Write `len` bytes to ICM-42688-P register `reg` (7-bit).
 * The device auto-increments its register pointer within one CS window.
 * Returns 0 on success. */
int mikro_spi_write(void *ctx, uint8_t reg, const uint8_t *src, uint16_t len);

/* Retrieve pre-built serif for the ICM driver (delay hooks default to weak
 * `snsr_sleep_us/ms` provided by main). */
struct icm42688_serif;
const struct icm42688_serif *mikro_spi_get_serif(void);

#ifdef __cplusplus
}
#endif

#endif /* MIKRO_SPI_H */
