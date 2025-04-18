# Original file: chrome-unique.sh 
# Version date: Fri Apr 18 08:17:25 AM EDT 2025 
# Git branch: master 
# Last commit: initial commit / initial script 

#!/bin/bash

# Create a temporary profile directory
TEMP_PROFILE=$(mktemp -d)

# Launch Chromium with privacy flags and temporary profile
chromium-browser \
  --incognito \
  --user-data-dir="$TEMP_PROFILE" \
  --disable-cache \
  --disable-application-cache \
  --disable-local-storage \
  --disable-session-storage \
  --disable-features=NetworkPrediction \
  --user-agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/$(( ( RANDOM % 10 ) + 110 )).0.0.0 Safari/537.36" \
  "https://amiunique.org/"

# Clean up when done
# rm -rf "$TEMP_PROFILE"  # Uncomment this if you want auto-cleanup
