/*******************************************************************************
  ICM-42688-P Register Map (subset needed for accel+gyro polling)

  Company:    Microchip Technology Inc.
  File:       icm42688p_regs.h
  Reference:  TDK InvenSense ICM-42688-P Datasheet, Rev. 1.7 (DS-000347)

  Notes:
    - Registers below are bank 0 (USER_BANK 0) unless annotated.
    - MSB of the register address byte on SPI = R/W (1 = read).
*******************************************************************************/
#ifndef ICM42688P_REGS_H
#define ICM42688P_REGS_H

/* ---- BANK 0 ---- */
#define ICM42688_REG_DEVICE_CONFIG          0x11
#define   ICM42688_DEVICE_CONFIG_SOFT_RESET (1U << 0)

#define ICM42688_REG_DRIVE_CONFIG           0x13
#define ICM42688_REG_INT_CONFIG             0x14
#define   ICM42688_INT1_MODE_LATCHED        (1U << 2)
#define   ICM42688_INT1_DRIVE_PUSHPULL      (1U << 1)
#define   ICM42688_INT1_POLARITY_ACTIVE_HI  (1U << 0)

#define ICM42688_REG_FIFO_CONFIG            0x16
#define   ICM42688_FIFO_MODE_BYPASS         (0U << 6)

#define ICM42688_REG_TEMP_DATA1             0x1D  /* start of DATA block */
#define ICM42688_REG_ACCEL_DATA_X1          0x1F
#define ICM42688_REG_GYRO_DATA_X1           0x25
#define ICM42688_REG_INT_STATUS             0x2D
#define   ICM42688_INT_STATUS_DATA_RDY      (1U << 3)
#define   ICM42688_INT_STATUS_RESET_DONE    (1U << 4)

#define ICM42688_REG_PWR_MGMT0              0x4E
#define   ICM42688_PWR_MGMT0_TEMP_DIS       (1U << 5)
#define   ICM42688_PWR_MGMT0_IDLE           (1U << 4)
#define   ICM42688_PWR_MGMT0_GYRO_OFF       (0U << 2)
#define   ICM42688_PWR_MGMT0_GYRO_STDBY     (1U << 2)
#define   ICM42688_PWR_MGMT0_GYRO_LN        (3U << 2)
#define   ICM42688_PWR_MGMT0_ACCEL_OFF      (0U << 0)
#define   ICM42688_PWR_MGMT0_ACCEL_LP       (2U << 0)
#define   ICM42688_PWR_MGMT0_ACCEL_LN       (3U << 0)

#define ICM42688_REG_GYRO_CONFIG0           0x4F
#define   ICM42688_GYRO_FS_2000DPS          (0U << 5)
#define   ICM42688_GYRO_FS_1000DPS          (1U << 5)
#define   ICM42688_GYRO_FS_500DPS           (2U << 5)
#define   ICM42688_GYRO_FS_250DPS           (3U << 5)
#define   ICM42688_GYRO_FS_125DPS           (4U << 5)
#define   ICM42688_GYRO_ODR_1KHZ            (0x06U)
#define   ICM42688_GYRO_ODR_200HZ           (0x07U)
#define   ICM42688_GYRO_ODR_100HZ           (0x08U)
#define   ICM42688_GYRO_ODR_50HZ            (0x09U)
#define   ICM42688_GYRO_ODR_25HZ            (0x0AU)

#define ICM42688_REG_ACCEL_CONFIG0          0x50
#define   ICM42688_ACCEL_FS_16G             (0U << 5)
#define   ICM42688_ACCEL_FS_8G              (1U << 5)
#define   ICM42688_ACCEL_FS_4G              (2U << 5)
#define   ICM42688_ACCEL_FS_2G              (3U << 5)
#define   ICM42688_ACCEL_ODR_1KHZ           (0x06U)
#define   ICM42688_ACCEL_ODR_200HZ          (0x07U)
#define   ICM42688_ACCEL_ODR_100HZ          (0x08U)
#define   ICM42688_ACCEL_ODR_50HZ           (0x09U)
#define   ICM42688_ACCEL_ODR_25HZ           (0x0AU)

#define ICM42688_REG_GYRO_ACCEL_CONFIG0     0x52
#define ICM42688_REG_INT_CONFIG0            0x63
#define ICM42688_REG_INT_CONFIG1            0x64
#define   ICM42688_INT_CONFIG1_INT_ASYNC_RST_CLEAR (0U << 4) /* datasheet: set to 0 after reset */
#define   ICM42688_INT_CONFIG1_INT_TPULSE_DUR_100US (1U << 6)
#define ICM42688_REG_INT_SOURCE0            0x65
#define   ICM42688_INT_SOURCE0_UI_DRDY_INT1_EN (1U << 3)

#define ICM42688_REG_WHO_AM_I               0x75
#define   ICM42688_WHOAMI_VALUE             0x47

#define ICM42688_REG_REG_BANK_SEL           0x76
#define   ICM42688_BANK_0                   0x00
#define   ICM42688_BANK_1                   0x01
#define   ICM42688_BANK_2                   0x02
#define   ICM42688_BANK_3                   0x03
#define   ICM42688_BANK_4                   0x04

/* SPI read/write direction bit (bit 7 of address byte) */
#define ICM42688_SPI_READ_MASK              0x80

#endif /* ICM42688P_REGS_H */
