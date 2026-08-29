/*******************************************************************************
  PINS Driver Header — dsPIC33AK1024MPS614
  Extended for the ML Gesture demo (adds MIKRO1_CS + SPI2 fixed-function pins
  + INT1 PPS remap). Based on the OOB Curiosity GP DIM pins.h.
*******************************************************************************/
#ifndef PINS_H
#define PINS_H

#include <xc.h>

/*----------------------------------------------------------------------------*/
/*  PPS lock / unlock helpers                                                 */
/*----------------------------------------------------------------------------*/
#define PINS_PPSLock()      (RPCONbits.IOLOCK = 1)
#define PINS_PPSUnlock()    (RPCONbits.IOLOCK = 0)

/*----------------------------------------------------------------------------*/
/*  OOB pins (kept)                                                           */
/*----------------------------------------------------------------------------*/
/* CAN_FD_Transceiver on RC2 (unchanged from OOB) */
#define CAN_FD_Transceiver_SetHigh()            (_LATC2 = 1)
#define CAN_FD_Transceiver_SetLow()             (_LATC2 = 0)
#define CAN_FD_Transceiver_Toggle()             (_LATC2 ^= 1)
#define CAN_FD_Transceiver_GetValue()           _RC2
#define CAN_FD_Transceiver_SetDigitalInput()    (_TRISC2 = 1)
#define CAN_FD_Transceiver_SetDigitalOutput()   (_TRISC2 = 0)

/*----------------------------------------------------------------------------*/
/*  New: MikroBUS A CS pin (RE15 -> P81_mkB_A_CS)                             */
/*  Confirmed via dsPIC33AK1024MPS614 GP DIM Info Sheet, Table 1-1.           */
/*----------------------------------------------------------------------------*/
#define MIKRO1_CS_SetHigh()            (_LATE15 = 1)
#define MIKRO1_CS_SetLow()             (_LATE15 = 0)
#define MIKRO1_CS_Toggle()             (_LATE15 ^= 1)
#define MIKRO1_CS_GetValue()           _RE15
#define MIKRO1_CS_SetDigitalInput()    (_TRISE15 = 1)
#define MIKRO1_CS_SetDigitalOutput()   (_TRISE15 = 0)

/*----------------------------------------------------------------------------*/
/*  Initialisation                                                            */
/*----------------------------------------------------------------------------*/
void PINS_Initialize(void);

#endif /* PINS_H */
