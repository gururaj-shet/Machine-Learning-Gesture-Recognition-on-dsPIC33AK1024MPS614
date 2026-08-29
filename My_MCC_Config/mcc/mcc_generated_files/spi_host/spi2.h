/*******************************************************************************
  SPI2 Host Driver — dsPIC33AK1024MPS614
  Hand-written register-level driver (no MCC support available yet)

  File:      spi2.h
  Target:    dsPIC33AK1024MPS614 GP DIM on Curiosity Platform (EV74H48A)
  Bus:       MikroBUS A -> ICM-42688-P on 6DOF IMU 14 Click
  Reference: DIM info-sheet Table 1-1 confirms
             SCK2 -> RB10 (dev pin 72), SDI2 -> RB11 (dev pin 73),
             SDO2 -> RC9  (dev pin 83)

  Mode:      SPI Host, 8-bit, Mode 0 (CPOL=0, CPHA=0), MSB first
  Baud:      ~3.85 MHz  (SPI2BRG = 12, Fp = 100 MHz -> Fsck = Fp/(2*(BRG+1)))
  SS:        Software (Mikrobus CS handled by mikro_spi.c via GPIO)

  These functions are intentionally polled/blocking to match the polled-DRDY
  ICM-42688-P driver in app/icm42688p.c.
*******************************************************************************/
#ifndef SPI2_H
#define SPI2_H

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Initialise SPI2 as a host: Mode 0, 8-bit, ~3.85 MHz, software SS.
 * Call once from SYSTEM_Initialize() after PINS_Initialize().
 */
void SPI2_Initialize(void);

/**
 * De-initialise SPI2 (disable module, restore reset values).
 */
void SPI2_Deinitialize(void);

/**
 * Exchange one byte over SPI2 (write TX, read RX).
 * Blocks until the transfer completes.
 *
 * @param  tx       Byte to transmit
 * @param  rx       [out] Byte received (may be NULL to discard)
 */
void SPI2_ByteExchange(uint8_t tx, uint8_t *rx);

/**
 * Convenience: exchange a byte and return the received value directly.
 */
uint8_t SPI2_ExchangeByte(uint8_t tx);

/**
 * Return true if the SPI transmit buffer can accept another byte.
 */
bool SPI2_IsTxReady(void);

/**
 * Return true if a received byte is waiting to be read.
 */
bool SPI2_IsRxReady(void);

#ifdef __cplusplus
}
#endif

#endif /* SPI2_H */
