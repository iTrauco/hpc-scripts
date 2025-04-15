#!/bin/bash
# Script to keep displays off until Escape key is pressed

# Function to handle cleanup on exit
cleanup() {
  echo "Exiting and restoring displays..."
  exit 0
}

# Set up trap for Ctrl+C
trap cleanup SIGINT

echo "Turning displays off. Press Ctrl+C to exit and restore."

# Turn displays off initially
xset dpms force off

# Keep them off until interrupted
while true; do
  # Force displays off every 0.5 seconds
  xset dpms force off
  sleep 0.5
done
