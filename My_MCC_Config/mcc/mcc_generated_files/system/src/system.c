/*******************************************************************************
  SYSTEM Initialization — dsPIC33AK1024MPS614
  Extended from the OOB to include SPI2 host and EXT_INT1 configuration.
*******************************************************************************/
#include "../system.h"
#include "../system_types.h"
#include "../clock.h"
#include "../pins.h"
#include "../../adc/adc3.h"
#include "../../can/can1.h"
#include "../dmt.h"
#include "../../pwm/sccp3.h"
#include "../../pwm/sccp4.h"
#include "../../pwm/sccp7.h"
#include "../../timer/tmr1.h"
#include "../../uart/uart1.h"
#include "../../spi_host/spi2.h"      /* NEW */
#include "../../interrupt/ext_int.h"  /* NEW */
#include "../interrupt.h"

void SYSTEM_Initialize(void)
{
    CLOCK_Initialize();
    PINS_Initialize();
    ADC3_Initialize();
    CAN1_Initialize();
    DMT_Initialize();
    SCCP3_PWM_Initialize();
    SCCP4_PWM_Initialize();
    SCCP7_PWM_Initialize();
    TMR1_Initialize();
    UART1_Initialize();
    SPI2_Initialize();            /* NEW — ICM-42688-P bus */
    EXT_INT1_Initialize();        /* NEW — DRDY line       */
    INTERRUPT_GlobalEnable();
    INTERRUPT_Initialize();
}
