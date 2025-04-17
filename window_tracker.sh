#!/usr/bin/env zsh

# Get list of open windows with geometry using wmctrl
windows=("${(@f)$(wmctrl -lG)}")

echo "\n📋 Open Windows:"
for i in {1..${#windows[@]}}; do
  line=${windows[$i]}
  # Parse fields: window ID, desktop, x, y, width, height, host, title
  win_id=$(echo "$line" | awk '{print $1}')
  x=$(echo "$line" | awk '{print $3}')
  y=$(echo "$line" | awk '{print $4}')
  width=$(echo "$line" | awk '{print $5}')
  height=$(echo "$line" | awk '{print $6}')
  title=$(echo "$line" | cut -d ' ' -f8-)
  echo "$i. [$win_id] $title — (${x},${y}) ${width}x${height}"
done

