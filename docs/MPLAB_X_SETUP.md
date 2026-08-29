# MPLAB X IDE — full setup guide

This guide replaces the VS Code path. It builds the ML gesture demo in
MPLAB X (the tool you already know from the CK project) rather than in
VS Code + CMake. Same source code, same result.

---

## Phase A — Tools (once per PC, ~30 min)

### A.1  Install MPLAB X IDE
- Version **6.20 or later** (older versions do not know about dsPIC33AK1024MPS614).
- Download: <https://www.microchip.com/mplab/mplab-x-ide>
- Accept defaults. Reboot if the installer asks.

### A.2  Install the XC-DSC compiler
Your local kit ships the installer:
```
C:\Users\i69379\OneDrive - Microchip Technology Inc\1. Marketing\1. Sensing\
    16. Growth Plans\TDK engagement\Gesture Demo on AK\
    dspic33ak1024mps6xx dsc - early access\tools\xc-dsc_v4.00.00_TC7\
    xc-dsc-v4.00-tc7-full-install-windows64-installer.exe
```
- Right-click → **Run as administrator**
- Free license, defaults, "Add to PATH" ticked.
- Default install path: `C:\Program Files\Microchip\xc-dsc\v4.00-tc7\`

### A.3  Install the DFP (dsPIC33AK-MP_DEV_DFP)
Launch MPLAB X. Then:

1. **Tools → Packs**. MPLAB X opens the Pack Manager.
2. In the top-right of the Pack Manager: **Install pack from local .atpack file** icon (folder-with-arrow).
3. Browse to:
   ```
   ...\dspic33ak1024mps6xx dsc - early access\tools\dfp\
       Microchip.dsPIC33AK-MP_DEV_DFP-0.2.350.atpack
   ```
4. Open. It installs to
   `C:\Users\<you>\.mchp_packs\Microchip\dsPIC33AK-MP_DEV_DFP\0.2.350\`.

### A.4  Install the PKOB4 tool pack
Same procedure with:
```
...\tools\PKOB4_TP\Microchip.PKOB4_TP-1.23.1741.atpack
```

### A.5  Install MPLAB Code Configurator (MCC) plugin
1. **Tools → Plugins**.
2. **Available Plugins** tab → type `MCC` in the search box.
3. Tick **MPLAB® Code Configurator** → **Install** → follow prompts → restart MPLAB X.

### A.6  Verify
- **File → New Project → Microchip Embedded → Standalone Project → Next**
- Family: **All Families**
- Device: type `dsPIC33AK1024MPS614` — it should auto-complete.
- Tool: **Curiosity/Starter Kits (PKOB4)** should be listed.
- Compiler: **XC-DSC (v4.00)** should be listed.
- Click **Cancel** — this was only a verification, not a real project.

If any of the above are missing, redo the relevant step in A.1–A.5.

---

## Phase B — Prepare the source tree (5 min)

Open PowerShell:

```powershell
# 1. Working folder outside OneDrive (avoids CMake/OneDrive interactions)
New-Item -ItemType Directory -Force -Path "C:\proj" | Out-Null

# 2. Copy the port folder into the working area
$port = "C:\Users\i69379\OneDrive - Microchip Technology Inc\1. Marketing\1. Sensing\16. Growth Plans\TDK engagement\Gesture Demo on AK\dsPIC33AK-Gesture-Demo-Port"
Copy-Item -LiteralPath $port -Destination "C:\proj\ak-gesture" -Recurse

# 3. Copy BSP files (LEDs, buttons, task, console) from the AK OOB demo
$oob = "C:\Users\i69379\OneDrive - Microchip Technology Inc\1. Marketing\1. Sensing\16. Growth Plans\TDK engagement\Gesture Demo on AK\dsPIC33AK1024MPS614_GP_DIM_Out_Of_Box_Demo_Beta"
Copy-Item -LiteralPath "$oob\bsp"       -Destination "C:\proj\ak-gesture\" -Recurse
Copy-Item -LiteralPath "$oob\console.c" -Destination "C:\proj\ak-gesture\"
Copy-Item -LiteralPath "$oob\console.h" -Destination "C:\proj\ak-gesture\"

# 4. Verify layout
Get-ChildItem "C:\proj\ak-gesture" | Select-Object Name
```

You should now have:
```
C:\proj\ak-gesture\
├── app\                    ← overlay/app moved up (see step 5)
├── bsp\                    ← from OOB
├── console.c / .h          ← from OOB
├── dataset\
├── docs\
├── knowledge-pack\
├── overlay\                ← temporary, we'll flatten it next
└── README.md
```

Flatten the overlay:

```powershell
# 5. Move overlay/app to the top level, and overlay/My_MCC_Config too
Move-Item -Path "C:\proj\ak-gesture\overlay\app"             -Destination "C:\proj\ak-gesture\" -Force
Move-Item -Path "C:\proj\ak-gesture\overlay\My_MCC_Config"   -Destination "C:\proj\ak-gesture\" -Force
Remove-Item -Path "C:\proj\ak-gesture\overlay" -Recurse -Force
Get-ChildItem "C:\proj\ak-gesture" | Select-Object Name
```

Final tree — this is what MPLAB X will see:
```
C:\proj\ak-gesture\
├── app\                    ← ICM driver, ringbuffer, sensor.h, app_config.h
├── bsp\                    ← LED/button/task drivers (from OOB)
├── console.c / .h
├── dataset\                ← CSV recordings (not compiled)
├── docs\
├── knowledge-pack\
│   ├── application\        ← sml_output.c/h, sml_recognition_run.c/h
│   └── model.json          ← reference model (mplabml/ arrives in Phase E)
├── My_MCC_Config\
│   └── mcc\                ← contains main.c and mcc.mc3 (Melody config)
└── README.md
```

---

## Phase C — Create the MPLAB X project (15 min)

The trick: we point MPLAB X at the existing `main.c` and let it own only
the project descriptor files, without moving any source.

### C.1  New project wizard
1. MPLAB X → **File → New Project…**
2. Category: **Microchip Embedded** → Project: **Standalone Project** → **Next**.
3. **Family:** *All Families* — **Device:** `dsPIC33AK1024MPS614` — **Next**.
4. **Tool:** highlight **Curiosity/Starter Kits (PKOB4)**. If your board is plugged in, its serial number will show next to it — pick that specific instance. **Next**.
5. **Compiler:** **XC-DSC (v4.00.00) [C:\Program Files\Microchip\xc-dsc\v4.00-tc7\bin]** — **Next**.
6. **Project Name:** `ak-gesture`
   **Project Location:** `C:\proj\ak-gesture` — **click** the Browse button and point to that exact folder (not a subfolder).
   **Project Folder:** it will auto-append `\ak-gesture.X` — the `.X` folder is where MPLAB stores its own descriptors. Leave as auto-generated.
   Untick **Set as main project** if you don't want it globally selected.
7. **Encoding:** UTF-8 (or ISO-8859-1 to match CK — either is fine).
8. **Finish**.

MPLAB X now creates `C:\proj\ak-gesture\ak-gesture.X\` containing:
```
ak-gesture.X\
├── nbproject\
│   ├── configurations.xml
│   └── project.xml
└── Makefile
```

### C.2  Add source files
In the **Projects** pane (top-left in MPLAB X):

**Header Files** — right-click → **Add Existing Item…** → Ctrl+click to
multi-select all these (browse to `C:\proj\ak-gesture\`):

- `app\app_config.h`
- `app\sensor.h`
- `app\sensor_config.h`
- `app\ringbuffer.h`
- `app\icm42688p.h`
- `app\icm42688p_regs.h`
- `app\mikro_spi.h`
- `bsp\*.h` (LEDs, buttons, task — select all `*.h` under `bsp\`)
- `console.h`
- `knowledge-pack\application\sml_output.h`
- `knowledge-pack\application\sml_recognition_run.h`

Use *"Store path as: **Relative**"* in the "Store" prompt.

**Source Files** — right-click → **Add Existing Item…** → select:

- `My_MCC_Config\mcc\main.c`
- `app\ringbuffer.c`
- `app\icm42688p.c`
- `app\icm42688_sensor.c`
- `app\mikro_spi.c`
- `bsp\*.c` (all C files under bsp)
- `console.c`
- `knowledge-pack\application\sml_output.c`
- `knowledge-pack\application\sml_recognition_run.c`

Now the Projects pane shows two logical folders (Header Files, Source
Files) with all sources; the physical folder layout on disk stays
untouched.

### C.3  Configure include paths
Right-click the project name → **Properties** → in the left pane click
**XC-DSC (Global Options) → xc-dsc-gcc**.

- **Option categories:** *Preprocessing and messages* → **Include directories**.
- Click the "…" browse button → add these paths one by one (with
  "**Relative**" toggled, so they read `../app`, `../bsp`, etc.):

```
../app
../bsp
../
../knowledge-pack/application
../knowledge-pack/mplabml/inc     ← will exist after Phase E
../My_MCC_Config/mcc/mcc_generated_files
```

- OK to close the include-directories dialog.
- Still in project properties: **Option categories:** *Optimizations* →
  **Optimization level = 1** (or higher; 2 usually fine).
- Apply → OK.

---

## Phase D — Set up MCC in MPLAB X (30–60 min)

MPLAB X has MCC installed as a plugin (from A.5). We'll bring the OOB
demo's MCC config *into* our new project so we don't have to re-configure
UART/TMR1/LEDs — then we add SPI1, MIKRO1_CS, INT1.

### D.1  Copy the OOB's MCC config into the project

```powershell
$oob = "C:\Users\i69379\OneDrive - Microchip Technology Inc\1. Marketing\1. Sensing\16. Growth Plans\TDK engagement\Gesture Demo on AK\dsPIC33AK1024MPS614_GP_DIM_Out_Of_Box_Demo_Beta"
# Bring the whole My_MCC_Config subfolder over (skip main.c so we keep ours)
Copy-Item -LiteralPath "$oob\My_MCC_Config\mcc\mcc_generated_files" `
          -Destination "C:\proj\ak-gesture\My_MCC_Config\mcc\" -Recurse -Force
# Also copy the .mc3/.mcc config so MCC recognises the existing config
Copy-Item -Path "$oob\My_MCC_Config\mcc\*.mc3" -Destination "C:\proj\ak-gesture\My_MCC_Config\mcc\" -Force -ErrorAction SilentlyContinue
Copy-Item -Path "$oob\My_MCC_Config\mcc\*.json" -Destination "C:\proj\ak-gesture\My_MCC_Config\mcc\" -Force -ErrorAction SilentlyContinue
```

### D.2  Open MCC
1. Back in MPLAB X, with the project selected: **Tools → Embedded →
   MPLAB® Code Configurator v5: Open/Close**.
2. It may prompt: *"Open existing MCC configuration?"* — Yes → point at
   the `.mc3` or `.json` file we just copied inside `My_MCC_Config\mcc\`.
3. MCC Melody opens as a docked tab.

### D.3  Add SPI1 Host

1. Right pane → **Device Resources** → search `spi`.
2. Under **Drivers → SPI**, double-click **SPI Host** (or `SPI_HOST` / `SPIHOST`).
3. Choose hardware instance **SPI1** if asked.
4. In the newly created `SPI1_Host` component, set:
   - **Custom Name:** `SPI1_Host`
   - **Mode:** Host / Master
   - **SPI Mode:** Mode 0 (CPOL 0, CPHA 0)
   - **Clock Frequency / Bit rate:** 4 000 000 Hz
   - **Word width:** 8 bits
   - **Bit order:** MSB first
   - **Slave-Select control:** *Software* / uncheck "Use SS pin"
   - **Enable interrupt:** unchecked

### D.4  Add MIKRO1_CS as a GPIO output

In the Pin Grid (bottom):
1. Find the row **GPIO Output** column intersecting with the physical
   pin the Curiosity Platform routes to **MikroBUS 1 CS** (see the
   Curiosity Platform User Guide → MikroBUS 1 pin mapping → dsPIC AK DIM
   Info Sheet → pin RxN). Click that cell — a lock icon appears.
2. Open **System → Pins** in Project Resources.
3. In the pin row, set:
   - **Custom Name:** `MIKRO1_CS`
   - **Direction:** Output
   - **Start High:** ☑
   - **Weak Pull:** none

### D.5  Add INT1 external interrupt

1. **Device Resources** → search `interrupt`.
2. Double-click **External Interrupt** driver.
3. Under channel selection, pick the INT channel wired to **MikroBUS 1 INT**.
4. Settings:
   - Keep custom name (something like `EXT_INT1`)
   - **Edge Detect:** Rising
   - **Interrupt Priority:** 4
   - **Enable:** ☑

### D.6  Assign SPI1 SDI/SDO/SCK pins

In the Pin Grid, find the rows:
- `SPI1 → SDI (host input)` — click the pin routed to MikroBUS 1 MISO
- `SPI1 → SDO (host output)` — click the pin routed to MikroBUS 1 MOSI
- `SPI1 → SCK` — click the pin routed to MikroBUS 1 SCK

### D.7  Verify UART1 STDIO redirect

1. **UART1** in Project Resources → look for **Redirect STDIO to UART1**
   or similar checkbox → tick it if not already.

### D.8  Save and Generate
1. Click the **Save** icon (top-left of MCC).
2. Click the **Generate** button (usually top-right of MCC pane).
3. Watch the output window — expect lines listing new files under
   `spi_host/`, `interrupt/`, `system/pins.[ch]`.
4. Close MCC.

### D.9  Verify what MCC produced
Back in MPLAB X's **Projects** pane, expand
`Source Files → MCC Generated Files` and confirm:
- `spi_host/spi1.c` (or your named path) is listed
- `system/pins.c` is listed
- `interrupt/*.c` files listed with an INT1 callback

If any are missing, right-click **Source Files → Add Existing Item…**
and grab them from `My_MCC_Config\mcc\mcc_generated_files\`.

Do the same for `.h` files under **Header Files → MCC Generated Files**.

**Verify pin macros were emitted:**
Open `My_MCC_Config\mcc\mcc_generated_files\system\pins.h` in the editor.
Ctrl+F for `MIKRO1_CS`. You must see `MIKRO1_CS_SetHigh()`,
`MIKRO1_CS_SetLow()`. If not, MCC didn't apply the custom name — redo
step D.4.

**Note the exact SPI transfer function name:**
Open `mcc_generated_files\spi_host\spi1.h` and note what function does a
byte exchange:
- If it's `SPI1_ByteExchange(uint8_t tx, uint8_t *rx)` — you're done, my
  overlay code already calls this name.
- If it's `SPI1_Host_ByteExchange`, `SPI1_Exchange8bit`, or something
  else — open `app\mikro_spi.c` in MPLAB X and change the line
  `SPI1_ByteExchange(tx, &rx);` to match.

**Note the INT1 callback register function name:**
Open the interrupt driver headers under `mcc_generated_files\interrupt\`
and note the function like `EXT_INT1_CallbackRegister(...)`. Then open
`My_MCC_Config\mcc\main.c` and just before the end of the `while (1)`
init block, add:

```c
        /* Data-ready ISR — name from mcc_generated_files/interrupt/ */
        EXT_INT1_CallbackRegister(imu_drdy_isr);
        EXT_INT1_Enable();
```

If the function names differ (e.g. `Ext_INT1_SetInterruptHandler`), use
those exact spellings.

---

## Phase E — Regenerate the knowledge pack for XC-DSC (15 min)

1. Open **MPLAB Machine Learning Development Suite** (web app in your
   browser — you should have an account from the CK project).
2. Open the existing gesture-recognition project (or upload
   `dataset\*.csv` and use `knowledge-pack\model.json` as the pipeline).
3. **Download Model**:
   - Target Platform: **dsPIC33AK1024MPS614** (or nearest AK variant if
     the drop-down doesn't yet list this specific part number)
   - Compiler: **XC-DSC**
   - Format: **Source (.c/.h)** *(preferred)* — if only **Library** is
     offered, that also works; just note it.
4. Download the resulting ZIP.
5. Extract into your project:

```powershell
$zip = "C:\Users\<you>\Downloads\<name-of-downloaded>.zip"
$mplabml = "C:\proj\ak-gesture\knowledge-pack\mplabml"
New-Item -ItemType Directory -Force -Path $mplabml | Out-Null
Expand-Archive -LiteralPath $zip -DestinationPath $mplabml -Force
Get-ChildItem $mplabml -Recurse -Directory | Select-Object FullName
```

6. Sanity-check the layout — you want:
```
knowledge-pack\mplabml\inc\kb.h
knowledge-pack\mplabml\inc\kb_defines.h
knowledge-pack\mplabml\inc\kb_output.h
knowledge-pack\mplabml\src\kb.c           (Source format)
knowledge-pack\mplabml\src\...model files.c
                     — OR —
knowledge-pack\mplabml\lib\libmplabml.a   (Library format)
```
If ZIP extracted an extra top-level folder (e.g. `firmware\`), move
`inc\` and `src\` (or `lib\`) up so they sit directly under
`\mplabml\`.

### E.1 (Source-format only) — Add the new .c files to the project
In MPLAB X's **Projects** pane:
1. Right-click **Source Files → Add Existing Items from Folders…**
2. Click **Add Folder…** → browse to `knowledge-pack\mplabml\src` →
   **Select** → tick **C source files** → **Add**.

### E.2 (Library-format only) — Link the .a
1. Project **Properties → xc-dsc-ld → Additional options →
   Libraries → Files**: browse to
   `knowledge-pack\mplabml\lib\libmplabml.a` → Add.
2. Apply → OK.

### E.3 Add the mplabml headers to include path
Already done in step C.3 (`../knowledge-pack/mplabml/inc`). Just verify.

---

## Phase F — First build (5 min)

1. In MPLAB X, click the **hammer icon** (Build) or press **F11**.
2. Watch **Output → Build**. First build takes 1–3 min.

**Expected success:**
```
Loading code from ...\ak-gesture.X\dist\default\production\ak-gesture.X.production.hex...
Loading completed
Program memory used: xxx bytes
Data memory used: xxx bytes
BUILD SUCCESSFUL (total time: 2m 15s)
```

**Common failures — quick fixes:**

| Error message                                     | Fix                                                                                                       |
|---------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| `spi1.h: No such file or directory`               | The include path `../My_MCC_Config/mcc/mcc_generated_files` isn't set (Phase C.3) or MCC put `spi1.h` under a different subfolder. Update `#include` in `app\mikro_spi.c`. |
| undefined reference to `SPI1_ByteExchange`        | MCC named the transfer function differently — check `spi1.h` and rename in `mikro_spi.c` per Phase D.9.   |
| undefined reference to `MIKRO1_CS_SetHigh`        | The pin custom name didn't stick — reopen MCC, fix the pin, regenerate.                                    |
| undefined reference to `EXT_INT1_CallbackRegister`| Check what the actual callback-register name is in `mcc_generated_files/interrupt/*.h` and use that name. |
| undefined reference to `kb_run_model`             | Source-format pack .c files not added (Phase E.1); or library .a not in linker inputs (Phase E.2).        |
| `implicit declaration of function 'Nop'`          | The port's `main.c` already has `#include <xc.h>` on line ~39 — verify your copy has it.                  |
| warnings-as-errors                                | Project Properties → xc-dsc-gcc → Warnings → uncheck *"Treat warnings as errors"*.                        |

Paste the first red line if you hit an error I haven't listed and I'll
tell you the exact fix.

---

## Phase G — Program the board (2 min)

1. Plug USB-C into Curiosity Platform's PKOB4 port.
2. In MPLAB X toolbar, click **Make and Program Device** (the icon with
   an arrow and "1" — down-arrow onto chip).
3. Wait for:
```
Programming/Verify complete
```

4. Open **Tools → Embedded → MPLAB Data Visualizer** *(or use a
   separate terminal program)*: 115 200 8-N-1 on the Curiosity COM
   port.
5. Press RESET on the board — you should see the banner:
```
=== dsPIC33AK1024MPS614 Gesture Recognition ===
Sensor: icm42688p @ 100 Hz, accel=2 g, gyro=2000 dps
ICM-42688-P initialised OK
KP UUID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

**M1+M2+M3 all pass simultaneously** because in MPLAB X the "Make and
Program" step is one click.

Continue with the remaining milestones (M4–M7) as described in
`docs/TESTING_GUIDE.md`. All debugger tips there apply — MPLAB X's
debugger is more mature than VS Code's, so use it if you hit anything
tricky.

---

## Recap of the file layout MPLAB X will have created

```
C:\proj\ak-gesture\
├── ak-gesture.X\           ← MPLAB X project descriptor (nbproject/, Makefile)
├── app\                    ← your ICM driver & app config
├── bsp\
├── console.c / .h
├── dataset\
├── docs\
├── knowledge-pack\
│   ├── application\
│   └── mplabml\            ← from MPLAB ML Development Suite download
├── My_MCC_Config\
│   └── mcc\
│       ├── main.c
│       ├── mcc.json / .mc3
│       └── mcc_generated_files\
│           ├── spi_host\
│           ├── interrupt\
│           ├── system\
│           ├── timer\
│           └── uart\
└── README.md
```

Nothing to hand-edit outside of MPLAB X's UI once the project is set up.

---

## When you want to hand it back to me

If M4/M5/M6/M7 give surprising output, copy-paste the terminal
transcript or the build log into your reply, plus tell me which
milestone you're on. I can spot most driver bugs from a 5-line UART
dump.
