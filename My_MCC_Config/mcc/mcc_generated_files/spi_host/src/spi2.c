/*******************************************************************************
  SPI2 Host Driver — dsPIC33AK1024MPS614 (see spi2.h)
*******************************************************************************/
#include <xc.h>
#include "../spi2.h"

/*
 * SPI2CON1 configuration for this application:
 *   Bit  5  MSTEN  = 1   Master mode
 *   Bit  6  CKP    = 0   Idle-low clock (SPI Mode 0)
 *   Bit  8  CKE    = 1   Data transitions on active-to-idle edge (SPI Mode 0)
 *   Bit  9  SMP    = 1   Sample input at end of data output (host mode)
 *   Bits 10..11    = 0   MODE16=0, MODE32=0 -> 8-bit words
 *   Bit  7  SSEN   = 0   Software slave-select (we drive CS from GPIO)
 *   Bit 15  ON     = 1   Module enable
 * All other bits left at reset (0).
 *
 *  0x8000  ON
 *  0x0100  CKE
 *  0x0200  SMP
 *  0x0020  MSTEN
 * -------
 *  0x8320
 */
#define SPI2_CON1_HOST_MODE0_8BIT   (0x00008320UL)

/*
 * SPI2BRG: Fsck = Fp / (2 * (BRG + 1))
 *   Fp = 100 MHz (standard peripheral clock, see clock.c)
 *   BRG = 12 -> Fsck = 100e6 / 26 = ~3.846 MHz
 * ICM-42688-P tolerates up to 24 MHz; we start conservatively.
 */
#define SPI2_BRG_4MHZ               (12UL)

void SPI2_Initialize(void)
{
    /* Disable module before reconfiguration */
    SPI2CON1 = 0x0UL;
    SPI2CON2 = 0x0UL;
    SPI2STAT = 0x0UL;
    SPI2BRG  = SPI2_BRG_4MHZ;

    /* Ensure IRQs disabled (this driver is polled).
     * On the AK the SPI2 interrupt bits live in IEC2 / IFS2 / IPC8 (verified
     * against the DFP EDC for dsPIC33AK1024MPS614). */
    IEC2bits.SPI2RXIE = 0;
    IEC2bits.SPI2TXIE = 0;
    IEC2bits.SPI2EIE  = 0;
    IFS2bits.SPI2RXIF = 0;
    IFS2bits.SPI2TXIF = 0;
    IFS2bits.SPI2EIF  = 0;

    /* Apply configuration and enable */
    SPI2CON1 = SPI2_CON1_HOST_MODE0_8BIT;
}

void SPI2_Deinitialize(void)
{
    SPI2CON1bits.ON = 0;
    SPI2CON1 = 0x0UL;
    SPI2CON2 = 0x0UL;
    SPI2STAT = 0x0UL;
    SPI2BRG  = 0x0UL;
}

bool SPI2_IsTxReady(void)
{
    /* SPITBF = 1 when transmit shift register / buffer cannot accept another byte */
    return (SPI2STATbits.SPITBF == 0);
}

bool SPI2_IsRxReady(void)
{
    /* SPIRBE = 1 when receive buffer is empty; ready = !empty */
    return (SPI2STATbits.SPIRBE == 0);
}

void SPI2_ByteExchange(uint8_t tx, uint8_t *rx)
{
    volatile uint32_t discard;

    /* Drain any stale RX byte (belt-and-braces after CS-idle transitions) */
    while (SPI2STATbits.SPIRBE == 0) {
        discard = SPI2BUF;
        (void)discard;
    }

    /* Wait until TX buffer can accept a new byte */
    while (SPI2STATbits.SPITBF == 1) { /* spin */ }

    /* Write byte (only low 8 bits carry data in 8-bit mode) */
    SPI2BUF = (uint32_t)tx;

    /* Wait until RX buffer holds the returned byte */
    while (SPI2STATbits.SPIRBE == 1) { /* spin */ }

    /* Read RX (also clears SPIRBE) */
    uint8_t v = (uint8_t)(SPI2BUF & 0xFFU);
    if (rx != NULL) { *rx = v; }
}

uint8_t SPI2_ExchangeByte(uint8_t tx)
{
    uint8_t rx = 0;
    SPI2_ByteExchange(tx, &rx);
    return rx;
}
