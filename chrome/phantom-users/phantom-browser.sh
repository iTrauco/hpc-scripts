#!/bin/bash

# Create a temporary profile
TEMP_PROFILE=$(mktemp -d)

# Generate a realistic Chrome version
CHROME_VERSION=$((115 + RANDOM % 10))
MINOR_VERSION=$((RANDOM % 100))
BUILD_VERSION=$((RANDOM % 5000))

# Create user agent with OS variation
OS_OPTIONS=("Windows NT 10.0" "Windows NT 11.0" "Macintosh; Intel Mac OS X 10_15" "X11; Linux x86_64")
SELECTED_OS=${OS_OPTIONS[$RANDOM % ${#OS_OPTIONS[@]}]}

if [[ $SELECTED_OS == *"Windows"* ]]; then
  USER_AGENT="Mozilla/5.0 ($SELECTED_OS; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/$CHROME_VERSION.$MINOR_VERSION.$BUILD_VERSION Safari/537.36"
elif [[ $SELECTED_OS == *"Mac"* ]]; then
  USER_AGENT="Mozilla/5.0 ($SELECTED_OS) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Safari/605.1.15"
else
  USER_AGENT="Mozilla/5.0 ($SELECTED_OS) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/$CHROME_VERSION.$MINOR_VERSION.$BUILD_VERSION Safari/537.36"
fi

# Browser hardware configurations to randomize
HW_CORES=$((2 + RANDOM % 6))  # Between 2-8 cores
HW_RAM=$((2 + RANDOM % 14))   # Between 2-16 GB

# Launch Chrome with more advanced masking
google-chrome \
  --user-data-dir="$TEMP_PROFILE" \
  --user-agent="$USER_AGENT" \
  --no-first-run \
  --incognito \
  --disable-blink-features=AutomationControlled \
  --disable-webgl \
  --no-sandbox \
  --js-flags="--jitless" \
  --disable-gpu \
  --disk-cache-size=1 \
  --media-cache-size=1 \
  --disk-cache-dir=/dev/null \
  --js-flags="--random-seed=$RANDOM" \
  --device-scale-factor=$((1 + RANDOM % 3)) \
  --force-device-scale-factor=$((1 + RANDOM % 3)) \
  --window-size=$((800 + RANDOM % 400)),$((600 + RANDOM % 400)) \
  "https://chat.openai.com/"

# Clean up 
# rm -rf "$TEMP_PROFILE"
