/*******************************************************************************
  ICM-42688-P Sensor Adapter for the AK gesture demo.

  Bridges the generic `sensor_device_t` API used by main.c to the low-level
  ICM-42688-P register driver (icm42688p.[ch]). Uses the Mikrobus SPI helpers
  in mikro_spi.[ch]. Compile-time switches from app_config.h control which
  axes and full-scale ranges are pushed into the device.
*******************************************************************************/
#include <stddef.h>
#include <stdint.h>
#include <string.h>

#include "sensor.h"
#include "icm42688p.h"
#include "icm42688p_regs.h"
#include "mikro_spi.h"

/* ----- Map compile-time SNSR_* macros to icm42688 enums ------------------ */
#if   (SNSR_ACCEL_RANGE == 2)
#  define IMU_ACCEL_FS ICM42688_ACCEL_RANGE_2G
#elif (SNSR_ACCEL_RANGE == 4)
#  define IMU_ACCEL_FS ICM42688_ACCEL_RANGE_4G
#elif (SNSR_ACCEL_RANGE == 8)
#  define IMU_ACCEL_FS ICM42688_ACCEL_RANGE_8G
#elif (SNSR_ACCEL_RANGE == 16)
#  define IMU_ACCEL_FS ICM42688_ACCEL_RANGE_16G
#else
#  error "Unsupported SNSR_ACCEL_RANGE"
#endif

#if   (SNSR_GYRO_RANGE == 125)
#  define IMU_GYRO_FS ICM42688_GYRO_RANGE_125DPS
#elif (SNSR_GYRO_RANGE == 250)
#  define IMU_GYRO_FS ICM42688_GYRO_RANGE_250DPS
#elif (SNSR_GYRO_RANGE == 500)
#  define IMU_GYRO_FS ICM42688_GYRO_RANGE_500DPS
#elif (SNSR_GYRO_RANGE == 1000)
#  define IMU_GYRO_FS ICM42688_GYRO_RANGE_1000DPS
#elif (SNSR_GYRO_RANGE == 2000)
#  define IMU_GYRO_FS ICM42688_GYRO_RANGE_2000DPS
#else
#  error "Unsupported SNSR_GYRO_RANGE"
#endif

#if   (SNSR_SAMPLE_RATE == 25)
#  define IMU_ODR ICM42688_ODR_25HZ
#elif (SNSR_SAMPLE_RATE == 50)
#  define IMU_ODR ICM42688_ODR_50HZ
#elif (SNSR_SAMPLE_RATE == 100)
#  define IMU_ODR ICM42688_ODR_100HZ
#elif (SNSR_SAMPLE_RATE == 200)
#  define IMU_ODR ICM42688_ODR_200HZ
#elif (SNSR_SAMPLE_RATE == 1000)
#  define IMU_ODR ICM42688_ODR_1KHZ
#else
#  error "Unsupported SNSR_SAMPLE_RATE"
#endif

/* ------------------------------------------------------------------------- */
int icm42688_sensor_init(struct sensor_device_t *sensor)
{
    icm42688_status_t rc;
    memset(&sensor->device, 0, sizeof(sensor->device));

    rc = icm42688_init(&sensor->device, mikro_spi_get_serif());
    sensor->status = (int)rc;
    return sensor->status;
}

int icm42688_sensor_set_config(struct sensor_device_t *sensor)
{
    icm42688_status_t rc;

    rc = icm42688_configure(&sensor->device,
                            IMU_ACCEL_FS,
                            IMU_GYRO_FS,
                            IMU_ODR,
                            (bool)SNSR_USE_ACCEL,
                            (bool)SNSR_USE_GYRO);
    sensor->status = (int)rc;
    return sensor->status;
}

int icm42688_sensor_read(struct sensor_device_t *sensor, snsr_data_t *ptr)
{
    struct icm42688_frame f;
    icm42688_status_t rc;

    rc = icm42688_read_frame(&sensor->device, &f);
    sensor->status = (int)rc;
    if (rc != ICM42688_OK) return sensor->status;

#if SNSR_USE_ACCEL
    *ptr++ = (snsr_data_t)f.accel[0];
    *ptr++ = (snsr_data_t)f.accel[1];
    *ptr++ = (snsr_data_t)f.accel[2];
#endif
#if SNSR_USE_GYRO
    *ptr++ = (snsr_data_t)f.gyro[0];
    *ptr++ = (snsr_data_t)f.gyro[1];
    *ptr++ = (snsr_data_t)f.gyro[2];
#endif
    return ICM42688_OK;
}
