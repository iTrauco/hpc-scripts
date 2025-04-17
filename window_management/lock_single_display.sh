#!/usr/bin/env bash

CONFIG="${HOME}/.config/rage_window_state.json"
mkdir -p "$(dirname "$CONFIG")"

function list_windows() {
  mapfile -t windows < <(wmctrl -lG)
  echo ""
  for i in "${!windows[@]}"; do
    line="${windows[$i]}"
    title=$(echo "$line" | cut -d ' ' -f8-)
    echo "$((i + 1)). $title"
  done
}

function select_window_and_save() {
  list_windows
  echo ""
  read -p "Enter window number to track: " index
  if [[ ! "$index" =~ ^[0-9]+$ ]] || ((index < 1 || index > ${#windows[@]})); then
    echo "❌ Invalid selection."
    exit 1
  fi

  selected="${windows[$((index - 1))]}"
  win_id=$(echo "$selected" | awk '{print $1}')
  x=$(echo "$selected" | awk '{print $3}')
  y=$(echo "$selected" | awk '{print $4}')
  w=$(echo "$selected" | awk '{print $5}')
  h=$(echo "$selected" | awk '{print $6}')
  title=$(echo "$selected" | cut -d ' ' -f8-)

  jq -n --arg title "$title" --arg id "$win_id" \
        --argjson x "$x" --argjson y "$y" --argjson w "$w" --argjson h "$h" \
        '{title: $title, id: $id, x: $x, y: $y, w: $w, h: $h}' > "$CONFIG"

  echo "✅ Tracked \"$title\" at ($x,$y) ${w}x${h}"
}

function restore_from_saved() {
  [[ ! -f "$CONFIG" ]] && echo "⚠️ No saved state." && return

  title=$(jq -r '.title' "$CONFIG")
  x=$(jq -r '.x' "$CONFIG")
  y=$(jq -r '.y' "$CONFIG")
  w=$(jq -r '.w' "$CONFIG")
  h=$(jq -r '.h' "$CONFIG")

  wmctrl -lG | grep "$title" | while read -r line; do
    win_id=$(echo "$line" | awk '{print $1}')
    wmctrl -i -r "$win_id" -e "0,$x,$y,$w,$h"
    echo "✅ Restored \"$title\""
  done
}

function loop_restore() {
  echo "🔁 Watching for \"$title\" to appear..."
  while true; do
    restore_from_saved
    sleep 2
  done
}

function menu() {
  echo ""
  echo "📐 Window Rage Tracker"
  echo "1. Select window to track and store in state"
  echo "2. Restore window using saved state (one-time)"
  echo "3. Select new window to track and overwrite state"
  echo "4. Start loop using saved state (forever fix)"
  echo "5. Exit"
  echo ""
  read -p "Choose an option: " choice

  case "$choice" in
    1) select_window_and_save ;;
    2) restore_from_saved ;;
    3) select_window_and_save ;;
    4) loop_restore ;;
    5) exit 0 ;;
    *) echo "❌ Invalid choice" ;;
  esac
}

menu

