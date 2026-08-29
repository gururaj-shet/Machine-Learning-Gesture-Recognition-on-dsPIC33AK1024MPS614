#!/usr/bin/env python3
"""
Hand-crafted knowledge-pack trainer for the AK gesture demo.

Replicates the CK reference pipeline from knowledge-pack/model.json:
  - Windowing: window_size=100, delta=100 (non-overlapping)
  - Transform:  Magnitude (per-sample sqrt(x^2+y^2+z^2))
  - Features (8, in this order):
        1. x75Percentile          75th Percentile of x
        2. y75Percentile          75th Percentile of y
        3. yVariance              Variance of y
        4. xxyy_cross_p2p_diff    P2P(x) - P2P(y)
        5. xxzz_cross_p2p_diff    P2P(x) - P2P(z)
        6. yyzz_cross_p2p_diff    P2P(y) - P2P(z)
        7. xxyyzz_cross_max_col   argmax P2P over {x,y,z}   -> {0,1,2}
        8. yMaxP2PGlobalDC        P2P of low-pass(y)         (moving-average LPF, len=10)

Classifier: nearest-centroid with Z-score-normalized L1 distance, per-class
rejection threshold. Emits a C header with all constants baked in as int32.
"""
import csv
import glob
import math
import os
import sys
from pathlib import Path

import numpy as np

# ---------------------------------------------------------------------------
# Paths / labels
# ---------------------------------------------------------------------------
HERE     = Path(__file__).resolve().parent
DATASET  = HERE.parent / "dataset"
OUT_HDR  = HERE.parent / "knowledge-pack" / "mplabml" / "inc" / "kp_model_data.h"

# Filename-prefix -> (class_id, class_name)
#
# Class IDs match main.c's expectations (see gesture_name() and the LED
# switch/case at ~line 273): 1=idle, 2=up-down, 3=wave, 4=wheel.
# The CK reference model.json used a different numbering (2..5); we use main.c's
# convention because that's what the firmware runtime interprets.
LABEL_MAP = {
    "Standby":  (1, "IDLE"),
    "Vertical": (2, "UP-DOWN"),
    "Wave":     (3, "WAVE"),
    "Wheel":    (4, "WHEEL"),
}
UNKNOWN_ID = 0

WINDOW = 100
LPF_LEN = 10           # moving-average length for feature #8

# ---------------------------------------------------------------------------
# Feature functions — MUST match the C implementation bit-for-bit on integer
# inputs.  All inputs are int16 accel samples.
# ---------------------------------------------------------------------------
def percentile_75(col):
    """SensiML-style 75th percentile: sort ascending, take index int(0.75*(N-1))."""
    s = np.sort(col)
    idx = int(0.75 * (len(s) - 1))
    return int(s[idx])

def variance(col):
    """Population variance, integer-truncated (matches C int32 division)."""
    n = len(col)
    m = int(np.sum(col) // n)
    acc = 0
    for v in col:
        d = int(v) - m
        acc += d * d
    return int(acc // n)

def p2p(col):
    return int(np.max(col)) - int(np.min(col))

def p2p_diff(a, b):
    return p2p(a) - p2p(b)

def max_col_p2p(x, y, z):
    """argmax P2P over the three axes."""
    r = [p2p(x), p2p(y), p2p(z)]
    return int(np.argmax(r))         # 0, 1, or 2

def lpf_p2p_y(y):
    """Moving-average LPF (length LPF_LEN), then peak-to-peak of result."""
    n = len(y)
    if n < LPF_LEN:
        return p2p(y)
    # Integer boxcar filter (matches C: running sum / LPF_LEN).
    filt = np.empty(n - LPF_LEN + 1, dtype=np.int32)
    s = int(np.sum(y[:LPF_LEN]))
    filt[0] = s // LPF_LEN
    for i in range(1, len(filt)):
        s = s + int(y[i + LPF_LEN - 1]) - int(y[i - 1])
        filt[i] = s // LPF_LEN
    return int(np.max(filt)) - int(np.min(filt))

def compute_features(win):
    """win: (100, 3) int16 array, columns are x,y,z. Returns list of 8 ints."""
    x, y, z = win[:, 0], win[:, 1], win[:, 2]
    return [
        percentile_75(x),
        percentile_75(y),
        variance(y),
        p2p_diff(x, y),
        p2p_diff(x, z),
        p2p_diff(y, z),
        max_col_p2p(x, y, z),
        lpf_p2p_y(y),
    ]

FEATURE_NAMES = [
    "x75Percentile", "y75Percentile", "yVariance",
    "xxyy_cross_p2p_diff", "xxzz_cross_p2p_diff", "yyzz_cross_p2p_diff",
    "xxyyzz_cross_max_col", "yMaxP2PGlobalDC",
]

# ---------------------------------------------------------------------------
# Load + window CSVs
# ---------------------------------------------------------------------------
def load_csv(path):
    with open(path, "r", newline="") as f:
        rdr = csv.reader(f)
        header = next(rdr)
        rows = [tuple(int(v) for v in r) for r in rdr if r]
    return np.array(rows, dtype=np.int32)   # keep 32-bit to avoid overflow in sums

def windows(arr, size=WINDOW, delta=WINDOW):
    for start in range(0, len(arr) - size + 1, delta):
        yield arr[start:start+size]

def main():
    if not DATASET.is_dir():
        sys.exit(f"dataset dir not found: {DATASET}")

    X, y = [], []
    n_by_class = {cid: 0 for cid, _ in LABEL_MAP.values()}
    for csv_path in sorted(DATASET.glob("*.csv")):
        prefix = csv_path.stem.split("_")[0]
        if prefix not in LABEL_MAP:
            print(f"skip (no label): {csv_path.name}")
            continue
        cid, cname = LABEL_MAP[prefix]
        data = load_csv(csv_path)
        w_count = 0
        for w in windows(data):
            X.append(compute_features(w))
            y.append(cid)
            w_count += 1
        n_by_class[cid] += w_count
        print(f"  {csv_path.name:20s} -> {cname:8s} ({w_count} windows)")

    X = np.array(X, dtype=np.int64)      # (N, 8)
    y = np.array(y, dtype=np.int32)      # (N,)
    print(f"\nTotal windows: {len(X)}")
    for cid, cname in sorted((v for v in LABEL_MAP.values())):
        print(f"  class {cid} ({cname:8s}): {n_by_class[cid]} windows")

    # -----------------------------------------------------------------------
    # Per-class centroid + shared per-feature scale (median absolute deviation
    # from global median gives robust scale for L1 distance).
    # -----------------------------------------------------------------------
    class_ids = sorted(set(y.tolist()))
    centroids = {}
    for cid in class_ids:
        centroids[cid] = np.round(np.mean(X[y == cid], axis=0)).astype(np.int64)

    # Per-feature scale: MAD around global median.  Guard against zero.
    med = np.median(X, axis=0)
    mad = np.median(np.abs(X - med), axis=0)
    mad = np.maximum(mad, 1).astype(np.int64)          # avoid div-by-zero

    # -----------------------------------------------------------------------
    # Per-class rejection threshold: mean L1(z-score) + 3*std within class.
    # -----------------------------------------------------------------------
    def dist(f, cid):
        return int(np.sum(np.abs((f - centroids[cid]) * 1000 // mad)))

    thresholds = {}
    for cid in class_ids:
        ds = np.array([dist(X[i], cid) for i in np.where(y == cid)[0]])
        thresholds[cid] = int(ds.mean() + 3 * ds.std())

    # -----------------------------------------------------------------------
    # Training-set accuracy sanity check
    # -----------------------------------------------------------------------
    correct = 0
    conf = {cid: {cid2: 0 for cid2 in class_ids + [UNKNOWN_ID]} for cid in class_ids}
    for i in range(len(X)):
        best_cid, best_d = UNKNOWN_ID, 1 << 62
        for cid in class_ids:
            d = dist(X[i], cid)
            if d < best_d:
                best_cid, best_d = cid, d
        # Apply rejection
        if best_d > thresholds[best_cid]:
            pred = UNKNOWN_ID
        else:
            pred = best_cid
        if pred == y[i]:
            correct += 1
        conf[int(y[i])][pred] += 1

    print(f"\nTraining accuracy: {correct}/{len(X)} = {100.0*correct/len(X):.1f}%")
    print("Confusion matrix (rows=true, cols=pred incl. Unknown=0):")
    hdr_ids = [UNKNOWN_ID] + class_ids
    print("        " + "".join(f"{cid:>7d}" for cid in hdr_ids))
    for cid in class_ids:
        row = conf[cid]
        print(f"  {cid:>4d}  " + "".join(f"{row[cid2]:>7d}" for cid2 in hdr_ids))

    # -----------------------------------------------------------------------
    # Emit C header
    # -----------------------------------------------------------------------
    N_FEAT = 8
    N_CLS  = len(class_ids)

    def c_i32_array(name, arr, per_line=8):
        s = f"static const int32_t {name}[] = {{\n    "
        parts = []
        for i, v in enumerate(arr):
            parts.append(f"{int(v):>12d}")
        for i in range(0, len(parts), per_line):
            s += ", ".join(parts[i:i+per_line])
            if i + per_line < len(parts):
                s += ",\n    "
        s += "\n};\n"
        return s

    with open(OUT_HDR, "w", newline="\n") as f:
        f.write("/*******************************************************************************\n")
        f.write("  Auto-generated by tools/train_kp.py — DO NOT EDIT BY HAND.\n")
        f.write("\n")
        f.write("  Baked-in class centroids, per-feature MAD scale, and per-class rejection\n")
        f.write("  thresholds for the AK gesture knowledge pack.  Regenerate by running:\n")
        f.write("      python tools/train_kp.py\n")
        f.write("*******************************************************************************/\n")
        f.write("#ifndef KP_MODEL_DATA_H\n")
        f.write("#define KP_MODEL_DATA_H\n\n")
        f.write("#include <stdint.h>\n\n")
        f.write(f"#define KP_NUM_FEATURES   {N_FEAT}\n")
        f.write(f"#define KP_NUM_CLASSES    {N_CLS}\n")
        f.write(f"#define KP_WINDOW_SIZE    {WINDOW}\n")
        f.write(f"#define KP_LPF_LEN        {LPF_LEN}\n")
        f.write(f"#define KP_CLASS_UNKNOWN  {UNKNOWN_ID}\n\n")

        # Class IDs (as reported by kb_run_model)
        f.write("static const int32_t kp_class_ids[KP_NUM_CLASSES] = { ")
        f.write(", ".join(str(cid) for cid in class_ids))
        f.write(" };\n\n")

        # Class name strings (for kb_sprint_model_result debug output)
        f.write("static const char * const kp_class_names[KP_NUM_CLASSES] = {\n")
        for cid in class_ids:
            cname = next(name for _p, (c, name) in LABEL_MAP.items() if c == cid)
            f.write(f'    "{cname}",\n')
        f.write("};\n\n")

        # Centroids (KP_NUM_CLASSES rows of KP_NUM_FEATURES)
        f.write("static const int32_t kp_centroids[KP_NUM_CLASSES][KP_NUM_FEATURES] = {\n")
        for cid in class_ids:
            row = centroids[cid]
            f.write("    { " + ", ".join(f"{int(v):>10d}" for v in row) + " },\n")
        f.write("};\n\n")

        # Per-feature scale (MAD).  Used as denominator in Z-normalized distance.
        f.write("static const int32_t kp_scale[KP_NUM_FEATURES] = {\n    ")
        f.write(", ".join(f"{int(v):>10d}" for v in mad))
        f.write("\n};\n\n")

        # Per-class rejection threshold
        f.write("static const int32_t kp_reject_threshold[KP_NUM_CLASSES] = {\n    ")
        f.write(", ".join(f"{int(thresholds[cid]):>10d}" for cid in class_ids))
        f.write("\n};\n\n")

        # UUID: derive deterministically from centroid bytes so it changes when
        # the model changes.  16 bytes.
        import hashlib
        blob = b"".join(int(v).to_bytes(8, "little", signed=True)
                        for cid in class_ids for v in centroids[cid])
        blob += b"".join(int(v).to_bytes(8, "little", signed=True) for v in mad)
        uuid = hashlib.md5(blob).digest()
        f.write("static const uint8_t kp_model_uuid[16] = {\n    ")
        f.write(", ".join(f"0x{b:02x}" for b in uuid))
        f.write("\n};\n\n")

        f.write("#endif /* KP_MODEL_DATA_H */\n")

    print(f"\nWrote {OUT_HDR}")

if __name__ == "__main__":
    main()
