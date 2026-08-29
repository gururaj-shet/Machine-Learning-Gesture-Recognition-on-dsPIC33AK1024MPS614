# Knowledge Pack — dsPIC33AK1024MPS614 (hand-crafted)

Because MPLAB Machine Learning Development Suite does not yet support
`dsPIC33AK1024MPS614` as a download target, this project ships a
**hand-crafted knowledge pack** that emulates the same 8-feature pipeline as
the CK reference (`model.json` originally captured from the CK demo) but
uses a simpler nearest-centroid classifier that's trivial to reproduce in
plain C.

## Layout

```
knowledge-pack/
├── application/                 ← firmware glue (unchanged from CK demo)
│   ├── sml_output.c
│   ├── sml_output.h
│   ├── sml_recognition_run.c
│   └── sml_recognition_run.h
├── model.json                   ← metadata describing the deployed model
├── README.md                    ← this file
└── mplabml/
    ├── inc/
    │   ├── kb.h                 ← MPLAB ML-compatible public API
    │   ├── kb_output.h
    │   ├── kb_defines.h
    │   └── kp_model_data.h      ← AUTO-GENERATED constants (do not edit)
    └── src/
        └── kb.c                 ← runtime: windowing + features + classifier
```

## Pipeline

Identical feature layout to the CK reference (`model.json` `FeatureNames`):

| # | Feature                             | Column(s) |
|---|-------------------------------------|-----------|
| 1 | 75th Percentile                     | x         |
| 2 | 75th Percentile                     | y         |
| 3 | Population Variance                 | y         |
| 4 | Two-Column P2P Difference           | x,y       |
| 5 | Two-Column P2P Difference           | x,z       |
| 6 | Two-Column P2P Difference           | y,z       |
| 7 | Max Column (argmax P2P)             | x,y,z     |
| 8 | P2P of Low-Pass Filtered signal     | y (LPF len=10) |

* **Segmenter:** window_size = 100, delta = 100 (non-overlapping).
* **Classifier:** nearest-centroid with MAD-normalised L1 distance.
* **Rejection:** per-class threshold `mean + 3·std` of intra-class distances.
  A window whose closest centroid exceeds the class threshold is reported as
  class `0` (Unknown).

Training accuracy on the CSVs in `../dataset/`: **98.7%** (696/705 windows).

## Retraining

Whenever the training CSVs in `../dataset/` change, or you want to add a new
gesture class, re-run:

```powershell
python C:\Proj\ak-gesture\tools\train_kp.py
```

That regenerates `mplabml/inc/kp_model_data.h` in place. Rebuild the MPLAB X
project and reflash.

To add a new gesture class:

1. Capture ~3 CSV recordings of the new gesture (columns: `x,y,z`, 100 Hz,
   int16 raw) into `../dataset/`, filenames prefixed with a distinct token
   (e.g. `Circle_1.csv`).
2. Add the token to `LABEL_MAP` in `tools/train_kp.py` with a fresh class ID
   (must be > 0 and unique).
3. Re-run the trainer.

## Migrating to a real MPLAB ML pack

When Model Builder eventually supports `dsPIC33AK1024MPS614 + XC-DSC` as a
download target:

1. Import `../dataset/*.csv` into Model Builder.
2. Recreate the pipeline (see the *Pipeline* section above) — or import
   `model.json` if the version supports it.
3. Download the pack as **Source / XC-DSC / dsPIC33AK1024MPS614**.
4. Replace this entire `mplabml/` folder with the download's `inc/` +
   `src/` tree.
5. Delete `tools/train_kp.py` (or keep it as an alternate trainer).
6. `application/*.c` needs no changes — the MPLAB ML-generated pack exposes
   the same `kb_*` API.

## API contract (kb.h)

* `void kb_model_init(void)` — call once at startup.
* `int32_t kb_run_model(int16_t *data, int32_t num_sensors, int32_t model_index)`
  — feed one sensor frame (only the first 3 int16 values are used, expected
  to be accel x/y/z). Returns:
    * `>= 0` — classification id (`0`=Unknown, `2`=IDLE, `3`=UP-DOWN,
      `4`=WAVE, `5`=WHEEL). Class `1` (`EIGHT`) is reserved but not trained.
    * `<  0` — window not full yet, no classification available.
* `void kb_reset_model(int32_t model_index)` — no-op in this pack (window
  self-clears after each classification).
* `const uint8_t *kb_get_model_uuid_ptr(int32_t model_index)` — 16-byte UUID
  derived from centroid bytes. Changes automatically whenever the model is
  retrained.
* `int kb_sprint_model_result(...)` — JSON emitter.
