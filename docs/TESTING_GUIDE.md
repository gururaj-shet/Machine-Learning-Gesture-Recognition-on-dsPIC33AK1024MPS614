# Testing Guide — dsPIC33AK1024MPS614 ML Gesture Demo

Bring the port up in **7 progressive milestones**. Each milestone has a
clear pass/fail check, so if something breaks you know exactly which
layer to look at.

```
 M0 Tools installed                → confirmed on host
 M1 OOB demo builds & runs         → toolchain proven
 M2 Overlay compiles               → app code proven
 M3 UART prints boot banner        → console/printf proven
 M4 WHO_AM_I returns 0x47          → SPI + CS proven
 M5 DRDY ISR fires @ 100 Hz        → INT1 + ODR proven
 M6 Raw accel looks sane           → axis/units proven
 M7 Gesture classification         → end-to-end proven
```

---

## M0 — Host prerequisites (once)

Install and verify versions:

| Tool                              | Version                | Verify                                                              |
|-----------------------------------|------------------------|---------------------------------------------------------------------|
| VS Code                           | current                | `code --version`                                                    |
| MPLAB extension pack for VS Code  | current                | Extensions pane → search "MPLAB"                                    |
| XC-DSC compiler                   | 3.31 or later          | `xc-dsc-cc --version` on PATH, or check MPLAB extension **Toolchain** view |
| dsPIC33AK-MP_DEV_DFP              | 0.2.350 or later       | MPLAB extension → **Packs** view (the OOB `.mplab.json` also pins this) |
| MPLAB Code Configurator (Melody)  | current                | Command palette → *MPLAB: Open MCC*                                |
| MPLAB Machine Learning Dev Suite  | current                | Standalone install                                                  |
| A serial terminal                 | any                    | Tera Term / PuTTY / VS Code Serial Monitor                          |

**Pass criteria:** MPLAB extension shows the AK DFP available; XC-DSC 3.31 is selectable.

---

## M1 — Sanity-build the untouched OOB demo (do NOT skip)

This proves your host + PKOB4 + AK GP DIM + Curiosity board all work
*before* any of my code is involved.

1. Unzip / copy `dsPIC33AK1024MPS614_GP_DIM_Out_Of_Box_Demo_Beta` to a
   short path (avoid OneDrive when building — spaces + reparse points
   sometimes upset CMake). Example working root:
   `C:\proj\ak-oob\`.
2. Open the folder in VS Code. The MPLAB extension will detect the
   `.vscode/dsPIC33AK1024MPS614_GP_DIM.mplab.json` project.
3. MPLAB extension side bar → **Build**. Expect no errors.
4. Plug the Curiosity USB-C into the host. Assemble AK GP DIM into the
   DIM socket **before** applying power.
5. Side bar → **Run** (this programs and starts execution via PKOB4).
6. Open a serial terminal at **115 200 8-N-1** on the Curiosity USB COM
   port.

**Pass criteria:** LED3 blinks 1 Hz; terminal shows the OOB banner and
menu; pressing S1/S2/S3 lights LED7/6/5; `r/g/b` on the terminal toggles
RGB LED.

> ⚠ If M1 fails, stop here and fix hardware/tools. Everything downstream
> assumes a proven baseline.

---

## M2 — Overlay the port onto a fresh copy

```powershell
# 1. Fresh copy so you can always fall back to the pristine OOB
Copy-Item "C:\proj\ak-oob" "C:\proj\ak-gesture" -Recurse

# 2. Overlay port files
$port = "C:\Users\i69379\OneDrive - Microchip Technology Inc\1. Marketing\1. Sensing\16. Growth Plans\TDK engagement\Gesture Demo on AK\dsPIC33AK-Gesture-Demo-Port"
Copy-Item "$port\overlay\*"        "C:\proj\ak-gesture\"                   -Recurse -Force
Copy-Item "$port\knowledge-pack"   "C:\proj\ak-gesture\"                   -Recurse -Force

# 3. Rename the .mplab.json so VS Code picks up the new project
Rename-Item "C:\proj\ak-gesture\.vscode\dsPIC33AK1024MPS614_GP_DIM.mplab.json" `
             "dsPIC33AK1024MPS614_Gesture.mplab.json"
```

You now have a project skeleton with:

- `bsp/`, `console.[ch]`, `.vscode/*.json` — from OOB (untouched)
- `My_MCC_Config/mcc/main.c` — overwritten (ML gesture main)
- `app/` — new folder with ICM driver + adapters
- `knowledge-pack/` — new folder, `mplabml/` still missing (M2.5)

### M2.5 — Regenerate MCC Melody

1. Command palette → *MPLAB: Open MCC*.
2. Melody opens the existing OOB config. Add:
   - **SPI Host** (name `SPI1_Host`, master, 4 MHz, CPOL=0 CPHA=0,
     software SS).
   - **GPIO output**, custom name `MIKRO1_CS`, initial state High.
   - **External Interrupt** on the MikroBUS 1 INT pin, rising edge.
   - Verify **UART1 → Redirect STDIO to UART1 = ON**.
3. **Pins Grid** — route SPI SDI/SDO/SCK to the RPx pins tied to
   MikroBUS 1 (see the *dsPIC33A Curiosity Platform User Guide (Draft)*
   for the exact pin numbers of the MB1 socket, then look those pins up
   in the *dsPIC33AK1024MPS614 GP DIM Info Sheet* for the DIM edge
   pinout). Route the CS + INT pins the same way.
4. Click **Generate**.

Full field-by-field table: `docs/MCC_MELODY_CONFIG.md`.

### M2.6 — Regenerate the knowledge pack

1. Open MPLAB Machine Learning Development Suite.
2. New project → import `dataset/*.csv` from the port folder.
3. Use `knowledge-pack/model.json` as your pipeline definition.
4. Under *Download Model*:
   - Target device: **dsPIC33AK1024MPS614**
   - Compiler: **XC-DSC**
   - Format: **Source**
5. Extract the download into `C:\proj\ak-gesture\knowledge-pack\mplabml\`.
   Verify you have `mplabml/inc/*.h` (kb.h, kb_output.h, …) and
   `mplabml/src/*.c` (model_*.c, kb.c, …).
6. Add both directories to the include path. In the `.mplab.json`:

```json
"compiler.extra-include-directories": [
    "My_MCC_Config/mcc/mcc_generated_files",
    "knowledge-pack/mplabml/inc",
    "knowledge-pack/application",
    "app"
]
```

7. Build.

**Pass criteria:** clean build, no linker errors. If the linker complains
about an undefined `MIKRO1_CS_SetLow` — MCC didn't get the custom name;
open `mcc_generated_files/system/pins.h` and grep for the actual macro,
update `mikro_spi.c` accordingly.

---

## M3 — Console-only smoke test

Before wiring the IMU, prove UART + tick.

1. In `main.c` temporarily short-circuit sensor init: wrap the
   `sensor_init(...)` and `sensor_set_config(...)` calls in
   `/* #if 0 ... #endif */`, and skip the inference loop with a
   `while(1) { LED_STATUS_Toggle(); snsr_sleep_ms(500); }`.
2. Program and reset.

**Pass criteria:**
- LED3 (status) toggles at 1 Hz.
- Terminal shows:
  ```
  === dsPIC33AK1024MPS614 Gesture Recognition ===
  Sensor: icm42688p @ 100 Hz, accel=2 g, gyro=2000 dps
  ```
- No garbled characters (if garbled → UART BRG mismatch; verify FCY and
  BRG in MCC).

Revert the temporary short-circuit before continuing.

---

## M4 — Prove SPI + CS with WHO_AM_I

Insert this **temporary** debug just after `SYSTEM_Initialize();` in
`main.c`:

```c
{
    #include "../../app/icm42688p_regs.h"
    #include "../../app/mikro_spi.h"
    uint8_t whoami = 0;
    for (int i = 0; i < 5; i++) {
        mikro_spi_read(0, ICM42688_REG_WHO_AM_I, &whoami, 1);
        printf("WHO_AM_I attempt %d: 0x%02X\r\n", i, whoami);
        snsr_sleep_ms(100);
    }
    while (1) { LED_STATUS_Toggle(); snsr_sleep_ms(500); }
}
```

Insert the 6DOF IMU 14 Click in MikroBUS 1. Program and reset.

**Pass criteria:** `WHO_AM_I attempt N: 0x47` on every attempt.

**Common failures & fixes:**

| Reading            | Likely cause                                    | Fix                                                      |
|--------------------|-------------------------------------------------|----------------------------------------------------------|
| `0x00`             | MISO not connected / wrong RPx pin              | Recheck PPS in MCC, scope MISO during transfer            |
| `0xFF`             | CS never goes low, or SDO/MOSI swapped          | Scope CS; verify MIKRO1_CS_SetLow inverted logic          |
| `0x47` intermittent | SPI clock too fast / bad ground                | Lower SPI to 1 MHz, verify GND, add scope shot            |
| Random / drifting  | CPOL / CPHA mismatch                            | Force CPOL=0 CPHA=0 in MCC                                |

Also confirm on a scope: SCLK idles LOW, first sample edge is rising.

Remove the debug block once passing.

---

## M5 — Prove DRDY ISR fires at 100 Hz

Enable the full init path (uncomment `sensor_init` + `sensor_set_config`),
and register your ISR. Somewhere in `main()` just after successful
configure, add:

```c
EXT_INT1_CallbackRegister(imu_drdy_isr);   /* name from MCC */
EXT_INT1_Enable();
```

Add a counter to `imu_drdy_isr`:

```c
static volatile uint32_t drdy_count = 0;
void imu_drdy_isr(void) { drdy_count++; /* leave the rest commented */ }
```

Print `drdy_count` from a task every 1000 ms.

**Pass criteria:** count increments by **100 ± 2** per second.

**Common failures:**

| Symptom                   | Likely cause                                                        |
|---------------------------|---------------------------------------------------------------------|
| count stays 0             | INT pin not routed to the IRQ line, or edge polarity wrong (INT1 on ICM is active-high push-pull → configure MCC for **rising** edge) |
| count = 50 or 200         | Wrong `SNSR_SAMPLE_RATE` macro / wrong ODR write to ICM             |
| count jitters wildly      | Latched INT not being cleared → confirm `icm42688_read_frame` reads `INT_STATUS` |

---

## M6 — Prove raw accel data

Uncomment the buffer-write in `imu_drdy_isr` (restore its full body).
Add a temporary console dump:

```c
static uint32_t last_dump = 0;
if (g_tick_ms - last_dump >= 500) {
    ringbuffer_size_t n;
    const snsr_dataframe_t *f =
        (const snsr_dataframe_t*)ringbuffer_get_read_buffer(&g_snsr_buffer, &n);
    if (n) printf("A: %6d %6d %6d\r\n", (*f)[0], (*f)[1], (*f)[2]);
    last_dump = g_tick_ms;
}
```

**Pass criteria (at ±2 g, 16 384 LSB/g):**

- Board flat, chip up: `Az ≈ +16384 (± 500)`, `Ax ≈ 0`, `Ay ≈ 0`.
- Board flat, chip down: `Az ≈ -16384`.
- On its edge with the click's silkscreen X axis up: `Ax ≈ +16384`.
- Values noisy at ~±30 counts standing still = normal.

If magnitudes are wrong by 2×/4×/8× → full-scale is mis-set. If sign is
inverted per axis → normal (the Click's orientation differs from the
BMI160 mounting; the ML model is trained on relative motion patterns, so
this generally does not need correction for gesture recognition, but if
recognition rate drops you may need to negate axes in
`icm42688_sensor_read`).

Remove the dump.

---

## M7 — End-to-end gesture recognition

Do this only after M6 passes.

1. Rebuild + flash with **all** debug removed.
2. Reset. Terminal should show:
   ```
   === dsPIC33AK1024MPS614 Gesture Recognition ===
   Sensor: icm42688p @ 100 Hz, accel=2 g, gyro=2000 dps
   ICM-42688-P initialised OK
   KP UUID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
   ```
3. Hold the board still on the desk → after ~2 s the terminal shows:
   ```
   Gesture: idle
   ```
   Green LED lights steady.
4. Perform each trained gesture (see reference video in the CK repo:
   *up-down*, *wave*, *wheel*). Hold each gesture ~1 s consistently.
   After 3 consecutive same-class classifications (`MAJORITY_VOTES = 3`
   of 5), the terminal prints the new gesture and the status LED
   changes blink cadence:

   | Gesture | Status LED pattern      | Console line              |
   |---------|-------------------------|---------------------------|
   | idle    | Green LED on            | `Gesture: idle`           |
   | up-down | 10 Hz blink             | `Gesture: up-down`        |
   | wave    | 1 Hz blink              | `Gesture: wave`           |
   | wheel   | ~1.7 Hz blink           | `Gesture: wheel`          |

5. Verify no `!! sample buffer overrun` messages appear during normal
   use (they indicate the main loop is being starved — usually a
   `printf` running while UART is slow; drop the baud rate check or
   raise UART to 460 800).

**Pass criteria:** correct gesture is reported within ~1 s of the motion,
consistent across at least 5 attempts per class.

---

## Troubleshooting matrix (top-level)

| Milestone stuck at | Look at                                             |
|--------------------|-----------------------------------------------------|
| M1                 | Board power, PKOB4 driver, DFP install              |
| M2 build           | MCC-generated names in `spi1.h`/`pins.h`, include paths in `.mplab.json` |
| M3                 | UART BRG (FCY = 200 MHz, target 115 200), `_write` redirect enabled in MCC |
| M4                 | SPI wiring (SDI/SDO/CLK/CS pins in Pins Grid), CPOL/CPHA, CS logic |
| M5                 | INT pin routing, MCC edge setting, `INT_STATUS` read clearing latch |
| M6                 | `ACCEL_CONFIG0` register value in the debugger (should be **0x68**) |
| M7                 | Knowledge pack recompiled for XC-DSC/dsPIC33AK, class IDs match `model.json` |

## Debugger tips (PKOB4 via MPLAB extension)

- Start a **Debug** run (not Run) to break at `main`.
- After `icm42688_configure()`, add these watch expressions:
  - `g_sensor.device.accel_fs`  → expect `ICM42688_ACCEL_RANGE_2G` (= 3)
  - `g_sensor.device.gyro_fs`   → expect `ICM42688_GYRO_RANGE_2000DPS` (= 0)
  - `g_sensor.device.odr`       → expect `ICM42688_ODR_100HZ` (= 0x08)
- Immediate window / memory view can dump `ACCEL_CONFIG0` (reg 0x50) via
  a call to `icm42688_read_reg(&g_sensor.device, 0x50, &tmp, 1);` for
  live verification.

---

## Data-capture mode (optional, for retraining)

If gesture recognition accuracy is poor, capture new training CSVs on
the AK hardware:

1. In `sml_recognition_run.c`, comment out `kb_run_model()` and instead
   printf the raw sample: `printf("%d,%d,%d\r\n", data[0], data[1], data[2]);`
2. Log the terminal to a `.csv` with your terminal program while
   performing each gesture.
3. Feed those CSVs into MPLAB ML Development Suite, retrain, and
   redeploy the knowledge pack.

This closes the loop when the different mounting/axes of the ICM-42688-P
on the 6DOF IMU 14 Click cause the pretrained model to underperform.
