# dsPIC33AK1024MPS614 — ML Gesture Recognition Demo

Port of the [dsPIC33CK ML Gesture Recognition demo](https://github.com/MicrochipTech/ml-dsPIC33CK-Curiosity-Gestures-Recognition)
to the **dsPIC33AK1024MPS614 GP DIM** on the **Curiosity Platform
Development Board (EV74H48A)**, using the **MikroE 6DOF IMU 14 Click**
(TDK InvenSense **ICM‑42688‑P**) in place of the original IMU 2 Click
(Bosch BMI160).

The trained ML model (5-gesture: *idle / up‑down / wave / wheel /
unknown*) is preserved unchanged — accelerometer is configured at
**100 Hz, ±2 g**, so the feature extractors see the same input scale as
the original CK training data.

---

## Hardware

| Item                                            | Part / Order code                                                  |
|-------------------------------------------------|--------------------------------------------------------------------|
| Curiosity Platform Development Board            | [EV74H48A](https://www.microchip.com/en-us/development-tool/ev74h48a) |
| dsPIC33AK1024MPS614 GP DIM (early-access)       | see local `dspic33ak1024mps6xx dsc - early access\documents\Hardware Board Documents` |
| 6DOF IMU 14 Click (ICM‑42688‑P)                 | [MIKROE‑6053](https://www.mikroe.com/6dof-imu-14-click)           |
| PKOB4 / ICD4 / PICkit 4 / MPLAB Snap            | On-board PKOB4 works out of the box                                |

**Assembly**

1. Insert the dsPIC33AK1024MPS614 GP DIM into the Curiosity Platform's DIM socket.
2. Insert the **6DOF IMU 14 Click into MikroBUS 1**.
3. On the Click board, keep the default jumper settings (SPI interface — no
   changes needed for I²C on this port).
4. Connect the on-board USB‑C to the host PC. This provides both the
   PKOB4 debug/programming channel and the virtual COM port.

---

## Software prerequisites

You may use either MPLAB X IDE (**recommended** if you already know the
CK MPLAB X project) or MPLAB Tools for VS Code. Either way the tools
below are needed:

| Tool                                                                      | Version                |
|---------------------------------------------------------------------------|------------------------|
| MPLAB X IDE — see [`docs/MPLAB_X_SETUP.md`](docs/MPLAB_X_SETUP.md)         | **6.20 or later**      |
| *(or)* MPLAB Tools for VS Code (MPLAB extension)                          | current                |
| XC‑DSC compiler                                                           | **v3.31** or later     |
| dsPIC33AK-MP_DEV_DFP pack                                                 | **0.2.350** or later   |
| MPLAB Code Configurator (MCC Melody)                                      | current                |
| MPLAB Machine Learning Development Suite                                  | current                |

MPLAB X + XC16 workflow is *not* used here (the AK is a 32‑bit dsPIC33A
ISA — you must use **XC‑DSC**, not XC16, regardless of IDE choice).

---

## Directory layout

```
dsPIC33AK-Gesture-Demo-Port/
├── README.md                         ← this file
├── docs/
│   ├── MCC_MELODY_CONFIG.md          ← step‑by‑step MCC Melody setup
│   └── PORTING_NOTES.md              ← detailed change log CK → AK
├── overlay/                          ← files to overlay onto the OOB base project
│   ├── My_MCC_Config/mcc/main.c      ← rewritten ML gesture main
│   └── app/                          ← application layer
│       ├── app_config.h
│       ├── sensor.h  sensor_config.h
│       ├── icm42688p.[ch]            ← self‑contained ICM‑42688‑P register driver
│       ├── icm42688p_regs.h
│       ├── icm42688_sensor.c         ← adapter to sensor_device_t
│       ├── mikro_spi.[ch]            ← SPI1 + Mikrobus CS glue
│       └── ringbuffer.[ch]           ← ported for XC‑DSC
├── knowledge-pack/                   ← ML application layer
│   ├── model.json                    ← preserved model definition
│   └── application/
│       ├── sml_output.[ch]
│       └── sml_recognition_run.[ch]
└── dataset/                          ← 12 CSV recordings (unchanged from CK demo)
```

The **`overlay/`** directory is designed to be **dropped on top of a copy
of the OOB demo folder** (`dsPIC33AK1024MPS614_GP_DIM_Out_Of_Box_Demo_Beta`).
That gives you a working `bsp/`, `console.[ch]`, `.vscode/*.json`, LED and
button drivers, and — once you regenerate MCC Melody per
[`docs/MCC_MELODY_CONFIG.md`](docs/MCC_MELODY_CONFIG.md) — a working
`My_MCC_Config/mcc/mcc_generated_files/` tree.

---

## Quick-start build steps

1. **Clone the OOB demo as the base**
   ```powershell
   Copy-Item -Path ".\dsPIC33AK1024MPS614_GP_DIM_Out_Of_Box_Demo_Beta" `
             -Destination ".\dsPIC33AK-Gesture-Demo" -Recurse
   ```

2. **Overlay the port**
   ```powershell
   Copy-Item -Path ".\dsPIC33AK-Gesture-Demo-Port\overlay\*" `
             -Destination ".\dsPIC33AK-Gesture-Demo\" -Recurse -Force
   Copy-Item -Path ".\dsPIC33AK-Gesture-Demo-Port\knowledge-pack" `
             -Destination ".\dsPIC33AK-Gesture-Demo\" -Recurse -Force
   ```

3. **Regenerate MCC Melody** using the config in
   [`docs/MCC_MELODY_CONFIG.md`](docs/MCC_MELODY_CONFIG.md) — add **SPI1**,
   the **MIKRO1_CS** GPIO, and the **INT1** external interrupt to the
   existing OOB configuration.

4. **Regenerate the MPLAB ML knowledge pack** targeting
   `dsPIC33AK1024MPS614`. Choose **Source Format** so it drops
   `libmplabml/inc/*.h` + `libmplabml/src/*.c` into `knowledge-pack/mplabml/`.
   (The precompiled `libmplabml.a` shipped with the CK project is XC16 —
   it will **not** link with XC‑DSC.) See
   [`docs/PORTING_NOTES.md`](docs/PORTING_NOTES.md) §"Knowledge pack".

5. **Open in VS Code with the MPLAB extension**, then build. The
   `.vscode/dsPIC33AK1024MPS614_GP_DIM.mplab.json` file already ships with
   a wildcard `**/*` fileset — the overlay files are picked up automatically.

6. **Flash & run**. Open a serial terminal at **115 200 8‑N‑1** on the
   Curiosity USB‑C COM port and perform gestures. Recognised gestures
   print on the console and drive the RGB / status LEDs:

   | Gesture   | Indicator                       |
   |-----------|---------------------------------|
   | idle      | Green LED steady                |
   | up-down   | Status LED fast blink (10 Hz)   |
   | wave      | Status LED slow blink (1 Hz)    |
   | wheel     | Status LED medium blink (~1.7 Hz) |
   | unknown   | Status LED default (2 Hz)       |

---

## Reference documents (in your local kit)

- `dspic33ak1024mps6xx dsc - early access\documents\Hardware Board Documents\dsPIC33AK1024MPS614 General Purpose Dual In-Line Module (DIM) Information Sheet.pdf`
- `dspic33ak1024mps6xx dsc - early access\documents\Hardware Board Documents\dsPIC33A Curiosity Platform Development Board User Guide (Draft).pdf`
- 6DOF IMU 14 Click product page: <https://www.mikroe.com/6dof-imu-14-click>
- ICM‑42688‑P datasheet: TDK DS-000347

---

## License

Follows the parent projects: Microchip standard "software with Microchip
products" license (see `LICENSE.txt` in the original CK demo).
