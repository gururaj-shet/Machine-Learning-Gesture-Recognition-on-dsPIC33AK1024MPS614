/*******************************************************************************
  Sensor-config (ICM-42688-P only on the AK port).
  This header is a compatibility shim so the ported source keeps the same
  include chain (sensor.h → sensor_config.h → app_config.h) as the CK demo.
*******************************************************************************/
#ifndef SENSOR_CONFIG_H
#define SENSOR_CONFIG_H

#include <stdint.h>
#include <stdbool.h>

/* Force ICM-42688-P on the AK board. */
#define SNSR_TYPE_ICM42688      true
#define SNSR_TYPE_BMI160        false

#include "app_config.h"

/* Sensor API name resolution — all mapped to the ICM adapter. */
#define sensor_init        icm42688_sensor_init
#define sensor_set_config  icm42688_sensor_set_config
#define sensor_read        icm42688_sensor_read

#endif /* SENSOR_CONFIG_H */
