/*******************************************************************************
  ICM-42688-P Minimal Driver (SPI, polled register access)

  Company:    Microchip Technology Inc.
  File:       icm42688p.h

  Summary:
    Register-level driver for the TDK InvenSense ICM-42688-P 6-axis IMU as
    fitted on the MikroE 6DOF IMU 14 Click board. Provides only the surface
    area needed by the gesture-recognition application:

        - soft reset & WHO_AM_I verification
        - accel/gyro FS + ODR configuration
        - low-noise power mode
        - data-ready interrupt on INT1 (push-pull, active high, latched)
        - burst read of 6-axis raw sensor data (12 bytes)

    The driver depends only on a small SPI-transfer callback pair supplied by
    the caller (`serif`), keeping the driver bus/MCU agnostic. On the AK port
    the callbacks wrap MCC Melody SPI1 + Mikrobus CS GPIO.

  Notes:
    - All access is Bank-0 only.
    - Raw output is signed 16-bit, big-endian on the wire and repacked to LE
      here.
*******************************************************************************/
#ifndef ICM42688P_H
#define ICM42688P_H

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    ICM42688_OK             = 0,
    ICM42688_E_BUS          = -1,
    ICM42688_E_WHOAMI       = -2,
    ICM42688_E_TIMEOUT      = -3,
    ICM42688_E_ARG          = -4
} icm42688_status_t;

/* Full-scale range enums (map 1:1 to register bit fields) */
typedef enum {
    ICM42688_ACCEL_RANGE_2G  = 3,
    ICM42688_ACCEL_RANGE_4G  = 2,
    ICM42688_ACCEL_RANGE_8G  = 1,
    ICM42688_ACCEL_RANGE_16G = 0
} icm42688_accel_fs_t;

typedef enum {
    ICM42688_GYRO_RANGE_125DPS  = 4,
    ICM42688_GYRO_RANGE_250DPS  = 3,
    ICM42688_GYRO_RANGE_500DPS  = 2,
    ICM42688_GYRO_RANGE_1000DPS = 1,
    ICM42688_GYRO_RANGE_2000DPS = 0
} icm42688_gyro_fs_t;

/* ODR enums (register field for ACCEL_CONFIG0[3:0] / GYRO_CONFIG0[3:0]) */
typedef enum {
    ICM42688_ODR_25HZ  = 0x0A,
    ICM42688_ODR_50HZ  = 0x09,
    ICM42688_ODR_100HZ = 0x08,
    ICM42688_ODR_200HZ = 0x07,
    ICM42688_ODR_1KHZ  = 0x06
} icm42688_odr_t;

/*
 * SPI serif callbacks. Read/write use `reg` as the *device* register address
 * (7-bit); the driver internally OR-s in the R/W direction bit on the wire.
 *
 * Both callbacks must:
 *   - assert CS
 *   - transmit the 1-byte address (with R/W bit set/clear appropriately)
 *   - transfer `len` bytes
 *   - de-assert CS
 *
 * Return 0 on success, non-zero on bus error.
 */
struct icm42688_serif {
    void *context;
    int (*read_reg)(void *ctx, uint8_t reg, uint8_t *dst, uint16_t len);
    int (*write_reg)(void *ctx, uint8_t reg, const uint8_t *src, uint16_t len);
    void (*delay_us)(uint32_t us);
    void (*delay_ms)(uint32_t ms);
};

/* Raw 6-axis sample frame (accel X/Y/Z, gyro X/Y/Z) */
struct icm42688_frame {
    int16_t accel[3];
    int16_t gyro[3];
};

/* Runtime device handle */
struct icm42688_dev {
    const struct icm42688_serif *serif;
    icm42688_accel_fs_t         accel_fs;
    icm42688_gyro_fs_t          gyro_fs;
    icm42688_odr_t              odr;
    bool                        accel_enabled;
    bool                        gyro_enabled;
};

/* Life-cycle */
icm42688_status_t icm42688_init(struct icm42688_dev *dev,
                                const struct icm42688_serif *serif);

/* Apply accel/gyro FS+ODR and enable low-noise mode + INT1 data-ready */
icm42688_status_t icm42688_configure(struct icm42688_dev *dev,
                                     icm42688_accel_fs_t accel_fs,
                                     icm42688_gyro_fs_t  gyro_fs,
                                     icm42688_odr_t      odr,
                                     bool                enable_accel,
                                     bool                enable_gyro);

/* Blocking burst read: 6 axes = 12 bytes, wire big-endian → repacked to LE.
 * Fills `frame` with accel[3] then gyro[3] as signed 16-bit. */
icm42688_status_t icm42688_read_frame(struct icm42688_dev *dev,
                                      struct icm42688_frame *frame);

/* Low-level helper: raw register read/write (for debug/advanced usage) */
icm42688_status_t icm42688_read_reg(struct icm42688_dev *dev,
                                    uint8_t reg, uint8_t *dst, uint16_t len);
icm42688_status_t icm42688_write_reg(struct icm42688_dev *dev,
                                     uint8_t reg, uint8_t val);

#ifdef __cplusplus
}
#endif

#endif /* ICM42688P_H */
