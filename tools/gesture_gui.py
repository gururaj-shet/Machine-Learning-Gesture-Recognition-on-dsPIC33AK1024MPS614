#!/usr/bin/env python3
"""
Live gesture-recognition GUI for the dsPIC33AK1024MPS614 gesture demo.

Opens a serial port, parses the JSON lines emitted by kb_sprint_model_result
(one per 100-sample window, ~1 Hz), and shows a live visualisation:

  ┌────────────────────────────────────────────────────────────┐
  │  [status] Connected @ COM7                        [refresh]│
  ├────────────────────────────────────────────────────────────┤
  │                                                            │
  │                        🌊                                  │
  │                      W A V E                               │
  │                                                            │
  │   Confidence:  ████████████░░░░░░░░  62%                   │
  │                                                            │
  ├────────────────────────────────────────────────────────────┤
  │  History:  IDLE  IDLE  WAVE  WAVE  WAVE  WHEEL  ...        │
  ├────────────────────────────────────────────────────────────┤
  │  Statistics:  IDLE=42  UP-DOWN=8  WAVE=15  WHEEL=11  ?=3   │
  └────────────────────────────────────────────────────────────┘

Requirements: python 3.8+, pyserial.
Run:
    python tools/gesture_gui.py
"""
import json
import queue
import re
import sys
import threading
import time
import tkinter as tk
from collections import deque, Counter
from tkinter import ttk

import serial
import serial.tools.list_ports

# ---------------------------------------------------------------------------
#  Gesture presentation table
# ---------------------------------------------------------------------------
GESTURES = {
    0: {"name": "UNKNOWN", "icon": "?",   "color": "#6b7280"},
    1: {"name": "IDLE",    "icon": "◉",   "color": "#22c55e"},   # green
    2: {"name": "UP-DOWN", "icon": "↕",   "color": "#3b82f6"},   # blue
    3: {"name": "WAVE",    "icon": "〜",   "color": "#a855f7"},   # purple
    4: {"name": "WHEEL",   "icon": "⟳",   "color": "#f97316"},   # orange
}

HISTORY_LEN = 20
DEFAULT_BAUD = 115200
SERIAL_TIMEOUT = 0.1

# Regex fallback: main.c also emits `Gesture: wave` and `cls=1` lines. We
# primarily consume the JSON lines but keep the plain forms as backup.
RE_GESTURE_LINE = re.compile(r"Gesture:\s*(\w[\w-]*)", re.IGNORECASE)
RE_CLS_LINE     = re.compile(r"cls\s*=\s*(-?\d+)")


# ---------------------------------------------------------------------------
#  Serial reader thread
# ---------------------------------------------------------------------------
class SerialReader(threading.Thread):
    """Reads lines from the serial port and pushes parsed events onto a queue."""

    def __init__(self, port, baud, out_queue, stop_evt):
        super().__init__(daemon=True)
        self.port = port
        self.baud = baud
        self.q = out_queue
        self.stop_evt = stop_evt

    def run(self):
        try:
            ser = serial.Serial(self.port, self.baud, timeout=SERIAL_TIMEOUT)
        except serial.SerialException as e:
            self.q.put(("error", f"Cannot open {self.port}: {e}"))
            return

        self.q.put(("status", f"Connected @ {self.port} · {self.baud} baud"))
        buf = b""
        try:
            while not self.stop_evt.is_set():
                chunk = ser.read(256)
                if chunk:
                    buf += chunk
                    while b"\n" in buf:
                        line, buf = buf.split(b"\n", 1)
                        text = line.decode("utf-8", errors="replace").strip()
                        if text:
                            self._parse(text)
        finally:
            ser.close()
            self.q.put(("status", "Disconnected"))

    def _parse(self, text):
        # Prefer JSON classification lines
        if text.startswith("{") and text.endswith("}"):
            try:
                obj = json.loads(text)
                cls = int(obj.get("Classification", -1))
                label = obj.get("Label", GESTURES.get(cls, GESTURES[0])["name"])
                dist  = int(obj.get("Distance",  -1))
                thr   = int(obj.get("Threshold", -1))
                self.q.put(("cls", {"id": cls, "label": label,
                                    "distance": dist, "threshold": thr,
                                    "raw": text}))
                return
            except (ValueError, KeyError):
                pass
        # Plain-text fallbacks from main.c and sml_recognition_run.c
        m = RE_GESTURE_LINE.search(text)
        if m:
            self.q.put(("gesture", m.group(1).upper()))
            return
        m = RE_CLS_LINE.search(text)
        if m:
            cls = int(m.group(1))
            if cls >= 0:
                info = GESTURES.get(cls, GESTURES[0])
                self.q.put(("cls", {"id": cls, "label": info["name"],
                                    "distance": -1, "threshold": -1,
                                    "raw": text}))
            return
        # Everything else — banner, diag, errors — send as log
        self.q.put(("log", text))


# ---------------------------------------------------------------------------
#  GUI
# ---------------------------------------------------------------------------
class GestureGUI(tk.Tk):
    BG        = "#0f172a"     # slate-900
    PANEL     = "#1e293b"     # slate-800
    FG        = "#f1f5f9"     # slate-100
    MUTED     = "#94a3b8"     # slate-400
    ACCENT    = "#38bdf8"     # sky-400
    OK        = "#22c55e"
    WARN      = "#f59e0b"
    ERR       = "#ef4444"

    def __init__(self):
        super().__init__()
        self.title("dsPIC33AK Gesture Recognition — Live")
        self.geometry("880x620")
        self.configure(bg=self.BG)
        self.minsize(720, 540)

        self.q = queue.Queue()
        self.reader = None
        self.stop_evt = threading.Event()

        self.history = deque(maxlen=HISTORY_LEN)
        self.stats = Counter()
        self.current_cls = 0
        self.current_dist = 0
        self.current_thr  = 1
        self.last_update  = 0.0

        self._build_style()
        self._build_ui()
        self._pump_events()
        self._decay_animation()

    # ------------------------------------------------------------------
    def _build_style(self):
        style = ttk.Style(self)
        try:
            style.theme_use("clam")
        except tk.TclError:
            pass
        style.configure("TFrame",    background=self.BG)
        style.configure("Panel.TFrame", background=self.PANEL)
        style.configure("TLabel",    background=self.BG, foreground=self.FG,
                        font=("Segoe UI", 10))
        style.configure("Panel.TLabel", background=self.PANEL, foreground=self.FG,
                        font=("Segoe UI", 10))
        style.configure("Muted.TLabel", background=self.PANEL, foreground=self.MUTED,
                        font=("Segoe UI", 9))
        style.configure("TButton", background=self.PANEL, foreground=self.FG,
                        borderwidth=0, padding=(12, 6),
                        font=("Segoe UI", 10, "bold"))
        style.map("TButton",
                  background=[("active", self.ACCENT)],
                  foreground=[("active", self.BG)])
        style.configure("TCombobox",
                        fieldbackground=self.PANEL, background=self.PANEL,
                        foreground=self.FG, arrowcolor=self.FG,
                        selectbackground=self.PANEL, selectforeground=self.FG)
        self.option_add("*TCombobox*Listbox*Background", self.PANEL)
        self.option_add("*TCombobox*Listbox*Foreground", self.FG)
        self.option_add("*TCombobox*Listbox*selectBackground", self.ACCENT)

    # ------------------------------------------------------------------
    def _build_ui(self):
        # --- top bar: port selector + connect button + status -----------
        top = ttk.Frame(self, style="Panel.TFrame", padding=(14, 10))
        top.pack(side="top", fill="x")
        ttk.Label(top, text="Serial Port:", style="Panel.TLabel").pack(side="left")

        self.port_var = tk.StringVar()
        self.port_cb = ttk.Combobox(top, textvariable=self.port_var, width=20,
                                    state="readonly")
        self.port_cb.pack(side="left", padx=8)

        ttk.Button(top, text="⟳", command=self._refresh_ports, width=3
                   ).pack(side="left")
        self.connect_btn = ttk.Button(top, text="Connect",
                                       command=self._toggle_connect)
        self.connect_btn.pack(side="left", padx=(12, 0))

        self.status_lbl = ttk.Label(top, text="● Disconnected",
                                     style="Panel.TLabel",
                                     foreground=self.MUTED,
                                     font=("Segoe UI", 10, "bold"))
        self.status_lbl.pack(side="right")

        # --- center: big gesture card -----------------------------------
        center = ttk.Frame(self, style="Panel.TFrame", padding=(24, 24))
        center.pack(side="top", fill="both", expand=True, padx=14, pady=14)

        self.icon_lbl = tk.Label(center, text="?", bg=self.PANEL,
                                  fg=self.MUTED, font=("Segoe UI Symbol", 140))
        self.icon_lbl.pack(pady=(20, 0))

        self.label_lbl = tk.Label(center, text="Waiting…", bg=self.PANEL,
                                   fg=self.FG, font=("Segoe UI", 40, "bold"))
        self.label_lbl.pack(pady=(4, 24))

        # Confidence bar (drawn on a Canvas so we can style freely)
        bar_frame = ttk.Frame(center, style="Panel.TFrame")
        bar_frame.pack(fill="x", padx=40)
        ttk.Label(bar_frame, text="Confidence", style="Muted.TLabel"
                  ).pack(anchor="w")
        self.bar_canvas = tk.Canvas(bar_frame, height=18, bg=self.BG,
                                     highlightthickness=0)
        self.bar_canvas.pack(fill="x", pady=(4, 2))
        self.bar_pct_lbl = ttk.Label(bar_frame, text="—",
                                       style="Muted.TLabel",
                                       font=("Segoe UI", 9))
        self.bar_pct_lbl.pack(anchor="e")

        # --- history strip ----------------------------------------------
        hist = ttk.Frame(self, style="Panel.TFrame", padding=(14, 10))
        hist.pack(side="top", fill="x", padx=14)
        ttk.Label(hist, text="Recent windows", style="Muted.TLabel"
                  ).pack(anchor="w")
        self.hist_canvas = tk.Canvas(hist, height=44, bg=self.PANEL,
                                      highlightthickness=0)
        self.hist_canvas.pack(fill="x", pady=(4, 0))

        # --- statistics + log ------------------------------------------
        bottom = ttk.Frame(self, style="Panel.TFrame", padding=(14, 8))
        bottom.pack(side="top", fill="x", padx=14, pady=(10, 14))
        self.stats_lbl = ttk.Label(bottom, text="Statistics: —",
                                    style="Panel.TLabel",
                                    font=("Consolas", 10))
        self.stats_lbl.pack(anchor="w")

        # Populate ports at startup
        self._refresh_ports()

    # ------------------------------------------------------------------
    def _refresh_ports(self):
        ports = [p.device for p in serial.tools.list_ports.comports()]
        if not ports:
            ports = ["(no serial ports found)"]
        self.port_cb["values"] = ports
        if self.port_var.get() not in ports:
            self.port_var.set(ports[0])

    def _toggle_connect(self):
        if self.reader and self.reader.is_alive():
            self.stop_evt.set()
            self.reader.join(timeout=1.0)
            self.reader = None
            self.connect_btn.configure(text="Connect")
            self._set_status("Disconnected", self.MUTED)
            return

        port = self.port_var.get()
        if not port or port.startswith("("):
            self._set_status("No port selected", self.ERR)
            return
        self.stop_evt = threading.Event()
        self.reader = SerialReader(port, DEFAULT_BAUD, self.q, self.stop_evt)
        self.reader.start()
        self.connect_btn.configure(text="Disconnect")
        self._set_status("Connecting…", self.WARN)

    # ------------------------------------------------------------------
    def _set_status(self, msg, color):
        self.status_lbl.configure(text=f"● {msg}", foreground=color)

    # ------------------------------------------------------------------
    #  Event pump — pull events off the queue in the Tk main thread
    # ------------------------------------------------------------------
    def _pump_events(self):
        try:
            while True:
                kind, payload = self.q.get_nowait()
                if kind == "cls":
                    self._on_cls(payload)
                elif kind == "gesture":
                    self._on_gesture_line(payload)
                elif kind == "status":
                    self._set_status(payload, self.OK if "Connect" in payload
                                     else self.MUTED)
                elif kind == "error":
                    self._set_status(payload, self.ERR)
                    self.connect_btn.configure(text="Connect")
                elif kind == "log":
                    pass    # (silently swallow banner/diag lines)
        except queue.Empty:
            pass
        self.after(50, self._pump_events)

    # ------------------------------------------------------------------
    def _on_cls(self, ev):
        cid = ev["id"]
        info = GESTURES.get(cid, GESTURES[0])
        self.current_cls  = cid
        self.current_dist = max(ev["distance"], 0)
        self.current_thr  = max(ev["threshold"], 1)
        self.last_update  = time.time()

        # Big label + icon
        self.icon_lbl.configure(text=info["icon"], fg=info["color"])
        self.label_lbl.configure(text=info["name"], fg=info["color"])

        # History + stats
        self.history.append(cid)
        self.stats[cid] += 1
        self._draw_history()
        self._draw_stats()
        self._draw_confidence()

    def _on_gesture_line(self, name):
        # main.c's confirmed-gesture printf (majority-vote filtered). Bring
        # attention to it by pulsing the label briefly.
        name_u = name.upper()
        for cid, info in GESTURES.items():
            if info["name"].upper() == name_u:
                self._flash(info["color"])
                break

    def _flash(self, color):
        orig = self.label_lbl.cget("bg")
        self.label_lbl.configure(bg=color, fg=self.BG)
        self.after(250, lambda: self.label_lbl.configure(bg=orig,
                            fg=GESTURES[self.current_cls]["color"]))

    # ------------------------------------------------------------------
    #  Confidence bar: 100% = distance is 0 (perfect match with centroid);
    #                    0% = distance == 2x threshold (well-rejected).
    # ------------------------------------------------------------------
    def _draw_confidence(self):
        c = self.bar_canvas
        c.delete("all")
        w = c.winfo_width() or 600
        h = int(c["height"])
        # Background track
        c.create_rectangle(0, 0, w, h, fill=self.BG, outline=self.PANEL)
        thr = max(self.current_thr, 1) * 2
        pct = 1.0 - min(1.0, self.current_dist / thr)
        fill_w = int(w * pct)
        info = GESTURES.get(self.current_cls, GESTURES[0])
        c.create_rectangle(0, 0, fill_w, h, fill=info["color"], outline="")
        self.bar_pct_lbl.configure(
            text=f"{pct*100:5.1f}%   (distance {self.current_dist} / threshold {self.current_thr})"
        )

    # ------------------------------------------------------------------
    def _draw_history(self):
        c = self.hist_canvas
        c.delete("all")
        w = c.winfo_width() or 800
        h = 44
        n = HISTORY_LEN
        cell_w = w / n
        for i, cid in enumerate(self.history):
            info = GESTURES.get(cid, GESTURES[0])
            x0 = int(i * cell_w) + 2
            x1 = int((i + 1) * cell_w) - 2
            c.create_rectangle(x0, 6, x1, h - 6,
                               fill=info["color"], outline="")
            c.create_text((x0 + x1) // 2, h // 2,
                          text=info["icon"],
                          fill=self.BG,
                          font=("Segoe UI Symbol", 14, "bold"))

    # ------------------------------------------------------------------
    def _draw_stats(self):
        total = sum(self.stats.values())
        if total == 0:
            self.stats_lbl.configure(text="Statistics: —")
            return
        parts = []
        for cid in sorted(GESTURES.keys()):
            name = GESTURES[cid]["name"]
            n = self.stats.get(cid, 0)
            pct = 100 * n / total if total else 0
            parts.append(f"{name}={n} ({pct:4.1f}%)")
        self.stats_lbl.configure(text="Statistics:  " + "   ".join(parts))

    # ------------------------------------------------------------------
    #  If no new classification arrives for > 3 s, fade the label.
    # ------------------------------------------------------------------
    def _decay_animation(self):
        if self.last_update and (time.time() - self.last_update) > 3.0:
            self.icon_lbl.configure(fg=self.MUTED)
            self.label_lbl.configure(fg=self.MUTED)
        self.after(500, self._decay_animation)

    # ------------------------------------------------------------------
    def destroy(self):
        self.stop_evt.set()
        if self.reader:
            self.reader.join(timeout=1.0)
        super().destroy()


# ---------------------------------------------------------------------------
if __name__ == "__main__":
    try:
        app = GestureGUI()
        app.mainloop()
    except KeyboardInterrupt:
        sys.exit(0)
