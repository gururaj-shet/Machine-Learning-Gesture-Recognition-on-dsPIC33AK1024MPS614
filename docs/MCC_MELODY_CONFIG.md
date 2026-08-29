# MCC Melody Configuration — dsPIC33AK1024MPS614 Gesture Demo

Start from the AK GP DIM OOB demo's MCC configuration (`My_MCC_Config`)
and *add* the peripherals below. Keep everything else the OOB provides
(clock @ 200 MHz, TMR1 @ 1 ms, UART1 @ 115 200 8‑N‑1, LED/button pins,
etc.).

> The exact MCC user-interface path names change slightly between MCC
> Melody releases; the values below matter more than the click‑path.

---

## 1. System (already configured in OOB — verify only)

| Item        | Value                       |
|-------------|-----------------------------|
| FOSC        | 200 MHz (internal FRC + PLL) |
| FCY         | 200 MHz                     |
| WDT         | Disabled                    |

## 2. TMR1 (already configured in OOB — verify only)

- Period: **1 ms** (used as the ML app tick + BSP task scheduler).
- Callback registered from `main.c` → `TMR1_TimeoutCallbackRegister(app_tick_handler)`.
- Interrupt: enabled, priority default.

## 3. UART1 (already configured in OOB — verify only)

- Baud rate: **115 200**, 8-N-1.
- **Redirect STDIO to UART1** — enable this option so `printf()` reaches
  the console.
- Custom name in Melody: keep `UART1_Drv` (referenced by console.c).

## 4. SPI1 (NEW — add for the ICM‑42688‑P)

Add a **SPI Host** module and configure:

| Property        | Value                                          |
|-----------------|------------------------------------------------|
| Custom name     | `SPI1_Host` (matches include in `mikro_spi.c`) |
| Mode            | **Host**                                       |
| Bit rate        | 4 MHz (safe start; ICM‑42688‑P tolerates ≤ 24 MHz) |
| Word width      | 8 bits                                         |
| CPOL            | 0 (Idle Low)                                   |
| CPHA            | 0 (Sampling on leading edge)                   |
| MSB / LSB first | MSB first                                      |
| Slave-select control | **Software** (we drive `MIKRO1_CS` manually) |

**Pin PPS mapping** to MikroBUS 1 socket:

| SPI signal | Direction | MikroBUS pin | dsPIC33AK1024MPS614 pin* |
|------------|-----------|--------------|--------------------------|
| SDI (host) | in        | MISO / SDO   | *from DIM info sheet*    |
| SDO (host) | out       | MOSI / SDI   | *from DIM info sheet*    |
| SCK        | out       | SCK          | *from DIM info sheet*    |

*Consult `dsPIC33A Curiosity Platform Development Board User Guide
(Draft).pdf` and the AK GP DIM info sheet to pick the exact RPx pins.*

MCC must generate at least:

- `SPI1_Initialize()`
- `SPI1_ByteExchange(uint8_t tx, uint8_t *rx)`

If your Melody version exposes a different transfer API (e.g.
`SPI1_Write()` / `SPI1_Read()` on separate calls, or a struct-based
`SPI1_Host.Exchange`), update the two calls inside `mikro_spi.c` —
the driver otherwise remains portable.

## 5. GPIO — MIKRO1_CS (NEW)

Configure the MikroBUS 1 CS pin:

| Property           | Value           |
|--------------------|-----------------|
| Direction          | Output          |
| Custom name        | `MIKRO1_CS`     |
| Initial state      | High (deasserted) |

Melody will emit `MIKRO1_CS_SetHigh()` and `MIKRO1_CS_SetLow()` macros
in `mcc_generated_files/system/pins.h`.

## 6. External interrupt — INT1 (NEW)

The MikroBUS 1 INT pin routes to the ICM‑42688‑P's INT1 output. Configure
an external / change-notification interrupt input:

| Property        | Value                     |
|-----------------|---------------------------|
| Custom name     | keep default (e.g. `EXT_INT1`) |
| Edge            | Rising (INT1 is active-high, push-pull) |
| Priority        | Default                   |

Register the callback in `main.c` — for example (adjust to your
Melody-generated symbol):

```c
EXT_INT1_CallbackRegister(imu_drdy_isr);
EXT_INT1_Enable();
```

If your Melody version uses Change Notification instead of a dedicated
INT peripheral, use its callback registration API in the same fashion.

## 7. LEDs / Buttons / RGB / POT / CAN

Leave them unchanged — the ML demo re-uses `led3`, `ledRed`, `ledGreen`,
`ledBlue` from the OOB `bsp/`. CAN and the potentiometer are not used by
this demo; leaving them enabled is harmless.

---

## After regenerating

Confirm that:

1. `My_MCC_Config/mcc/mcc_generated_files/spi_host/spi1.h` exists (or
   your equivalent — update the include in `overlay/app/mikro_spi.c` if
   MCC puts the header in a different sub-folder).
2. `MIKRO1_CS_SetLow()` / `MIKRO1_CS_SetHigh()` are visible in `pins.h`.
3. `SPI1_ByteExchange()` (or your chosen API) is declared in `spi1.h`.
4. An INT-callback registration function is available.

Then invoke MPLAB VS Code's **Clean → Build** and flash the resulting ELF.
