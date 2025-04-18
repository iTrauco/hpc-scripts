# Original file: chrome-unique.sh 
# Version date: Fri Apr 18 08:20:30 AM EDT 2025 
# Git branch: unique-visitor 
# Last commit: feat: seconc script loads but errors to KMS: DRM_IOCTL_MODE_CREATE_DUMB failed: Permission denied in terminal 

# NEW VERSION - Original backed up to: orig.chrome-unique_2025-04-18_08-17.sh 
# Version date: Fri Apr 18 08:17:25 AM EDT 2025 
# Git branch: master 
# Last commit: initial commit / initial script 
#
#
#!/bin/bash

# Create a completely isolated temporary profile directory
TEMP_PROFILE=$(mktemp -d)

# Generate a slightly randomized user agent
RANDOM_VERSION=$((110 + RANDOM % 10))
RANDOM_UA="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/$RANDOM_VERSION.0.0.0 Safari/537.36"

# Launch Chromium with temporary profile and privacy settings
chromium-browser \
  --incognito \
  --user-data-dir="$TEMP_PROFILE" \
  --disable-cache \
  --disable-application-cache \
  --disable-local-storage \
  --disable-session-storage \
  --disable-features=NetworkPrediction,CookiesWithoutSameSiteMustBeSecure \
  --disable-site-isolation-trials \
  --disable-web-security \
  --user-agent="$RANDOM_UA" \
  --no-first-run \
  --no-default-browser-check \
  "https://chat.openai.com/"

# Optional: remove the temp profile when browser closes
# rm -rf "$TEMP_PROFILE"
