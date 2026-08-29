/*******************************************************************************
  Mikrobus SPI wrapper for dsPIC33AK1024MPS614 GP DIM
  See mikro_spi.h for description.
*******************************************************************************/
#include "mikro_spi.h"
#include "icm42688p.h"
#include "icm42688p_regs.h"

/* Hand-written SPI2 driver (see mcc_generated_files/spi_host/spi2.[ch]).
 * SPI2 hardware is used because its fixed-function pins SCK2/SDI2/SDO2
 * (RB10/RB11/RC9) align with the MikroBUS A socket on the AK GP DIM. */
#include "../My_MCC_Config/mcc/mcc_generated_files/spi_host/spi2.h"
#include "../My_MCC_Config/mcc/mcc_generated_files/system/pins.h"

/* Forward declarations of user-supplied timing helpers. Defined weak in main.c
 * so the SPI wrapper links even without them (they aren't strictly required
 * for the SPI transfer itself). */
extern void snsr_sleep_us(uint32_t us) __attribute__((weak));
extern void snsr_sleep_ms(uint32_t ms) __attribute__((weak));

/* ----- Low-level byte transfer ------------------------------------------- */
static inline uint8_t spi_xfer_byte(uint8_t tx)
{
    uint8_t rx = 0;
    SPI2_ByteExchange(tx, &rx);
    return rx;
}

static inline void cs_low (void) { MIKRO1_CS_SetLow();  }
static inline void cs_high(void) { MIKRO1_CS_SetHigh(); }

/* ----- Public API -------------------------------------------------------- */
int mikro_spi_read(void *ctx, uint8_t reg, uint8_t *dst, uint16_t len)
{
    (void)ctx;
    if ((dst == 0) || (len == 0)) return -1;

    cs_low();
    (void)spi_xfer_byte((uint8_t)(reg | ICM42688_SPI_READ_MASK));
    for (uint16_t i = 0; i < len; i++) {
        dst[i] = spi_xfer_byte(0xFF);
    }
    cs_high();
    return 0;
}

int mikro_spi_write(void *ctx, uint8_t reg, const uint8_t *src, uint16_t len)
{
    (void)ctx;
    if ((src == 0) || (len == 0)) return -1;

    cs_low();
    (void)spi_xfer_byte((uint8_t)(reg & 0x7F));
    for (uint16_t i = 0; i < len; i++) {
        (void)spi_xfer_byte(src[i]);
    }
    cs_high();
    return 0;
}

static const struct icm42688_serif l_serif = {
    .context   = 0,
    .read_reg  = mikro_spi_read,
    .write_reg = mikro_spi_write,
    .delay_us  = snsr_sleep_us,
    .delay_ms  = snsr_sleep_ms
};

const struct icm42688_serif *mikro_spi_get_serif(void)
{
    return &l_serif;
}
