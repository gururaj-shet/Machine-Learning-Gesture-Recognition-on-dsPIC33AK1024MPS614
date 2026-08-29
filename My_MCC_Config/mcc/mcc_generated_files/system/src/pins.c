/*******************************************************************************
  PINS Driver Source — dsPIC33AK1024MPS614
  Extended from the OOB Curiosity GP DIM pins.c to add:
    - MIKRO1_CS as digital output on RE15 (MikroBUS A CS)
    - SPI2 fixed-function pins RB10/RB11/RC9 configured as digital
    - INT1 external interrupt PPS-remapped to RP72 (RE7 = MikroBUS A INT)
  All other OOB assignments (LEDs, buttons, POT, UART1, CAN1, etc.) are kept.

  Pin references verified against the DIM Info Sheet (Table 1-1) and
  the Curiosity Platform User Guide.
*******************************************************************************/
#include <xc.h>
#include <stddef.h>
#include "../pins.h"

void PINS_Initialize(void)
{
    /* ---------------------------------------------------------------------- *
     * Output latches — keep OOB defaults then de-assert MIKRO1_CS.
     * ---------------------------------------------------------------------- */
    LATA = 0x0000UL;
    LATB = 0x0000UL;
    LATC = 0x0000UL;
    LATD = 0x0000UL;
    LATE = 0x0000UL;
    LATAbits.LATA12 = 0;
    LATEbits.LATE15 = 1;     /* MIKRO1_CS starts HIGH (deasserted) */

    /* ---------------------------------------------------------------------- *
     * TRIS — inherit OOB masks, then override for our added pins:
     *   RE15   = OUTPUT  (MIKRO1_CS)
     *   RB10   = OUTPUT  (SPI2 SCK2 driven by SPI peripheral)
     *   RB11   = INPUT   (SPI2 SDI2)
     *   RC9    = OUTPUT  (SPI2 SDO2)
     *   RE7    = INPUT   (INT1 via PPS RP72)
     * ---------------------------------------------------------------------- */
    TRISA = 0x0BFBUL;
    TRISB = 0x3FFFUL;
    TRISC = 0x0000UL;
    TRISD = 0x01FFUL;
    TRISEbits.TRISE11 = 0;
    TRISAbits.TRISA12 = 0;

    TRISEbits.TRISE15 = 0;   /* MIKRO1_CS output */
    TRISBbits.TRISB10 = 0;   /* SPI2 SCK output */
    TRISBbits.TRISB11 = 1;   /* SPI2 SDI input */
    TRISCbits.TRISC9  = 0;   /* SPI2 SDO output */
    TRISEbits.TRISE7  = 1;   /* MikroBUS A INT input */

    /* ---------------------------------------------------------------------- *
     * Weak pull-ups / pull-downs — leave disabled (OOB default).
     * ---------------------------------------------------------------------- */
    CNPUA = 0x0000UL;  CNPUB = 0x0000UL;  CNPUC = 0x0000UL;  CNPUD = 0x0000UL;
    CNPDA = 0x0000UL;  CNPDB = 0x0000UL;  CNPDC = 0x0000UL;  CNPDD = 0x0000UL;

    /* ---------------------------------------------------------------------- *
     * Open-drain — all push-pull (ICM-42688-P INT is push-pull; CS push-pull)
     * ---------------------------------------------------------------------- */
    ODCA = 0x0000UL;  ODCB = 0x0000UL;  ODCC = 0x0000UL;  ODCD = 0x0000UL;

    /* ---------------------------------------------------------------------- *
     * Analog / digital selection — keep OOB, then force our SPI + INT + CS
     * pins to DIGITAL.
     * ---------------------------------------------------------------------- */
    ANSELA = 0x0BFBUL;
    ANSELB = 0x0FFFUL;   /* OOB default — will override RB10/RB11 below */
    ANSELC = 0x0000UL;
    ANSELD = 0x0060UL;
    ANSELE = 0x0000UL;
    ANSELAbits.ANSELA12 = 0;

    ANSELBbits.ANSELB10 = 0;   /* SCK2 digital */
    ANSELBbits.ANSELB11 = 0;   /* SDI2 digital */
    /* RC9 has no analog function; ANSELC already 0. */
    /* RE7, RE15 have no analog function; ANSELE already 0. */

    /* ---------------------------------------------------------------------- *
     * PPS assignments
     * ---------------------------------------------------------------------- */
    PINS_PPSUnlock();

    /* --- OOB assignments (kept verbatim) ------------------------------- */
    RPINR17bits.CAN1RXR = 66UL;    /* RE1(RP66) -> CAN1RX      */
    RPINR13bits.U1RXR   = 55UL;    /* RD6(RP55) -> UART1 U1RX  */
    RPOR10bits.RP43R    = 0x002DUL; /* RC10(RP43) -> SCCP7:OCM7 (LED_B PWM) */
    RPOR8bits.RP35R     = 0x002AUL; /* RC2(RP35)  -> SCCP4:OCM4 (LED_R PWM) */
    RPOR8bits.RP36R     = 0x0029UL; /* RC3(RP36)  -> SCCP3:OCM3 (LED_G PWM) */
    RPOR16bits.RP65R    = 0x0011UL; /* RE0(RP65)  -> CAN1TX     */
    RPOR18bits.RP76R    = 0x0013UL; /* RE11(RP76) -> UART1 U1TX */

    /* --- NEW: INT1 input on RP72 (RE7 = MikroBUS A INT) --------------- */
    RPINR0bits.INT1R    = 72UL;

    /* Note on SPI2: RB10/RB11/RC9 are the FIXED-FUNCTION pins for
     * SCK2/SDI2/SDO2 respectively — no PPS remap needed as long as
     * config_bits.c has FDEVOPT_SPI2PIN = OFF (default) which selects the
     * PPS/fixed-function assignment through the SPI2 module. Since the
     * OOB's config_bits.c sets FDEVOPT_SPI2PIN = OFF, the SPI2 peripheral
     * will drive these pins directly once SPI2CON1.ON = 1. */

    PINS_PPSLock();
}
