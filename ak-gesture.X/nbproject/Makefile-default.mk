#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=elf
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/ak-gesture.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/ak-gesture.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

ifeq ($(COMPARE_BUILD), true)
COMPARISON_BUILD=-mafrlcsj
else
COMPARISON_BUILD=
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=../app/icm42688p.c ../app/icm42688_sensor.c ../app/mikro_spi.c ../app/ringbuffer.c ../knowledge-pack/application/sml_output.c ../knowledge-pack/application/sml_recognition_run.c ../bsp/led0.c ../bsp/led1.c ../bsp/led2.c ../bsp/led3.c ../bsp/led4.c ../bsp/led5.c ../bsp/led6.c ../bsp/led7.c ../bsp/led_blue.c ../bsp/led_green.c ../bsp/led_red.c ../bsp/led_rgb.c ../bsp/pot.c ../bsp/s1.c ../bsp/s2.c ../bsp/s3.c ../bsp/task.c ../My_MCC_Config/mcc/mcc_generated_files/adc/src/adc3.c ../My_MCC_Config/mcc/mcc_generated_files/can/src/can1.c ../My_MCC_Config/mcc/mcc_generated_files/interrupt/src/ext_int.c ../My_MCC_Config/mcc/mcc_generated_files/pwm/src/sccp3.c ../My_MCC_Config/mcc/mcc_generated_files/pwm/src/sccp4.c ../My_MCC_Config/mcc/mcc_generated_files/pwm/src/sccp7.c ../My_MCC_Config/mcc/mcc_generated_files/spi_host/src/spi2.c ../My_MCC_Config/mcc/mcc_generated_files/system/src/clock.c ../My_MCC_Config/mcc/mcc_generated_files/system/src/config_bits.c ../My_MCC_Config/mcc/mcc_generated_files/system/src/dmt.c ../My_MCC_Config/mcc/mcc_generated_files/system/src/interrupt.c ../My_MCC_Config/mcc/mcc_generated_files/system/src/pins.c ../My_MCC_Config/mcc/mcc_generated_files/system/src/reset.c ../My_MCC_Config/mcc/mcc_generated_files/system/src/system.c ../My_MCC_Config/mcc/mcc_generated_files/system/src/traps.c ../My_MCC_Config/mcc/mcc_generated_files/timer/src/tmr1.c ../My_MCC_Config/mcc/mcc_generated_files/uart/src/uart1.c ../console.c ../My_MCC_Config/mcc/main.c ../knowledge-pack/mplabml/src/kb.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/1360919890/icm42688p.o ${OBJECTDIR}/_ext/1360919890/icm42688_sensor.o ${OBJECTDIR}/_ext/1360919890/mikro_spi.o ${OBJECTDIR}/_ext/1360919890/ringbuffer.o ${OBJECTDIR}/_ext/959462024/sml_output.o ${OBJECTDIR}/_ext/959462024/sml_recognition_run.o ${OBJECTDIR}/_ext/1360920944/led0.o ${OBJECTDIR}/_ext/1360920944/led1.o ${OBJECTDIR}/_ext/1360920944/led2.o ${OBJECTDIR}/_ext/1360920944/led3.o ${OBJECTDIR}/_ext/1360920944/led4.o ${OBJECTDIR}/_ext/1360920944/led5.o ${OBJECTDIR}/_ext/1360920944/led6.o ${OBJECTDIR}/_ext/1360920944/led7.o ${OBJECTDIR}/_ext/1360920944/led_blue.o ${OBJECTDIR}/_ext/1360920944/led_green.o ${OBJECTDIR}/_ext/1360920944/led_red.o ${OBJECTDIR}/_ext/1360920944/led_rgb.o ${OBJECTDIR}/_ext/1360920944/pot.o ${OBJECTDIR}/_ext/1360920944/s1.o ${OBJECTDIR}/_ext/1360920944/s2.o ${OBJECTDIR}/_ext/1360920944/s3.o ${OBJECTDIR}/_ext/1360920944/task.o ${OBJECTDIR}/_ext/1976684066/adc3.o ${OBJECTDIR}/_ext/619004590/can1.o ${OBJECTDIR}/_ext/1955452069/ext_int.o ${OBJECTDIR}/_ext/1337440824/sccp3.o ${OBJECTDIR}/_ext/1337440824/sccp4.o ${OBJECTDIR}/_ext/1337440824/sccp7.o ${OBJECTDIR}/_ext/1565449251/spi2.o ${OBJECTDIR}/_ext/924153673/clock.o ${OBJECTDIR}/_ext/924153673/config_bits.o ${OBJECTDIR}/_ext/924153673/dmt.o ${OBJECTDIR}/_ext/924153673/interrupt.o ${OBJECTDIR}/_ext/924153673/pins.o ${OBJECTDIR}/_ext/924153673/reset.o ${OBJECTDIR}/_ext/924153673/system.o ${OBJECTDIR}/_ext/924153673/traps.o ${OBJECTDIR}/_ext/1106728185/tmr1.o ${OBJECTDIR}/_ext/527242858/uart1.o ${OBJECTDIR}/_ext/1472/console.o ${OBJECTDIR}/_ext/748590006/main.o ${OBJECTDIR}/_ext/1727389914/kb.o
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/1360919890/icm42688p.o.d ${OBJECTDIR}/_ext/1360919890/icm42688_sensor.o.d ${OBJECTDIR}/_ext/1360919890/mikro_spi.o.d ${OBJECTDIR}/_ext/1360919890/ringbuffer.o.d ${OBJECTDIR}/_ext/959462024/sml_output.o.d ${OBJECTDIR}/_ext/959462024/sml_recognition_run.o.d ${OBJECTDIR}/_ext/1360920944/led0.o.d ${OBJECTDIR}/_ext/1360920944/led1.o.d ${OBJECTDIR}/_ext/1360920944/led2.o.d ${OBJECTDIR}/_ext/1360920944/led3.o.d ${OBJECTDIR}/_ext/1360920944/led4.o.d ${OBJECTDIR}/_ext/1360920944/led5.o.d ${OBJECTDIR}/_ext/1360920944/led6.o.d ${OBJECTDIR}/_ext/1360920944/led7.o.d ${OBJECTDIR}/_ext/1360920944/led_blue.o.d ${OBJECTDIR}/_ext/1360920944/led_green.o.d ${OBJECTDIR}/_ext/1360920944/led_red.o.d ${OBJECTDIR}/_ext/1360920944/led_rgb.o.d ${OBJECTDIR}/_ext/1360920944/pot.o.d ${OBJECTDIR}/_ext/1360920944/s1.o.d ${OBJECTDIR}/_ext/1360920944/s2.o.d ${OBJECTDIR}/_ext/1360920944/s3.o.d ${OBJECTDIR}/_ext/1360920944/task.o.d ${OBJECTDIR}/_ext/1976684066/adc3.o.d ${OBJECTDIR}/_ext/619004590/can1.o.d ${OBJECTDIR}/_ext/1955452069/ext_int.o.d ${OBJECTDIR}/_ext/1337440824/sccp3.o.d ${OBJECTDIR}/_ext/1337440824/sccp4.o.d ${OBJECTDIR}/_ext/1337440824/sccp7.o.d ${OBJECTDIR}/_ext/1565449251/spi2.o.d ${OBJECTDIR}/_ext/924153673/clock.o.d ${OBJECTDIR}/_ext/924153673/config_bits.o.d ${OBJECTDIR}/_ext/924153673/dmt.o.d ${OBJECTDIR}/_ext/924153673/interrupt.o.d ${OBJECTDIR}/_ext/924153673/pins.o.d ${OBJECTDIR}/_ext/924153673/reset.o.d ${OBJECTDIR}/_ext/924153673/system.o.d ${OBJECTDIR}/_ext/924153673/traps.o.d ${OBJECTDIR}/_ext/1106728185/tmr1.o.d ${OBJECTDIR}/_ext/527242858/uart1.o.d ${OBJECTDIR}/_ext/1472/console.o.d ${OBJECTDIR}/_ext/748590006/main.o.d ${OBJECTDIR}/_ext/1727389914/kb.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/1360919890/icm42688p.o ${OBJECTDIR}/_ext/1360919890/icm42688_sensor.o ${OBJECTDIR}/_ext/1360919890/mikro_spi.o ${OBJECTDIR}/_ext/1360919890/ringbuffer.o ${OBJECTDIR}/_ext/959462024/sml_output.o ${OBJECTDIR}/_ext/959462024/sml_recognition_run.o ${OBJECTDIR}/_ext/1360920944/led0.o ${OBJECTDIR}/_ext/1360920944/led1.o ${OBJECTDIR}/_ext/1360920944/led2.o ${OBJECTDIR}/_ext/1360920944/led3.o ${OBJECTDIR}/_ext/1360920944/led4.o ${OBJECTDIR}/_ext/1360920944/led5.o ${OBJECTDIR}/_ext/1360920944/led6.o ${OBJECTDIR}/_ext/1360920944/led7.o ${OBJECTDIR}/_ext/1360920944/led_blue.o ${OBJECTDIR}/_ext/1360920944/led_green.o ${OBJECTDIR}/_ext/1360920944/led_red.o ${OBJECTDIR}/_ext/1360920944/led_rgb.o ${OBJECTDIR}/_ext/1360920944/pot.o ${OBJECTDIR}/_ext/1360920944/s1.o ${OBJECTDIR}/_ext/1360920944/s2.o ${OBJECTDIR}/_ext/1360920944/s3.o ${OBJECTDIR}/_ext/1360920944/task.o ${OBJECTDIR}/_ext/1976684066/adc3.o ${OBJECTDIR}/_ext/619004590/can1.o ${OBJECTDIR}/_ext/1955452069/ext_int.o ${OBJECTDIR}/_ext/1337440824/sccp3.o ${OBJECTDIR}/_ext/1337440824/sccp4.o ${OBJECTDIR}/_ext/1337440824/sccp7.o ${OBJECTDIR}/_ext/1565449251/spi2.o ${OBJECTDIR}/_ext/924153673/clock.o ${OBJECTDIR}/_ext/924153673/config_bits.o ${OBJECTDIR}/_ext/924153673/dmt.o ${OBJECTDIR}/_ext/924153673/interrupt.o ${OBJECTDIR}/_ext/924153673/pins.o ${OBJECTDIR}/_ext/924153673/reset.o ${OBJECTDIR}/_ext/924153673/system.o ${OBJECTDIR}/_ext/924153673/traps.o ${OBJECTDIR}/_ext/1106728185/tmr1.o ${OBJECTDIR}/_ext/527242858/uart1.o ${OBJECTDIR}/_ext/1472/console.o ${OBJECTDIR}/_ext/748590006/main.o ${OBJECTDIR}/_ext/1727389914/kb.o

# Source Files
SOURCEFILES=../app/icm42688p.c ../app/icm42688_sensor.c ../app/mikro_spi.c ../app/ringbuffer.c ../knowledge-pack/application/sml_output.c ../knowledge-pack/application/sml_recognition_run.c ../bsp/led0.c ../bsp/led1.c ../bsp/led2.c ../bsp/led3.c ../bsp/led4.c ../bsp/led5.c ../bsp/led6.c ../bsp/led7.c ../bsp/led_blue.c ../bsp/led_green.c ../bsp/led_red.c ../bsp/led_rgb.c ../bsp/pot.c ../bsp/s1.c ../bsp/s2.c ../bsp/s3.c ../bsp/task.c ../My_MCC_Config/mcc/mcc_generated_files/adc/src/adc3.c ../My_MCC_Config/mcc/mcc_generated_files/can/src/can1.c ../My_MCC_Config/mcc/mcc_generated_files/interrupt/src/ext_int.c ../My_MCC_Config/mcc/mcc_generated_files/pwm/src/sccp3.c ../My_MCC_Config/mcc/mcc_generated_files/pwm/src/sccp4.c ../My_MCC_Config/mcc/mcc_generated_files/pwm/src/sccp7.c ../My_MCC_Config/mcc/mcc_generated_files/spi_host/src/spi2.c ../My_MCC_Config/mcc/mcc_generated_files/system/src/clock.c ../My_MCC_Config/mcc/mcc_generated_files/system/src/config_bits.c ../My_MCC_Config/mcc/mcc_generated_files/system/src/dmt.c ../My_MCC_Config/mcc/mcc_generated_files/system/src/interrupt.c ../My_MCC_Config/mcc/mcc_generated_files/system/src/pins.c ../My_MCC_Config/mcc/mcc_generated_files/system/src/reset.c ../My_MCC_Config/mcc/mcc_generated_files/system/src/system.c ../My_MCC_Config/mcc/mcc_generated_files/system/src/traps.c ../My_MCC_Config/mcc/mcc_generated_files/timer/src/tmr1.c ../My_MCC_Config/mcc/mcc_generated_files/uart/src/uart1.c ../console.c ../My_MCC_Config/mcc/main.c ../knowledge-pack/mplabml/src/kb.c



CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-default.mk ${DISTDIR}/ak-gesture.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=33AK1024MPS614
MP_LINKER_FILE_OPTION=,--script=p33AK1024MPS614.gld
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/1360919890/icm42688p.o: ../app/icm42688p.c  .generated_files/flags/default/7e8e37e18a3feb4358bcfab3399f72c2f439b71a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360919890" 
	@${RM} ${OBJECTDIR}/_ext/1360919890/icm42688p.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360919890/icm42688p.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../app/icm42688p.c  -o ${OBJECTDIR}/_ext/1360919890/icm42688p.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360919890/icm42688p.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360919890/icm42688_sensor.o: ../app/icm42688_sensor.c  .generated_files/flags/default/961da0bf6faff8f5056df8e36808d4e00d9d4220 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360919890" 
	@${RM} ${OBJECTDIR}/_ext/1360919890/icm42688_sensor.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360919890/icm42688_sensor.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../app/icm42688_sensor.c  -o ${OBJECTDIR}/_ext/1360919890/icm42688_sensor.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360919890/icm42688_sensor.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360919890/mikro_spi.o: ../app/mikro_spi.c  .generated_files/flags/default/6ed842b4a2a0ebebe749ee9d93ddb41ce8ed7146 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360919890" 
	@${RM} ${OBJECTDIR}/_ext/1360919890/mikro_spi.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360919890/mikro_spi.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../app/mikro_spi.c  -o ${OBJECTDIR}/_ext/1360919890/mikro_spi.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360919890/mikro_spi.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360919890/ringbuffer.o: ../app/ringbuffer.c  .generated_files/flags/default/6f0fa1048c5fa6336758ba09263fa5c61a71ee2b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360919890" 
	@${RM} ${OBJECTDIR}/_ext/1360919890/ringbuffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360919890/ringbuffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../app/ringbuffer.c  -o ${OBJECTDIR}/_ext/1360919890/ringbuffer.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360919890/ringbuffer.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/959462024/sml_output.o: ../knowledge-pack/application/sml_output.c  .generated_files/flags/default/f61f0f661cf5075f3b9eb7fefa3c8221d262197d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/959462024" 
	@${RM} ${OBJECTDIR}/_ext/959462024/sml_output.o.d 
	@${RM} ${OBJECTDIR}/_ext/959462024/sml_output.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../knowledge-pack/application/sml_output.c  -o ${OBJECTDIR}/_ext/959462024/sml_output.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/959462024/sml_output.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/959462024/sml_recognition_run.o: ../knowledge-pack/application/sml_recognition_run.c  .generated_files/flags/default/17ea15cc6a2521c0fb531bdbfb7650a521c5bb73 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/959462024" 
	@${RM} ${OBJECTDIR}/_ext/959462024/sml_recognition_run.o.d 
	@${RM} ${OBJECTDIR}/_ext/959462024/sml_recognition_run.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../knowledge-pack/application/sml_recognition_run.c  -o ${OBJECTDIR}/_ext/959462024/sml_recognition_run.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/959462024/sml_recognition_run.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/led0.o: ../bsp/led0.c  .generated_files/flags/default/909c12f0f680c2c75fdbacf0143d71cdd95e4d2b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led0.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led0.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/led0.c  -o ${OBJECTDIR}/_ext/1360920944/led0.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/led0.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/led1.o: ../bsp/led1.c  .generated_files/flags/default/99ca278f00d8f3642b8946cc077f0fa15807487 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/led1.c  -o ${OBJECTDIR}/_ext/1360920944/led1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/led1.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/led2.o: ../bsp/led2.c  .generated_files/flags/default/1fa59134f1772a76c34972274eaf8d7298a69429 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/led2.c  -o ${OBJECTDIR}/_ext/1360920944/led2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/led2.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/led3.o: ../bsp/led3.c  .generated_files/flags/default/cfe48cfb83c7adbe03833481d2032b2be3324ecf .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led3.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led3.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/led3.c  -o ${OBJECTDIR}/_ext/1360920944/led3.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/led3.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/led4.o: ../bsp/led4.c  .generated_files/flags/default/d7d4199991667dfd412f5be0744ca8d868943b58 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led4.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led4.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/led4.c  -o ${OBJECTDIR}/_ext/1360920944/led4.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/led4.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/led5.o: ../bsp/led5.c  .generated_files/flags/default/5d209a2af637e1d3f3513dbae9f4dbcd60c24be9 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led5.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led5.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/led5.c  -o ${OBJECTDIR}/_ext/1360920944/led5.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/led5.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/led6.o: ../bsp/led6.c  .generated_files/flags/default/d0df041638e245ef9d953ae549c9e0b4f059fee4 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led6.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led6.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/led6.c  -o ${OBJECTDIR}/_ext/1360920944/led6.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/led6.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/led7.o: ../bsp/led7.c  .generated_files/flags/default/8eaf826e2ac80fc48b1c8dec4915457a4bd5b321 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led7.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led7.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/led7.c  -o ${OBJECTDIR}/_ext/1360920944/led7.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/led7.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/led_blue.o: ../bsp/led_blue.c  .generated_files/flags/default/14a01b8a479afabb5a84477968b6f82881f0e74c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led_blue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led_blue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/led_blue.c  -o ${OBJECTDIR}/_ext/1360920944/led_blue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/led_blue.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/led_green.o: ../bsp/led_green.c  .generated_files/flags/default/e54b30db3986276b109903ecaa2312758f106f47 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led_green.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led_green.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/led_green.c  -o ${OBJECTDIR}/_ext/1360920944/led_green.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/led_green.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/led_red.o: ../bsp/led_red.c  .generated_files/flags/default/6424b1ce36c55a583b8d9b58511cca812d58a1cb .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led_red.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led_red.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/led_red.c  -o ${OBJECTDIR}/_ext/1360920944/led_red.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/led_red.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/led_rgb.o: ../bsp/led_rgb.c  .generated_files/flags/default/e0c09c071dc09ad303d712bb738ec7234341ddbf .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led_rgb.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led_rgb.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/led_rgb.c  -o ${OBJECTDIR}/_ext/1360920944/led_rgb.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/led_rgb.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/pot.o: ../bsp/pot.c  .generated_files/flags/default/da940c976aef182137b052462071ed57a172fe39 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/pot.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/pot.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/pot.c  -o ${OBJECTDIR}/_ext/1360920944/pot.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/pot.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/s1.o: ../bsp/s1.c  .generated_files/flags/default/f92746a87c4ad23217ccf3c65d37088b0eefbb96 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/s1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/s1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/s1.c  -o ${OBJECTDIR}/_ext/1360920944/s1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/s1.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/s2.o: ../bsp/s2.c  .generated_files/flags/default/69ed958da4bb7648e6636924da7cc2aceb23cd42 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/s2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/s2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/s2.c  -o ${OBJECTDIR}/_ext/1360920944/s2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/s2.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/s3.o: ../bsp/s3.c  .generated_files/flags/default/4e0026023ce7fef66117ac38c39fb7db716b85ca .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/s3.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/s3.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/s3.c  -o ${OBJECTDIR}/_ext/1360920944/s3.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/s3.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/task.o: ../bsp/task.c  .generated_files/flags/default/eb0f93db02932a7f34660178a69d8e12e02cd079 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/task.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/task.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/task.c  -o ${OBJECTDIR}/_ext/1360920944/task.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/task.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1976684066/adc3.o: ../My_MCC_Config/mcc/mcc_generated_files/adc/src/adc3.c  .generated_files/flags/default/2886d2df03acdc4e253ff9d45b439efcfa2505a8 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1976684066" 
	@${RM} ${OBJECTDIR}/_ext/1976684066/adc3.o.d 
	@${RM} ${OBJECTDIR}/_ext/1976684066/adc3.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/adc/src/adc3.c  -o ${OBJECTDIR}/_ext/1976684066/adc3.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1976684066/adc3.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/619004590/can1.o: ../My_MCC_Config/mcc/mcc_generated_files/can/src/can1.c  .generated_files/flags/default/7f0954dccb944fdfa105c85aa98c7c3089a3fdfe .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/619004590" 
	@${RM} ${OBJECTDIR}/_ext/619004590/can1.o.d 
	@${RM} ${OBJECTDIR}/_ext/619004590/can1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/can/src/can1.c  -o ${OBJECTDIR}/_ext/619004590/can1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/619004590/can1.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1955452069/ext_int.o: ../My_MCC_Config/mcc/mcc_generated_files/interrupt/src/ext_int.c  .generated_files/flags/default/e236a3c04bffbba194bf3ab5e32cf518e869a04a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1955452069" 
	@${RM} ${OBJECTDIR}/_ext/1955452069/ext_int.o.d 
	@${RM} ${OBJECTDIR}/_ext/1955452069/ext_int.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/interrupt/src/ext_int.c  -o ${OBJECTDIR}/_ext/1955452069/ext_int.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1955452069/ext_int.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1337440824/sccp3.o: ../My_MCC_Config/mcc/mcc_generated_files/pwm/src/sccp3.c  .generated_files/flags/default/cea6bd3d2bf44f122a5cb6dc5b6b6a6d726f0516 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1337440824" 
	@${RM} ${OBJECTDIR}/_ext/1337440824/sccp3.o.d 
	@${RM} ${OBJECTDIR}/_ext/1337440824/sccp3.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/pwm/src/sccp3.c  -o ${OBJECTDIR}/_ext/1337440824/sccp3.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1337440824/sccp3.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1337440824/sccp4.o: ../My_MCC_Config/mcc/mcc_generated_files/pwm/src/sccp4.c  .generated_files/flags/default/ce04adc1b2931e530bd09eb65cdbb37bac61f5c3 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1337440824" 
	@${RM} ${OBJECTDIR}/_ext/1337440824/sccp4.o.d 
	@${RM} ${OBJECTDIR}/_ext/1337440824/sccp4.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/pwm/src/sccp4.c  -o ${OBJECTDIR}/_ext/1337440824/sccp4.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1337440824/sccp4.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1337440824/sccp7.o: ../My_MCC_Config/mcc/mcc_generated_files/pwm/src/sccp7.c  .generated_files/flags/default/27971c08f29995fb56659c9a7c9c3353d2204c0 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1337440824" 
	@${RM} ${OBJECTDIR}/_ext/1337440824/sccp7.o.d 
	@${RM} ${OBJECTDIR}/_ext/1337440824/sccp7.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/pwm/src/sccp7.c  -o ${OBJECTDIR}/_ext/1337440824/sccp7.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1337440824/sccp7.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1565449251/spi2.o: ../My_MCC_Config/mcc/mcc_generated_files/spi_host/src/spi2.c  .generated_files/flags/default/efe37dffc794f373a87fb537214ac967ab7b8d8a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1565449251" 
	@${RM} ${OBJECTDIR}/_ext/1565449251/spi2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1565449251/spi2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/spi_host/src/spi2.c  -o ${OBJECTDIR}/_ext/1565449251/spi2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1565449251/spi2.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/924153673/clock.o: ../My_MCC_Config/mcc/mcc_generated_files/system/src/clock.c  .generated_files/flags/default/4861bd8675fc27a37e73ecaec7256be2ea0c31e2 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/924153673" 
	@${RM} ${OBJECTDIR}/_ext/924153673/clock.o.d 
	@${RM} ${OBJECTDIR}/_ext/924153673/clock.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/system/src/clock.c  -o ${OBJECTDIR}/_ext/924153673/clock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/924153673/clock.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/924153673/config_bits.o: ../My_MCC_Config/mcc/mcc_generated_files/system/src/config_bits.c  .generated_files/flags/default/587550f54d3cbde43dfdc59cabeddc9e4067dc5c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/924153673" 
	@${RM} ${OBJECTDIR}/_ext/924153673/config_bits.o.d 
	@${RM} ${OBJECTDIR}/_ext/924153673/config_bits.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/system/src/config_bits.c  -o ${OBJECTDIR}/_ext/924153673/config_bits.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/924153673/config_bits.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/924153673/dmt.o: ../My_MCC_Config/mcc/mcc_generated_files/system/src/dmt.c  .generated_files/flags/default/d275d52baca055b2c836e8f7489c88f65f2d2977 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/924153673" 
	@${RM} ${OBJECTDIR}/_ext/924153673/dmt.o.d 
	@${RM} ${OBJECTDIR}/_ext/924153673/dmt.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/system/src/dmt.c  -o ${OBJECTDIR}/_ext/924153673/dmt.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/924153673/dmt.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/924153673/interrupt.o: ../My_MCC_Config/mcc/mcc_generated_files/system/src/interrupt.c  .generated_files/flags/default/13fc3bb22578cfa5656ba433ca9cfac50fa2d31 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/924153673" 
	@${RM} ${OBJECTDIR}/_ext/924153673/interrupt.o.d 
	@${RM} ${OBJECTDIR}/_ext/924153673/interrupt.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/system/src/interrupt.c  -o ${OBJECTDIR}/_ext/924153673/interrupt.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/924153673/interrupt.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/924153673/pins.o: ../My_MCC_Config/mcc/mcc_generated_files/system/src/pins.c  .generated_files/flags/default/72bae9f4b0cd063d71313f522c6d649132347ada .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/924153673" 
	@${RM} ${OBJECTDIR}/_ext/924153673/pins.o.d 
	@${RM} ${OBJECTDIR}/_ext/924153673/pins.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/system/src/pins.c  -o ${OBJECTDIR}/_ext/924153673/pins.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/924153673/pins.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/924153673/reset.o: ../My_MCC_Config/mcc/mcc_generated_files/system/src/reset.c  .generated_files/flags/default/a6008caacfe5e73d705e01015b95f1797dc69982 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/924153673" 
	@${RM} ${OBJECTDIR}/_ext/924153673/reset.o.d 
	@${RM} ${OBJECTDIR}/_ext/924153673/reset.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/system/src/reset.c  -o ${OBJECTDIR}/_ext/924153673/reset.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/924153673/reset.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/924153673/system.o: ../My_MCC_Config/mcc/mcc_generated_files/system/src/system.c  .generated_files/flags/default/55370f00fa19e22684a98e8f465c18f4fae57503 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/924153673" 
	@${RM} ${OBJECTDIR}/_ext/924153673/system.o.d 
	@${RM} ${OBJECTDIR}/_ext/924153673/system.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/system/src/system.c  -o ${OBJECTDIR}/_ext/924153673/system.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/924153673/system.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/924153673/traps.o: ../My_MCC_Config/mcc/mcc_generated_files/system/src/traps.c  .generated_files/flags/default/413900494cc5fb93828ba7534d6193fa787222d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/924153673" 
	@${RM} ${OBJECTDIR}/_ext/924153673/traps.o.d 
	@${RM} ${OBJECTDIR}/_ext/924153673/traps.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/system/src/traps.c  -o ${OBJECTDIR}/_ext/924153673/traps.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/924153673/traps.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1106728185/tmr1.o: ../My_MCC_Config/mcc/mcc_generated_files/timer/src/tmr1.c  .generated_files/flags/default/9d50b33fbc4fa48d4f263f686ab93b0bda19b7f0 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1106728185" 
	@${RM} ${OBJECTDIR}/_ext/1106728185/tmr1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1106728185/tmr1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/timer/src/tmr1.c  -o ${OBJECTDIR}/_ext/1106728185/tmr1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1106728185/tmr1.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/527242858/uart1.o: ../My_MCC_Config/mcc/mcc_generated_files/uart/src/uart1.c  .generated_files/flags/default/b887acf98cd9f96f7f438967d4996535339be56d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/527242858" 
	@${RM} ${OBJECTDIR}/_ext/527242858/uart1.o.d 
	@${RM} ${OBJECTDIR}/_ext/527242858/uart1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/uart/src/uart1.c  -o ${OBJECTDIR}/_ext/527242858/uart1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/527242858/uart1.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1472/console.o: ../console.c  .generated_files/flags/default/cc172128979d8ecd9a0f453bb71b5bd249d7035b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1472" 
	@${RM} ${OBJECTDIR}/_ext/1472/console.o.d 
	@${RM} ${OBJECTDIR}/_ext/1472/console.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../console.c  -o ${OBJECTDIR}/_ext/1472/console.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1472/console.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/748590006/main.o: ../My_MCC_Config/mcc/main.c  .generated_files/flags/default/977485aec18806b758bf9a406c080355f53e4871 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/748590006" 
	@${RM} ${OBJECTDIR}/_ext/748590006/main.o.d 
	@${RM} ${OBJECTDIR}/_ext/748590006/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/main.c  -o ${OBJECTDIR}/_ext/748590006/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/748590006/main.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1727389914/kb.o: ../knowledge-pack/mplabml/src/kb.c  .generated_files/flags/default/e5584eddaafbf63d7ca2e8a9a05b9db5c1f792bf .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1727389914" 
	@${RM} ${OBJECTDIR}/_ext/1727389914/kb.o.d 
	@${RM} ${OBJECTDIR}/_ext/1727389914/kb.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../knowledge-pack/mplabml/src/kb.c  -o ${OBJECTDIR}/_ext/1727389914/kb.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1727389914/kb.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1    -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
else
${OBJECTDIR}/_ext/1360919890/icm42688p.o: ../app/icm42688p.c  .generated_files/flags/default/c454786e401b907e324dc17eeb64c59f83e03669 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360919890" 
	@${RM} ${OBJECTDIR}/_ext/1360919890/icm42688p.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360919890/icm42688p.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../app/icm42688p.c  -o ${OBJECTDIR}/_ext/1360919890/icm42688p.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360919890/icm42688p.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360919890/icm42688_sensor.o: ../app/icm42688_sensor.c  .generated_files/flags/default/413d388ffed2876578f6901327a05c78e55064b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360919890" 
	@${RM} ${OBJECTDIR}/_ext/1360919890/icm42688_sensor.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360919890/icm42688_sensor.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../app/icm42688_sensor.c  -o ${OBJECTDIR}/_ext/1360919890/icm42688_sensor.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360919890/icm42688_sensor.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360919890/mikro_spi.o: ../app/mikro_spi.c  .generated_files/flags/default/ff8b07a7b7716ff1fc3bc1e089cda3d308e8c58 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360919890" 
	@${RM} ${OBJECTDIR}/_ext/1360919890/mikro_spi.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360919890/mikro_spi.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../app/mikro_spi.c  -o ${OBJECTDIR}/_ext/1360919890/mikro_spi.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360919890/mikro_spi.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360919890/ringbuffer.o: ../app/ringbuffer.c  .generated_files/flags/default/61d3a7fe39268641b63246dfa2185d519f7e699d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360919890" 
	@${RM} ${OBJECTDIR}/_ext/1360919890/ringbuffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360919890/ringbuffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../app/ringbuffer.c  -o ${OBJECTDIR}/_ext/1360919890/ringbuffer.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360919890/ringbuffer.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/959462024/sml_output.o: ../knowledge-pack/application/sml_output.c  .generated_files/flags/default/ff89a0baf9fd9f33dc6be82dda3f1d67d30ff96d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/959462024" 
	@${RM} ${OBJECTDIR}/_ext/959462024/sml_output.o.d 
	@${RM} ${OBJECTDIR}/_ext/959462024/sml_output.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../knowledge-pack/application/sml_output.c  -o ${OBJECTDIR}/_ext/959462024/sml_output.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/959462024/sml_output.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/959462024/sml_recognition_run.o: ../knowledge-pack/application/sml_recognition_run.c  .generated_files/flags/default/228c3a85b6f1596227a8e1fea6e434574eeba8ab .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/959462024" 
	@${RM} ${OBJECTDIR}/_ext/959462024/sml_recognition_run.o.d 
	@${RM} ${OBJECTDIR}/_ext/959462024/sml_recognition_run.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../knowledge-pack/application/sml_recognition_run.c  -o ${OBJECTDIR}/_ext/959462024/sml_recognition_run.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/959462024/sml_recognition_run.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/led0.o: ../bsp/led0.c  .generated_files/flags/default/5330a2759be42aed33e436abad981584361c38dc .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led0.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led0.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/led0.c  -o ${OBJECTDIR}/_ext/1360920944/led0.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/led0.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/led1.o: ../bsp/led1.c  .generated_files/flags/default/52961527d368718173ad5d9f7c7c6970659016a9 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/led1.c  -o ${OBJECTDIR}/_ext/1360920944/led1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/led1.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/led2.o: ../bsp/led2.c  .generated_files/flags/default/e48675bc5f9435307044e52dc04d1f1f600ccb2a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/led2.c  -o ${OBJECTDIR}/_ext/1360920944/led2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/led2.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/led3.o: ../bsp/led3.c  .generated_files/flags/default/b12d50e2895f120a667d45f3c212735ac2661705 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led3.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led3.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/led3.c  -o ${OBJECTDIR}/_ext/1360920944/led3.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/led3.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/led4.o: ../bsp/led4.c  .generated_files/flags/default/5b488dc47356477180d3f1430055d5ae01b55c77 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led4.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led4.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/led4.c  -o ${OBJECTDIR}/_ext/1360920944/led4.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/led4.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/led5.o: ../bsp/led5.c  .generated_files/flags/default/b4780c64b07fda39d55d8777b90652fea32e0c74 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led5.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led5.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/led5.c  -o ${OBJECTDIR}/_ext/1360920944/led5.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/led5.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/led6.o: ../bsp/led6.c  .generated_files/flags/default/f8902927420c0b6fb577b281f394282722148707 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led6.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led6.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/led6.c  -o ${OBJECTDIR}/_ext/1360920944/led6.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/led6.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/led7.o: ../bsp/led7.c  .generated_files/flags/default/3400e0d6f48961270708eecea75b1f0fe62a3fa4 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led7.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led7.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/led7.c  -o ${OBJECTDIR}/_ext/1360920944/led7.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/led7.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/led_blue.o: ../bsp/led_blue.c  .generated_files/flags/default/cc3ee15e01db17be0ec7b6fdb636a09225c2e59b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led_blue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led_blue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/led_blue.c  -o ${OBJECTDIR}/_ext/1360920944/led_blue.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/led_blue.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/led_green.o: ../bsp/led_green.c  .generated_files/flags/default/371290ad05dfaf6e15a3c586f8c1ff782f7416d8 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led_green.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led_green.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/led_green.c  -o ${OBJECTDIR}/_ext/1360920944/led_green.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/led_green.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/led_red.o: ../bsp/led_red.c  .generated_files/flags/default/4462c25c1e0c6720291826d73f0d61a61024dc22 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led_red.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led_red.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/led_red.c  -o ${OBJECTDIR}/_ext/1360920944/led_red.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/led_red.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/led_rgb.o: ../bsp/led_rgb.c  .generated_files/flags/default/c7229b92926f62935ee21a9321f1d78f923e4c15 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led_rgb.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/led_rgb.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/led_rgb.c  -o ${OBJECTDIR}/_ext/1360920944/led_rgb.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/led_rgb.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/pot.o: ../bsp/pot.c  .generated_files/flags/default/3c6841069bfdef11bb4556e3ca1a1e13916380dd .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/pot.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/pot.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/pot.c  -o ${OBJECTDIR}/_ext/1360920944/pot.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/pot.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/s1.o: ../bsp/s1.c  .generated_files/flags/default/121bbfb3b64843f8cb82de42f9bb697a97b4bda5 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/s1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/s1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/s1.c  -o ${OBJECTDIR}/_ext/1360920944/s1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/s1.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/s2.o: ../bsp/s2.c  .generated_files/flags/default/ca908c08a2591a19381719645a0e640a2ff6e05c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/s2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/s2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/s2.c  -o ${OBJECTDIR}/_ext/1360920944/s2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/s2.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/s3.o: ../bsp/s3.c  .generated_files/flags/default/e1b02fd8b3ce243267365c967300a7aec0fee695 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/s3.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/s3.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/s3.c  -o ${OBJECTDIR}/_ext/1360920944/s3.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/s3.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1360920944/task.o: ../bsp/task.c  .generated_files/flags/default/b8fb92558c0bb9d33b72a3e0ab3fa30be2b2e2b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360920944" 
	@${RM} ${OBJECTDIR}/_ext/1360920944/task.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360920944/task.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../bsp/task.c  -o ${OBJECTDIR}/_ext/1360920944/task.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1360920944/task.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1976684066/adc3.o: ../My_MCC_Config/mcc/mcc_generated_files/adc/src/adc3.c  .generated_files/flags/default/5ffd9f7a6592aee39ed09b637ba37a799e2b30cf .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1976684066" 
	@${RM} ${OBJECTDIR}/_ext/1976684066/adc3.o.d 
	@${RM} ${OBJECTDIR}/_ext/1976684066/adc3.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/adc/src/adc3.c  -o ${OBJECTDIR}/_ext/1976684066/adc3.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1976684066/adc3.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/619004590/can1.o: ../My_MCC_Config/mcc/mcc_generated_files/can/src/can1.c  .generated_files/flags/default/f3f18cab1204cea522d6fc413b913c83c58d0a5a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/619004590" 
	@${RM} ${OBJECTDIR}/_ext/619004590/can1.o.d 
	@${RM} ${OBJECTDIR}/_ext/619004590/can1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/can/src/can1.c  -o ${OBJECTDIR}/_ext/619004590/can1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/619004590/can1.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1955452069/ext_int.o: ../My_MCC_Config/mcc/mcc_generated_files/interrupt/src/ext_int.c  .generated_files/flags/default/683ec8f520bf12659c527b662fe87ed6b53b8514 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1955452069" 
	@${RM} ${OBJECTDIR}/_ext/1955452069/ext_int.o.d 
	@${RM} ${OBJECTDIR}/_ext/1955452069/ext_int.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/interrupt/src/ext_int.c  -o ${OBJECTDIR}/_ext/1955452069/ext_int.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1955452069/ext_int.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1337440824/sccp3.o: ../My_MCC_Config/mcc/mcc_generated_files/pwm/src/sccp3.c  .generated_files/flags/default/d4430c8e34aa54c0bcfd9fb98b2d9bd54d44d74a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1337440824" 
	@${RM} ${OBJECTDIR}/_ext/1337440824/sccp3.o.d 
	@${RM} ${OBJECTDIR}/_ext/1337440824/sccp3.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/pwm/src/sccp3.c  -o ${OBJECTDIR}/_ext/1337440824/sccp3.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1337440824/sccp3.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1337440824/sccp4.o: ../My_MCC_Config/mcc/mcc_generated_files/pwm/src/sccp4.c  .generated_files/flags/default/760581c0b5340038cb796cca68f094803e06a8ac .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1337440824" 
	@${RM} ${OBJECTDIR}/_ext/1337440824/sccp4.o.d 
	@${RM} ${OBJECTDIR}/_ext/1337440824/sccp4.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/pwm/src/sccp4.c  -o ${OBJECTDIR}/_ext/1337440824/sccp4.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1337440824/sccp4.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1337440824/sccp7.o: ../My_MCC_Config/mcc/mcc_generated_files/pwm/src/sccp7.c  .generated_files/flags/default/7c073537aec18d642f78f9c9f119c595e168dfc .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1337440824" 
	@${RM} ${OBJECTDIR}/_ext/1337440824/sccp7.o.d 
	@${RM} ${OBJECTDIR}/_ext/1337440824/sccp7.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/pwm/src/sccp7.c  -o ${OBJECTDIR}/_ext/1337440824/sccp7.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1337440824/sccp7.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1565449251/spi2.o: ../My_MCC_Config/mcc/mcc_generated_files/spi_host/src/spi2.c  .generated_files/flags/default/b9c829baaf2c76e45f1afd023e0fcbc0bcd4c91 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1565449251" 
	@${RM} ${OBJECTDIR}/_ext/1565449251/spi2.o.d 
	@${RM} ${OBJECTDIR}/_ext/1565449251/spi2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/spi_host/src/spi2.c  -o ${OBJECTDIR}/_ext/1565449251/spi2.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1565449251/spi2.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/924153673/clock.o: ../My_MCC_Config/mcc/mcc_generated_files/system/src/clock.c  .generated_files/flags/default/5fc99831aa9611d42bc90346d11031512aeb7a8e .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/924153673" 
	@${RM} ${OBJECTDIR}/_ext/924153673/clock.o.d 
	@${RM} ${OBJECTDIR}/_ext/924153673/clock.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/system/src/clock.c  -o ${OBJECTDIR}/_ext/924153673/clock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/924153673/clock.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/924153673/config_bits.o: ../My_MCC_Config/mcc/mcc_generated_files/system/src/config_bits.c  .generated_files/flags/default/8d6740f25213e7bc379f2dcbe7556850f5102b51 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/924153673" 
	@${RM} ${OBJECTDIR}/_ext/924153673/config_bits.o.d 
	@${RM} ${OBJECTDIR}/_ext/924153673/config_bits.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/system/src/config_bits.c  -o ${OBJECTDIR}/_ext/924153673/config_bits.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/924153673/config_bits.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/924153673/dmt.o: ../My_MCC_Config/mcc/mcc_generated_files/system/src/dmt.c  .generated_files/flags/default/db646e8034db797cd4ead7d744041303b32bc68a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/924153673" 
	@${RM} ${OBJECTDIR}/_ext/924153673/dmt.o.d 
	@${RM} ${OBJECTDIR}/_ext/924153673/dmt.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/system/src/dmt.c  -o ${OBJECTDIR}/_ext/924153673/dmt.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/924153673/dmt.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/924153673/interrupt.o: ../My_MCC_Config/mcc/mcc_generated_files/system/src/interrupt.c  .generated_files/flags/default/f1092ad5d53fe77da556a324116505cea78659a4 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/924153673" 
	@${RM} ${OBJECTDIR}/_ext/924153673/interrupt.o.d 
	@${RM} ${OBJECTDIR}/_ext/924153673/interrupt.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/system/src/interrupt.c  -o ${OBJECTDIR}/_ext/924153673/interrupt.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/924153673/interrupt.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/924153673/pins.o: ../My_MCC_Config/mcc/mcc_generated_files/system/src/pins.c  .generated_files/flags/default/121cfb5d01054fed3a9f81e232b602d395428b08 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/924153673" 
	@${RM} ${OBJECTDIR}/_ext/924153673/pins.o.d 
	@${RM} ${OBJECTDIR}/_ext/924153673/pins.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/system/src/pins.c  -o ${OBJECTDIR}/_ext/924153673/pins.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/924153673/pins.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/924153673/reset.o: ../My_MCC_Config/mcc/mcc_generated_files/system/src/reset.c  .generated_files/flags/default/c054584809b93e2967a4de8cc59a272210e4db8b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/924153673" 
	@${RM} ${OBJECTDIR}/_ext/924153673/reset.o.d 
	@${RM} ${OBJECTDIR}/_ext/924153673/reset.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/system/src/reset.c  -o ${OBJECTDIR}/_ext/924153673/reset.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/924153673/reset.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/924153673/system.o: ../My_MCC_Config/mcc/mcc_generated_files/system/src/system.c  .generated_files/flags/default/1d567db1df1f440fec583e21a675d52ce06b2c6 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/924153673" 
	@${RM} ${OBJECTDIR}/_ext/924153673/system.o.d 
	@${RM} ${OBJECTDIR}/_ext/924153673/system.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/system/src/system.c  -o ${OBJECTDIR}/_ext/924153673/system.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/924153673/system.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/924153673/traps.o: ../My_MCC_Config/mcc/mcc_generated_files/system/src/traps.c  .generated_files/flags/default/7569d9f040ea45e34a3ca11ae3b4405225d6b2f3 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/924153673" 
	@${RM} ${OBJECTDIR}/_ext/924153673/traps.o.d 
	@${RM} ${OBJECTDIR}/_ext/924153673/traps.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/system/src/traps.c  -o ${OBJECTDIR}/_ext/924153673/traps.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/924153673/traps.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1106728185/tmr1.o: ../My_MCC_Config/mcc/mcc_generated_files/timer/src/tmr1.c  .generated_files/flags/default/c0a400cc9e46f8ab37ec09692ab63c32b4db4dad .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1106728185" 
	@${RM} ${OBJECTDIR}/_ext/1106728185/tmr1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1106728185/tmr1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/timer/src/tmr1.c  -o ${OBJECTDIR}/_ext/1106728185/tmr1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1106728185/tmr1.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/527242858/uart1.o: ../My_MCC_Config/mcc/mcc_generated_files/uart/src/uart1.c  .generated_files/flags/default/12f82e721390511c87811c2c2387cdb4b44c5a3a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/527242858" 
	@${RM} ${OBJECTDIR}/_ext/527242858/uart1.o.d 
	@${RM} ${OBJECTDIR}/_ext/527242858/uart1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/mcc_generated_files/uart/src/uart1.c  -o ${OBJECTDIR}/_ext/527242858/uart1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/527242858/uart1.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1472/console.o: ../console.c  .generated_files/flags/default/ebc7fd92a6ce72ce4d78295ef1aca185b1648f7c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1472" 
	@${RM} ${OBJECTDIR}/_ext/1472/console.o.d 
	@${RM} ${OBJECTDIR}/_ext/1472/console.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../console.c  -o ${OBJECTDIR}/_ext/1472/console.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1472/console.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/748590006/main.o: ../My_MCC_Config/mcc/main.c  .generated_files/flags/default/f52549199bfc6040ae6d78dd008a9c506a7185fc .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/748590006" 
	@${RM} ${OBJECTDIR}/_ext/748590006/main.o.d 
	@${RM} ${OBJECTDIR}/_ext/748590006/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../My_MCC_Config/mcc/main.c  -o ${OBJECTDIR}/_ext/748590006/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/748590006/main.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1727389914/kb.o: ../knowledge-pack/mplabml/src/kb.c  .generated_files/flags/default/a68b5a5e080c5d85d39e28464959762cdef53e47 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1727389914" 
	@${RM} ${OBJECTDIR}/_ext/1727389914/kb.o.d 
	@${RM} ${OBJECTDIR}/_ext/1727389914/kb.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../knowledge-pack/mplabml/src/kb.c  -o ${OBJECTDIR}/_ext/1727389914/kb.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1727389914/kb.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O1 -I"../app" -I"../bsp" -I"../knowledge-pack/application" -I"../" -I"../My_MCC_Config/mcc/mcc_generated_files" -I"../knowledge-pack/mplabml/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemblePreproc
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${DISTDIR}/ak-gesture.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o ${DISTDIR}/ak-gesture.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)        -D__DEBUG=__DEBUG -D__MPLAB_DEBUGGER_PKOB4=1  -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)      -Wl,,,--defsym=__MPLAB_BUILD=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,-D__DEBUG=__DEBUG,--defsym=__MPLAB_DEBUGGER_PKOB4=1,$(MP_LINKER_FILE_OPTION),--stack=16,--check-sections,--data-init,--pack-data,--handles,--no-gc-sections,--fill-upper=0,--stackguard=16,--ivt,--isr,--no-force-link,--smart-io,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--report-mem,--memorysummary,${DISTDIR}/memoryfile.xml$(MP_EXTRA_LD_POST)  -mdfp="${DFP_DIR}/xc16" 
	
else
${DISTDIR}/ak-gesture.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o ${DISTDIR}/ak-gesture.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)        -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -Wl,,,--defsym=__MPLAB_BUILD=1,$(MP_LINKER_FILE_OPTION),--stack=16,--check-sections,--data-init,--pack-data,--handles,--no-gc-sections,--fill-upper=0,--stackguard=16,--ivt,--isr,--no-force-link,--smart-io,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--report-mem,--memorysummary,${DISTDIR}/memoryfile.xml$(MP_EXTRA_LD_POST)  -mdfp="${DFP_DIR}/xc16" 
	${MP_CC_DIR}\\xc-dsc-bin2hex ${DISTDIR}/ak-gesture.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} -a  -omf=elf   -mdfp="${DFP_DIR}/xc16" 
	
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r ${OBJECTDIR}
	${RM} -r ${DISTDIR}

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(wildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
