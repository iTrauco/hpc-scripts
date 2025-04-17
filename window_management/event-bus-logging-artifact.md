# 📘 Technical Artifact: `event-bus.js` Logging Design Pattern

**Title**: Event Bus Logging Pattern & Debug Selector Standard  
**Author**: Christopher Trauco  
**Date**: 2025-04-17

---

## 🧩 Purpose

This artifact documents the **logging design pattern** for the `event-bus.js` module and provides a reproducible **standard for LLMs and developers** to implement consistent, structured debugging across future modules (e.g., store, component lifecycle, SVG rendering, drag system).

---

## 🔧 Design Goals

- ✅ Enable structured, traceable logging across all runtime communication  
- ✅ Maintain a single source of truth for event handling debug messages  
- ✅ Use visual-friendly formatting for terminal dev tools  
- ✅ Remain simple, human-readable, and script-compatible  
- ✅ Avoid runtime config complexity while enabling future trace control  

---

## 🔁 File: `event-bus.js`

### ✅ Logging Pattern

Each log entry follows this format:

```
[<LOG_LEVEL>] [EVENT] (<ISO_TIMESTAMP>) <MESSAGE>
```

### 💡 Log Levels Used

From `../config/constants.js`, use:

- `LogLevel.TRACE` → Internal handler-level detail  
- `LogLevel.DEBUG` → Structural actions like subscriptions/removals  
- `LogLevel.INFO` → General application flow  
- `LogLevel.WARN` → Expected but non-breaking issues  
- `LogLevel.ERROR` → Faults in handlers or logic  

### 🪪 Prefixes

| Prefix       | Purpose                          |
|--------------|----------------------------------|
| `[EVENT]`    | Event bus communication & flow   |
| `[STORE]`    | Central store & state changes    |
| `[COMPONENT]`| Component lifecycle (mount/init) |
| `[RENDER]`   | SVG render & quadrant placement  |
| `[DRAG]`     | Drag start/move/end events       |

All logs must include a prefix that maps to an observable subsystem.

---

## 🔍 Developer Workflow

1. **Run Selector Tool**

   ```bash
   ./log_selector.sh
   ```

   ✅ Choose what areas to trace (e.g., `[EVENT]`, `[DRAG]`)  
   ✅ Writes `log-trace-state.json` for visibility  

2. **Start App Normally**

   ```bash
   node app.js | grep '\[EVENT\]'
   ```

   ✅ No runtime logic needed  
   ✅ Just filter output based on prefix  

3. **View Output Example**

   ```
   [INFO] [EVENT] (2025-04-16T21:01:44.888Z) Emitting 'svg-selected' with data → Notifying 1 listeners  
   [TRACE] [EVENT] (2025-04-16T21:01:44.889Z) 'svg-selected' handled successfully by listener [0]
   ```

---

## 📐 Future Module Replication Standard

All future logging-enabled files should:

1. Use standardized `[TAG]` prefixing from the table above.  
2. Include `LogLevel` constants for severity tracking.  
3. Timestamp every log entry using `new Date().toISOString()`.  
4. Allow optional terminal filtering by tag (e.g., `grep '\[STORE\]'`).  
5. Persist user selections in `log-trace-state.json`, if applicable.  
6. Keep logic readable and decoupled from runtime logging configs.  

---

## 🔒 Simplicity by Design

- No `fs.readFileSync()` in runtime modules  
- Selector tools act as **config visibility**, not logic switches  
- Developers trace behavior via log output patterns, not flags  

---

## 🧠 Summary

This pattern ensures that all logs are:

- 💡 Predictable  
- 🧹 Clean  
- 📊 Traceable  
- 🔍 Grep/filter compatible  
- 🧩 Easy to expand to other areas  

By following this artifact, new LLM agents or teammates can replicate the design across the project and debugging experience will remain intuitive and consistent.
