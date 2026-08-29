/*******************************************************************************
  ICM-42688-P Minimal Driver — Implementation

  Company:    Microchip Technology Inc.
  File:       icm42688p.c

  See icm42688p.h for API and the register map in icm42688p_regs.h.
*******************************************************************************/
#include "icm42688p.h"
#include "icm42688p_regs.h"

/* ============================================================
   Low-level register access
   ============================================================ */
icm42688_status_t icm42688_read_reg(struct icm42688_dev *dev,
                                    uint8_t reg, uint8_t *dst, uint16_t len)
{
    if ((dev == 0) || (dev->serif == 0) || (dev->serif->read_reg == 0)) {
        return ICM42688_E_ARG;
    }
    /* Direction bit is set inside the SPI wrapper (caller of this function). */
    return (dev->serif->read_reg(dev->serif->context, reg, dst, len) == 0)
             ? ICM42688_OK : ICM42688_E_BUS;
}

icm42688_status_t icm42688_write_reg(struct icm42688_dev *dev,
                                     uint8_t reg, uint8_t val)
{
    if ((dev == 0) || (dev->serif == 0) || (dev->serif->write_reg == 0)) {
        return ICM42688_E_ARG;
    }
    return (dev->serif->write_reg(dev->serif->context, reg, &val, 1) == 0)
             ? ICM42688_OK : ICM42688_E_BUS;
}

static inline void icm42688_delay_us(struct icm42688_dev *dev, uint32_t us)
{
    if (dev->serif->delay_us) dev->serif->delay_us(us);
}

static inline void icm42688_delay_ms(struct icm42688_dev *dev, uint32_t ms)
{
    if (dev->serif->delay_ms) dev->serif->delay_ms(ms);
}

/* Ensure we are in bank 0 (all runtime registers used are bank 0). */
static icm42688_status_t icm42688_select_bank0(struct icm42688_dev *dev)
{
    return icm42688_write_reg(dev, ICM42688_REG_REG_BANK_SEL, ICM42688_BANK_0);
}

/* ============================================================
   Init: soft reset, verify WHO_AM_I, put device into known state
   ============================================================ */
icm42688_status_t icm42688_init(struct icm42688_dev *dev,
                                const struct icm42688_serif *serif)
{
    icm42688_status_t rc;
    uint8_t whoami = 0;
    uint8_t int_status;
    int i;

    if ((dev == 0) || (serif == 0) ||
        (serif->read_reg == 0) || (serif->write_reg == 0)) {
        return ICM42688_E_ARG;
    }

    dev->serif = serif;
    dev->accel_fs = ICM42688_ACCEL_RANGE_2G;
    dev->gyro_fs  = ICM42688_GYRO_RANGE_2000DPS;
    dev->odr      = ICM42688_ODR_100HZ;
    dev->accel_enabled = false;
    dev->gyro_enabled  = false;

    /* Datasheet §14.36: after power-up, wait ≥1 ms before first access */
    icm42688_delay_ms(dev, 3);

    /* Select bank 0 */
    rc = icm42688_select_bank0(dev);
    if (rc != ICM42688_OK) return rc;

    /* Soft reset (DEVICE_CONFIG.SOFT_RESET_CONFIG = 1) */
    rc = icm42688_write_reg(dev, ICM42688_REG_DEVICE_CONFIG,
                            ICM42688_DEVICE_CONFIG_SOFT_RESET);
    if (rc != ICM42688_OK) return rc;

    /* Reset takes 1 ms (datasheet) — poll RESET_DONE (INT_STATUS bit 4) */
    icm42688_delay_ms(dev, 2);
    for (i = 0; i < 50; i++) {
        rc = icm42688_read_reg(dev, ICM42688_REG_INT_STATUS, &int_status, 1);
        if (rc != ICM42688_OK) return rc;
        if (int_status & ICM42688_INT_STATUS_RESET_DONE) break;
        icm42688_delay_ms(dev, 1);
    }
    if (i == 50) return ICM42688_E_TIMEOUT;

    /* WHO_AM_I check */
    rc = icm42688_read_reg(dev, ICM42688_REG_WHO_AM_I, &whoami, 1);
    if (rc != ICM42688_OK) return rc;
    if (whoami != ICM42688_WHOAMI_VALUE) return ICM42688_E_WHOAMI;

    /* Datasheet §14.53: INT_CONFIG1 bit4 must be cleared for optimal INT
     * latency (spec quirk on Rev-A/B parts). */
    rc = icm42688_write_reg(dev, ICM42688_REG_INT_CONFIG1,
                            ICM42688_INT_CONFIG1_INT_ASYNC_RST_CLEAR);
    if (rc != ICM42688_OK) return rc;

    return ICM42688_OK;
}

/* ============================================================
   Configure accel/gyro + INT1 data-ready
   ============================================================ */
icm42688_status_t icm42688_configure(struct icm42688_dev *dev,
                                     icm42688_accel_fs_t accel_fs,
                                     icm42688_gyro_fs_t  gyro_fs,
                                     icm42688_odr_t      odr,
                                     bool                enable_accel,
                                     bool                enable_gyro)
{
    icm42688_status_t rc;
    uint8_t pwr_mgmt0 = ICM42688_PWR_MGMT0_TEMP_DIS; /* temp not used */
    uint8_t accel_cfg0, gyro_cfg0;

    if (dev == 0) return ICM42688_E_ARG;

    dev->accel_fs      = accel_fs;
    dev->gyro_fs       = gyro_fs;
    dev->odr           = odr;
    dev->accel_enabled = enable_accel;
    dev->gyro_enabled  = enable_gyro;

    /* Power management: enable requested sensors in low-noise mode */
    if (enable_accel) pwr_mgmt0 |= ICM42688_PWR_MGMT0_ACCEL_LN;
    if (enable_gyro)  pwr_mgmt0 |= ICM42688_PWR_MGMT0_GYRO_LN;

    rc = icm42688_write_reg(dev, ICM42688_REG_PWR_MGMT0, pwr_mgmt0);
    if (rc != ICM42688_OK) return rc;

    /* Datasheet §12.9: wait ≥ 200 µs after PWR_MGMT0 change before other
     * register writes affecting accel/gyro path. Use 1 ms to be safe. */
    icm42688_delay_ms(dev, 1);

    /* ACCEL_CONFIG0[7:5]=FS, [3:0]=ODR */
    accel_cfg0 = (uint8_t)((accel_fs << 5) & 0xE0) | (uint8_t)(odr & 0x0F);
    rc = icm42688_write_reg(dev, ICM42688_REG_ACCEL_CONFIG0, accel_cfg0);
    if (rc != ICM42688_OK) return rc;

    /* GYRO_CONFIG0[7:5]=FS, [3:0]=ODR */
    gyro_cfg0 = (uint8_t)((gyro_fs << 5) & 0xE0) | (uint8_t)(odr & 0x0F);
    rc = icm42688_write_reg(dev, ICM42688_REG_GYRO_CONFIG0, gyro_cfg0);
    if (rc != ICM42688_OK) return rc;

    /* FIFO bypass (we poll on DRDY) */
    rc = icm42688_write_reg(dev, ICM42688_REG_FIFO_CONFIG,
                            ICM42688_FIFO_MODE_BYPASS);
    if (rc != ICM42688_OK) return rc;

    /* INT1: push-pull, active high, PULSED (short high pulse per DRDY event
     * — gives one clean rising edge per sample and self-clears the pin, so
     * we don't depend on INT_STATUS being read to see the next event). */
    rc = icm42688_write_reg(dev, ICM42688_REG_INT_CONFIG,
                            ICM42688_INT1_DRIVE_PUSHPULL |
                            ICM42688_INT1_POLARITY_ACTIVE_HI /* MODE bit = 0 -> pulsed */);
    if (rc != ICM42688_OK) return rc;

    /* Route UI DRDY to INT1 */
    rc = icm42688_write_reg(dev, ICM42688_REG_INT_SOURCE0,
                            ICM42688_INT_SOURCE0_UI_DRDY_INT1_EN);
    if (rc != ICM42688_OK) return rc;

    /* Give the ODR path time to stabilise before host starts sampling */
    icm42688_delay_ms(dev, 10);

    return ICM42688_OK;
}

/* ============================================================
   Read one 6-axis frame (accel + gyro)
   ============================================================ */
icm42688_status_t icm42688_read_frame(struct icm42688_dev *dev,
                                      struct icm42688_frame *frame)
{
    icm42688_status_t rc;
    uint8_t buf[12]; /* ACCEL_XH..GYRO_ZL, big endian pairs */
    int i;

    if ((dev == 0) || (frame == 0)) return ICM42688_E_ARG;

    /* Burst-read 12 bytes starting at ACCEL_DATA_X1.
     * Reading INT_STATUS as part of / after this read auto-clears DRDY. */
    rc = icm42688_read_reg(dev, ICM42688_REG_ACCEL_DATA_X1, buf, sizeof(buf));
    if (rc != ICM42688_OK) return rc;

    /* Repack: bytes on the wire are big-endian, host is little-endian. */
    for (i = 0; i < 3; i++) {
        frame->accel[i] = (int16_t)(((uint16_t)buf[2*i]     << 8) |
                                     (uint16_t)buf[2*i + 1]);
        frame->gyro[i]  = (int16_t)(((uint16_t)buf[6 + 2*i] << 8) |
                                     (uint16_t)buf[6 + 2*i + 1]);
    }

    /* Read + discard INT_STATUS to clear latched DRDY */
    {
        uint8_t s;
        (void)icm42688_read_reg(dev, ICM42688_REG_INT_STATUS, &s, 1);
    }

    return ICM42688_OK;
}
