# 🧱 lock_multiple_displays.sh

## 🧠 Purpose
An interactive CLI tool to **track and restore multiple windows' positions and sizes** across a multi-display setup. Useful for developers or multitaskers who want windows to reopen exactly where they were — even after reboot or session reload.

---

## ⚙️ Features
- Select & track multiple open windows by number
- Save geometry (X, Y, Width, Height) to config
- Restore a single window manually or all automatically
- Infinite loop mode for rage-proof repositioning
- Handles window restoration across multiple monitors

---

## 📦 Dependencies
- `wmctrl`
- `jq`
- Tested and optimized for **Zsh**
- May not function properly on systems using **Bash as the default shell**

---

## 💻 Usage

### Launch CLI:
```bash
./lock_multiple_displays.sh
```

### Options:
```
1. Select and track multiple open windows
2. Restore one saved window by choice
3. Start background loop to restore all
4. Exit
```

### Background Watch Mode (loop):
Use Option 3 or:
```bash
./lock_multiple_displays.sh
```
and choose `3`.

---

## 🧪 Tested On
- ✅ Debian 12 Bookworm (v24.02)
- ✅ XFCE 4.18 (tiling manager)
- ✅ Multi-monitor setup with non-identical resolutions
- ✅ X11 windowing system

---

## 📁 Config Location
Saved state stored in:
```bash
~/.config/rage_window_state.json
```

---

## 💡 Tip: Autostart in XFCE
Use `Session and Startup` > `Application Autostart` to add:
```bash
/path/to/lock_multiple_displays.sh
```
