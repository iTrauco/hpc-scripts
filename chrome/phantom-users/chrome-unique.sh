#!/bin/bash

# Create a temporary profile
TEMP_PROFILE=$(mktemp -d)

# Generate a realistic Chrome version
CHROME_VERSION=$((115 + RANDOM % 10))
MINOR_VERSION=$((RANDOM % 100))
BUILD_VERSION=$((RANDOM % 5000))

# Create user agent
USER_AGENT="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/$CHROME_VERSION.$MINOR_VERSION.$BUILD_VERSION Safari/537.36"

# Define empty array for flags
FLAGS=()

# Add flags with simple conditionals
if [ $((RANDOM % 2)) -eq 0 ]; then
    FLAGS+=("--disable-cache")
fi

if [ $((RANDOM % 2)) -eq 0 ]; then
    FLAGS+=("--disable-application-cache")
fi

if [ $((RANDOM % 3)) -eq 0 ]; then
    FLAGS+=("--incognito")
fi

# Launch browser with the simpler approach
google-chrome --user-data-dir="$TEMP_PROFILE" --user-agent="$USER_AGENT" --no-first-run "${FLAGS[@]}" "https://chat.openai.com/"

# Clean up comment (remove # to enable)
# rm -rf "$TEMP_PROFILE"
