# Original file: chrome-unique.sh 
# Version date: Fri Apr 18 08:25:09 AM EDT 2025 
# Git branch: unique-visitor 
# Last commit: feat: seconc script loads but errors to KMS: DRM_IOCTL_MODE_CREATE_DUMB failed: Permission denied in terminal 

# NEW VERSION - Original backed up to: orig.chrome-unique.v1_2025-04-18_08-20.sh 
# Version date: Fri Apr 18 08:20:30 AM EDT 2025 
# Git branch: unique-visitor 
# Last commit: feat: seconc script loads but errors to KMS: DRM_IOCTL_MODE_CREATE_DUMB failed: Permission denied in terminal 
#
#
#
#!/bin/bash

# Create a completely isolated temporary profile directory
TEMP_PROFILE=$(mktemp -d)

# Generate a slightly randomized user agent
RANDOM_VERSION=$((110 + RANDOM % 10))
RANDOM_UA="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/$RANDOM_VERSION.0.0.0 Safari/537.36"

# Check if chromium-browser is available, otherwise use google-chrome
if command -v chromium-browser &> /dev/null; then
    BROWSER="chromium-browser"
else
    BROWSER="google-chrome"
fi

# Launch browser with temporary profile and privacy settings
$BROWSER \
  --incognito \
  --user-data-dir="$TEMP_PROFILE" \
  --disable-cache \
  --disable-application-cache \
  --disable-local-storage \
  --disable-session-storage \
  --disable-features=NetworkPrediction \
  --user-agent="$RANDOM_UA" \
  --no-first-run \
  --no-default-browser-check \
  "https://chat.openai.com/"

# Optional: remove the temp profile when browser closes
# rm -rf "$TEMP_PROFILE"
