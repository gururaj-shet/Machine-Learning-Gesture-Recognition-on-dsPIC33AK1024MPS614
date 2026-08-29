/**
 * SCCP7 Generated Driver Source File
 * 
 * @file 	  sccp7.c
 * 
 * @ingroup   pwmdriver
 * 
 * @brief 	  This is the generated driver source file for SCCP7 driver
 *
 * @skipline @version   PLIB Version 1.2.2
 *
 * @skipline  Device : dsPIC33AK1024MPS614
*/

/*
� [2026] Microchip Technology Inc. and its subsidiaries.

    Subject to your compliance with these terms, you may use Microchip 
    software and any derivatives exclusively with Microchip products. 
    You are responsible for complying with 3rd party license terms  
    applicable to your use of 3rd party software (including open source  
    software) that may accompany Microchip software. SOFTWARE IS ?AS IS.? 
    NO WARRANTIES, WHETHER EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS 
    SOFTWARE, INCLUDING ANY IMPLIED WARRANTIES OF NON-INFRINGEMENT,  
    MERCHANTABILITY, OR FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT 
    WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE, 
    INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY 
    KIND WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF 
    MICROCHIP HAS BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE 
    FORESEEABLE. TO THE FULLEST EXTENT ALLOWED BY LAW, MICROCHIP?S 
    TOTAL LIABILITY ON ALL CLAIMS RELATED TO THE SOFTWARE WILL NOT 
    EXCEED AMOUNT OF FEES, IF ANY, YOU PAID DIRECTLY TO MICROCHIP FOR 
    THIS SOFTWARE.
*/

// Section: Included Files

#include <xc.h>
#include <stddef.h>
#include "../sccp7.h"

// Section: File specific functions

static void (*SCCP7_PWMHandler)(void) = NULL;

// Section: Driver Interface

const struct PWM_INTERFACE PWM7 = {
    .Initialize          = &SCCP7_PWM_Initialize,
    .Deinitialize        = &SCCP7_PWM_Deinitialize,
    .Enable              = &SCCP7_PWM_Enable,
    .Disable             = &SCCP7_PWM_Disable,
    .PeriodSet           = &SCCP7_PWM_PeriodSet,
    .DutyCycleSet        = &SCCP7_PWM_DutyCycleSet,
    .SoftwareTriggerSet  = &SCCP7_PWM_SoftwareTriggerSet,
    .DeadTimeSet         = NULL,
    .OutputModeSet       = NULL,
    .CallbackRegister = &SCCP7_PWM_CallbackRegister,
    .Tasks               = &SCCP7_PWM_Tasks
};

// Section: SCCP7 Module APIs

void SCCP7_PWM_Initialize (void)
{
    // MOD Dual Edge Compare, Buffered(PWM); CCSEL disabled; T32 16 Bit; TMRPS 1:1; CLKSEL Standard Speed Peripheral Clock; TMRSYNC disabled; SIDL disabled; ON disabled; SYNC None; ALTSYNC disabled; ONESHOT disabled; TRIGEN disabled; OPS Each Time Base Period Match; RTRGEN disabled; OPSSRC Timer Interrupt Event; 
    CCP7CON1 = 0x5UL;
    // ASDG disabled; SSDG disabled; ASDGM disabled; PWMRSEN disabled; ICS ; AUXOUT Disabled; ICGSM Level-Sensitive mode; OCAEN enabled; OENSYNC disabled; 
    CCP7CON2 = 0x1000000UL;
    // PSSACE Tri-state; POLACE disabled; OSCNT None; OETRIG disabled; PSSBDF Tri-state; POLBDF disabled; 
    CCP7CON3 = 0x0UL;
    // ICOV disabled; SCEVT disabled; ASEVT disabled; TRCLR disabled; TRSET disabled; ICGARM disabled; RAWIP disabled; RBWIP disabled; TMRLWIP disabled; TMRHWIP disabled; PRLWIP disabled; 
    CCP7STAT = 0x0UL;
    // TMRL 0x0; TMRH 0x0; 
    CCP7TMR = 0x0UL;
    // PRL 65535; PRH 0; 
    CCP7PR = 0xFFFFUL;
    // BUFL 0x0; BUFH 0x0; 
    CCP7BUF = 0x0UL;
    // CMPA 0; 
    CCP7RA = 0x0UL;
    // CMPB 65535; 
    CCP7RB = 0xFFFFUL;
    SCCP7_PWM_CallbackRegister(&SCCP7_PWM_Callback);
    
    CCP7CON1bits.ON = 1; //Enable Module
}

void SCCP7_PWM_Deinitialize (void)
{
    CCP7CON1bits.ON = 0;
    
    CCP7CON1 = 0x0UL;
    CCP7CON2 = 0x1000000UL;
    CCP7CON3 = 0x0UL;
    CCP7STAT = 0x0UL;
    CCP7TMR = 0x0UL;
    CCP7PR = 0xFFFFFFFFUL;
    CCP7BUF = 0x0UL;
    CCP7RA = 0x0UL;
    CCP7RB = 0x0UL;
}

void SCCP7_PWM_Enable( void )
{
    CCP7CON1bits.ON = 1;
}


void SCCP7_PWM_Disable( void )
{
    CCP7CON1bits.ON = 0;
}

void SCCP7_PWM_PeriodSet(size_t periodCount)
{
    CCP7PR = periodCount;
}

void SCCP7_PWM_DutyCycleSet(size_t dutyCycleCount)
{
    CCP7RB = dutyCycleCount;
}

void SCCP7_PWM_SoftwareTriggerSet( void )
{
    CCP7STATbits.TRSET = 1;
}

void SCCP7_PWM_CallbackRegister(void (*handler)(void))
{
    if(NULL != handler)
    {
        SCCP7_PWMHandler = handler;
    }
}

void __attribute__ ((weak)) SCCP7_PWM_Callback ( void )
{ 

} 


void SCCP7_PWM_Tasks( void )
{    
    if(_CCT7IF == 1)
    {
        // SCCP7 callback function 
        if(NULL != SCCP7_PWMHandler)
        {
            (*SCCP7_PWMHandler)();
        }
        _CCT7IF = 0;
    }
}
/**
 End of File
*/
