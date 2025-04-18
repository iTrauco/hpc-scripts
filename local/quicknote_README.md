# 📝 Quick Notes Launcher

This script launches a temporary, disposable note in a lightweight plain text editor (`mousepad`).

## 🔧 Setup

1. **Script Location**  
   Save the script here:
   ```bash
   ~/scripts/local/quicknote.sh
   ```

2. **Make it executable**
   ```bash
   chmod +x ~/scripts/local/quicknote.sh
   ```

3. **Set Global Hotkey (F8)**
   - Open Settings > Keyboard > Application Shortcuts
   - Click Add
   - Command:
     ```bash
     bash -c "~/scripts/local/quicknote.sh"
     ```
   - Press F8 to bind the hotkey

## 🧠 Usage

- Press F8 to open a burner note.
- Type freely in mousepad.
- Close the window when done.
- Notes are stored temporarily in /tmp and automatically discarded on reboot.

Let me know if you'd like a `burner_note.desktop` launcher next.
