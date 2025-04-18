#!/bin/bash

# Function to launch a browser with random settings
launch_browser() {
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
  
  # Create a random set of flags
  FLAGS=("--user-data-dir=$TEMP_PROFILE" "--user-agent=$USER_AGENT" "--no-first-run")
  
  # Randomly add additional flags
  if [ $((RANDOM % 2)) -eq 0 ]; then
    FLAGS+=("--incognito")
  fi
  
  if [ $((RANDOM % 2)) -eq 0 ]; then
    FLAGS+=("--disable-blink-features=AutomationControlled")
  fi
  
  if [ $((RANDOM % 2)) -eq 0 ]; then
    FLAGS+=("--disable-webgl")
  fi
  
  if [ $((RANDOM % 2)) -eq 0 ]; then
    FLAGS+=("--js-flags=--jitless")
  fi
  
  if [ $((RANDOM % 2)) -eq 0 ]; then
    FLAGS+=("--disable-gpu")
  fi
  
  # Launch Chrome with these settings
  google-chrome "${FLAGS[@]}" "https://chat.openai.com/" &
}

# Ask how many browsers to launch
echo "How many browser instances would you like to launch? (1-10)"
read NUM_BROWSERS

# Validate input
if ! [[ "$NUM_BROWSERS" =~ ^[1-9]|10$ ]]; then
  echo "Invalid number. Launching 3 browsers by default."
  NUM_BROWSERS=3
fi

# Launch the specified number of browsers
for ((i=1; i<=NUM_BROWSERS; i++)); do
  echo "Launching browser instance $i..."
  launch_browser
  # Add a small delay between launches to prevent system overload
  sleep 2
done

echo "Launched $NUM_BROWSERS browser instances. Check your taskbar."
