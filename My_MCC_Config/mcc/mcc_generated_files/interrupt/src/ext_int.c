/*******************************************************************************
  External Interrupt Driver — dsPIC33AK1024MPS614 (see ext_int.h)
*******************************************************************************/
#include <xc.h>
#include <stddef.h>
#include "../ext_int.h"

static void (*ext_int1_handler)(void) = NULL;

void EXT_INT1_Initialize(void)
{
    /* On the AK: INT1IE lives in IEC1, INT1IF in IFS1, INT1IP in IPC4.
     * Verified against DSPIC33AK1024MPS614.PIC (DFP EDC). */
    IEC1bits.INT1IE = 0;
    IFS1bits.INT1IF = 0;

    /* Rising edge (INT1EP = 0 -> positive edge) */
    INTCON2bits.INT1EP = 0;

    /* Interrupt priority 4 */
    IPC4bits.INT1IP = 4;
}

void EXT_INT1_CallbackRegister(void (*handler)(void))
{
    ext_int1_handler = handler;
}

void EXT_INT1_Enable(void)
{
    IFS1bits.INT1IF = 0;
    IEC1bits.INT1IE = 1;
}

void EXT_INT1_Disable(void)
{
    IEC1bits.INT1IE = 0;
    IFS1bits.INT1IF = 0;
}

/* cppcheck-suppress misra-c2012-8.4 */
void __attribute__((interrupt, no_auto_psv)) _INT1Interrupt(void)
{
    IFS1bits.INT1IF = 0;
    if (ext_int1_handler != NULL) {
        ext_int1_handler();
    }
}
