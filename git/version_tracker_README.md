# version_tracker.sh

🗃️ A lightweight shell script for developers to version source files with Git metadata and clean resets.

## What it does

- Select a file interactively from the current directory (recursively if needed).
- Archives the current file into a versioned backup with a timestamp.
- Embeds helpful metadata like:
  - Filename
  - Date
  - Git branch
  - Last commit message
- Clears the original file and inserts a fresh header indicating the backup location.

## Highlights

- Supports filtering by file extension (e.g., `.js`, `.py`)
- Automatically handles version increments (v1, v2, …)
- Compatible with most file types and comment styles

🧰 Ideal for system-config-style workflows and iterative coding sessions.

⚠️ **Note:**  
This script is optimized for the `zsh` shell. It may require slight adjustments to run on `bash` or other POSIX-compliant shells due to syntax nuances.

