#!/bin/bash

# Print header
echo -e "\e[1;36m====================================\e[0m"
echo -e "\e[1;36m  Window Position Detector  \e[0m"
echo -e "\e[1;36m====================================\e[0m"

# Check for xdotool
if ! command -v xdotool &> /dev/null; then
    echo -e "\e[1;31mxdotool not found. Please install with:\e[0m"
    echo -e "\e[1;33msudo apt-get install xdotool\e[0m"
    exit 1
fi

# Check for xrandr
if ! command -v xrandr &> /dev/null; then
    echo -e "\e[1;31mxrandr not found. Please install with:\e[0m"
    echo -e "\e[1;33msudo apt-get install x11-xserver-utils\e[0m"
    exit 1
fi

# Show display information
echo -e "\e[1;32mDetected displays:\e[0m"
xrandr --current | grep ' connected' | sed 's/primary //' | while read -r line; do
    display=$(echo "$line" | awk '{print $1}')
    resolution=$(echo "$line" | grep -oP '\d+x\d+\+\d+\+\d+' | head -1)
    if [ ! -z "$resolution" ]; then
        width=$(echo "$resolution" | cut -d'x' -f1)
        height=$(echo "$resolution" | cut -d'x' -f2 | cut -d'+' -f1)
        x_offset=$(echo "$resolution" | cut -d'+' -f2)
        y_offset=$(echo "$resolution" | cut -d'+' -f3)
        echo -e "  \e[1;36m$display\e[0m: ${width}x${height}, offset: +${x_offset}+${y_offset}"
    fi
done

echo -e "\e[1;33m\nInstructions:\e[0m"
echo -e "1. Click on this terminal window"
echo -e "2. Press Enter to start tracking"
echo -e "3. You'll have 3 seconds to click on the window you want to track"
echo -e "4. The script will record the window's position and size"
echo -e "5. Press Ctrl+C to exit the continuous tracking mode\n"

read -p "Press Enter to start tracking..."

echo -e "\e[1;33mYou have 3 seconds to click on the target window...\e[0m"
sleep 3

# Get active window
track_window() {
    WINDOW_ID=$(xdotool getactivewindow)
    WINDOW_NAME=$(xdotool getwindowname $WINDOW_ID)
    WINDOW_CLASS=$(xdotool getwindowclassname $WINDOW_ID)
    WINDOW_GEOMETRY=$(xdotool getwindowgeometry $WINDOW_ID)
    
    # Parse the geometry output
    X_POS=$(echo "$WINDOW_GEOMETRY" | grep Position | sed 's/Position: \([0-9]*\),\([0-9]*\).*/\1/')
    Y_POS=$(echo "$WINDOW_GEOMETRY" | grep Position | sed 's/Position: \([0-9]*\),\([0-9]*\).*/\2/')
    WIDTH=$(echo "$WINDOW_GEOMETRY" | grep Geometry | sed 's/Geometry: \([0-9]*\)x\([0-9]*\)/\1/')
    HEIGHT=$(echo "$WINDOW_GEOMETRY" | grep Geometry | sed 's/Geometry: \([0-9]*\)x\([0-9]*\)/\2/')
    
    clear
    echo -e "\e[1;32mWindow Information:\e[0m"
    echo -e "  \e[1;36mName:\e[0m $WINDOW_NAME"
    echo -e "  \e[1;36mClass:\e[0m $WINDOW_CLASS"
    echo -e "  \e[1;36mID:\e[0m $WINDOW_ID"
    echo -e "  \e[1;36mPosition:\e[0m ${X_POS},${Y_POS}"
    echo -e "  \e[1;36mSize:\e[0m ${WIDTH}x${HEIGHT}"
    
    # Generate devilspie2 script
    echo -e "\n\e[1;32mDevilspie2 Script:\e[0m"
    echo -e "\e[1;37m------------------------\e[0m"
    echo -e "-- For window name matching:"
    echo -e "if (string.match(get_window_name(), \"$WINDOW_NAME\")) then"
    echo -e "    set_window_geometry($X_POS, $Y_POS, $WIDTH, $HEIGHT);"
    echo -e "end"
    echo -e "\e[1;37m------------------------\e[0m"
    
    echo -e "\n-- For application class matching:"
    echo -e "if (get_window_class() == \"$WINDOW_CLASS\") then"
    echo -e "    set_window_geometry($X_POS, $Y_POS, $WIDTH, $HEIGHT);"
    echo -e "end"
    echo -e "\e[1;37m------------------------\e[0m"
    
    echo -e "\n\e[1;33mPress Ctrl+C to exit or wait 2 seconds for another measurement...\e[0m"
}

while true; do
    track_window
    sleep 2
  done
