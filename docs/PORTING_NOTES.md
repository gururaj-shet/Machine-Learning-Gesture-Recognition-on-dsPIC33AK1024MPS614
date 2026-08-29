# CK → AK Porting Notes

Detailed enumeration of every change vs. the original
`ml-dsPIC33CK-Curiosity-Gestures-Recognition` repository, and the reason
for each change.

## 1. MCU / toolchain

| Aspect          | CK (source)                       | AK (this port)                          |
|-----------------|------------------------------------|------------------------------------------|
| MCU             | dsPIC33CK256MP508                  | dsPIC33AK1024MPS614                      |
| ISA             | 16-bit dsPIC33C                    | **32-bit dsPIC33A**                      |
| Compiler        | XC16                               | **XC-DSC v3.31**                         |
| DFP             | dsPIC33CK256MP508_DFP              | **dsPIC33AK-MP_DEV_DFP 0.2.350**         |
| IDE             | MPLAB X + MCC Classic              | **MPLAB Tools for VS Code + MCC Melody + CMake** |
| Fcy             | 100 MHz                            | **200 MHz**                              |

Consequences:

- The pre-compiled `libmplabml.a` from the CK project is XC16 and **will
  not link** with XC-DSC. The knowledge pack must be regenerated
  targeting `dsPIC33AK1024MPS614` — either as a fresh `.a` for XC-DSC or
  (preferred) as **Source Format** (.c files) which compiles cleanly on
  either ISA.
- `ringbuffer_size_t` widened from `uint16_t` (XC16) to `uint32_t` on
  XC-DSC — see the added `defined(__XC_DSC__)` branch in
  `app/ringbuffer.h`.
- Peripheral driver APIs are Melody-style function-pointer structs
  (`Timer1`, `UART1_Drv`, `led3`, …) instead of MCC-Classic global
  functions (`TMR1_Start()`, `UART1_Write()`).

## 2. Sensor: BMI160 → ICM-42688-P

| Aspect                | BMI160 (CK)                    | ICM-42688-P (AK)                          |
|-----------------------|--------------------------------|--------------------------------------------|
| Vendor                | Bosch Sensortec                | TDK InvenSense                             |
| Click board           | 6DOF IMU 2 Click (I²C on CK)   | 6DOF IMU 14 Click (**SPI**)               |
| WHO_AM_I              | 0x00 → 0xD1                    | **0x75 → 0x47**                            |
| Accel FS @ ±2 g       | 16 384 LSB/g (16-bit)          | **16 384 LSB/g** (16-bit) — identical    |
| Gyro FS @ ±2000 dps   | 16.4 LSB/(°/s)                 | 16.4 LSB/(°/s) — identical                |
| ODR path              | ODR bit-field ACC_CONF/GYR_CONF | ACCEL_CONFIG0[3:0] / GYRO_CONFIG0[3:0]    |
| DRDY interrupt        | INT1 pin, latch off, edge      | INT1 pin, latched, push-pull, active-high  |

Because the accelerometer sensitivity at ±2 g is byte-identical between
the two devices, **the trained ML model transfers without retraining**.
The demo keeps the same `SNSR_SAMPLE_RATE = 100` and `SNSR_ACCEL_RANGE = 2`.

### Driver strategy

The upstream CK project has an `app_config/icm42688/icm42688_sensor.c`
stub that depends on TDK's `Icm426xxDriver_HL` (eMD driver, tens of
files, ~4 kSLOC). To keep this port lean and self-contained I wrote a
**minimal register-level driver** covering only what the demo needs
(`app/icm42688p.[ch]` + `app/icm42688p_regs.h`, ≈ 260 SLOC total). No
TDK eMD dependency.

Feature coverage of the mini driver:

- soft reset + WHO_AM_I check
- bank-0-only accesses (no bank switching)
- accel FS: ±2/±4/±8/±16 g
- gyro FS: ±125/±250/±500/±1000/±2000 dps
- ODR: 25/50/100/200/1000 Hz
- low-noise power mode for accel + gyro (configurable independently)
- INT1 push-pull, active-high, latched, UI-DRDY source
- burst read of 12 bytes (accel X/Y/Z + gyro X/Y/Z) with big → little
  endian unpack

## 3. Bus: I²C1 → SPI1

The CK demo runs BMI160 over I²C (400 kHz). The 6DOF IMU 14 Click ships
with SPI as its default (jumpered) interface, and SPI gives significantly
lower ISR latency for a 100 Hz DRDY stream. The wrapper
`app/mikro_spi.[ch]` binds the ICM driver's `serif` read/write callbacks
to MCC Melody's `SPI1_ByteExchange` + the `MIKRO1_CS` GPIO. This is the
**only** file that touches the specific SPI vendor API — swap it out to
retarget to I²C or another SPI driver.

## 4. LEDs

CK BSP:
- Global `LED_*_On/Off/Toggle` macros mapped to Melody-Classic
  `LED_*_SetHigh/SetLow/Toggle`.

AK BSP (from OOB demo):
- `struct LED_SIMPLE`-based function pointers (`led3.on()` etc).

Mapping performed inside `app/app_config.h` using thin macro wrappers so
that `main.c` retains the CK-style call sites (`LED_STATUS_On()`,
`LED_GREEN_Toggle()`, …).

## 5. Tick + timing helpers

The CK `main.c` embedded its own `sleep_ms/sleep_us` using TMR1 counter
reads. On the AK we:

- Register `app_tick_handler` with `TMR1_TimeoutCallbackRegister`; TMR1
  ticks at 1 ms.
- Provide non-weak `snsr_sleep_ms` (spins on `g_tick_ms`) and
  `snsr_sleep_us` (short cycle-count busy-wait; adequate for the ICM
  init sequence — the driver only calls it during setup).
- Also feed `TASK_InterruptHandler()` from the same tick so the OOB
  BSP task scheduler keeps working if reused.

## 6. Knowledge pack

The `knowledge-pack/` folder contains:

- `model.json` — the original pipeline definition (unchanged).
- `application/sml_output.[ch]` + `sml_recognition_run.[ch]` — thin
  wrappers around `kb_run_model()`. Only two edits vs. CK:
  1. Removed CK-specific model name `KB_MODEL_DSPIC_33_CK_...` in favor
     of the neutral index constant `KB_MODEL_INDEX = 0`.
  2. Explicit `\r\n` line endings and `printf`-friendly guard for
     `_write` redirection.

**You must regenerate the `mplabml/` output** from MPLAB Machine
Learning Development Suite:

- Import the same training dataset (`dataset/*.csv`) and use `model.json`
  as reference for the pipeline.
- Set target device = `dsPIC33AK1024MPS614`, compiler = XC-DSC.
- Choose **Source Format** (recommended) so `mplabml/inc/*.h` and
  `mplabml/src/*.c` are produced. This makes the pack portable across
  XC16/XC-DSC without library recompilation.
- Drop the resulting `mplabml/` folder next to `application/` inside
  `knowledge-pack/`.

## 7. Files removed vs. CK

- `bmi160/` — Bosch driver, not used on AK.
- `app_config/bmi160/` — its adapter.
- MPLAB X `nbproject/` — replaced by the VS Code `.vscode/*.mplab.json`
  file from the OOB demo.
- `dspic33ck-curiosity-ml-gestures-demo.X/MyConfig.mc3` — Classic MCC
  config; replaced by Melody `mcc.json` output the user regenerates.

## 8. Behaviour parity check

| Aspect                          | CK             | AK             |
|---------------------------------|----------------|----------------|
| Sample rate                     | 100 Hz         | 100 Hz         |
| Accel full-scale                | ±2 g           | ±2 g           |
| Gyro enabled                    | false          | false          |
| Sample word type                | `int16_t`      | `int16_t`      |
| Ring buffer depth               | 256 samples    | 256 samples    |
| Majority-vote history           | 5              | 5              |
| Vote threshold                  | 3-of-5         | 3-of-5         |
| LED indication pattern          | see main.c     | matches CK     |

If the classifier output rate on the AK differs from the CK demo you
have running today, it's almost certainly a mis-configured ODR or full
scale — verify the ICM-42688-P `ACCEL_CONFIG0` register through the
debugger reads `0x68` (FS=±2 g → 0b011 << 5, ODR=100 Hz → 0x08).
