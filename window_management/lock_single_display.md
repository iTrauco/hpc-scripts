# 🧱 lock_single_display.sh

## 🧠 Purpose
This script locks a **single window** to a specific position and size on screen using its title, typically used during development when a utility window (e.g., Developer Tools) reopens in the wrong place.

---

## ⚙️ Functionality
- Tracks a hardcoded window title
- Stores desired X/Y position and size (Width x Height)
- Automatically snaps the window to the saved coordinates if it appears
- Can run once or in a loop for persistent monitoring

---

## 📦 Dependencies
- `wmctrl`
- Works best in **Zsh**
- Works on most Linux environments that support X11

---

## 💻 Usage

### One-time snap:
```bash
./lock_single_display.sh
```

### Continuous loop:
```bash
while true; do ./lock_single_display.sh; sleep 1; done
```

---

## ✅ Example
For a window titled `"Developer Tools"`:
- Set `TARGET_TITLE`
- Set desired `X`, `Y`, `W`, `H` in the script

---

## 🧪 Tested On
- Debian 12 Bookworm XFCE (v24.02)
- XFCE window manager (non-composited)

---
