#!/bin/bash

# Install devilspie2
sudo apt-get install -y devilspie2 xdotool

# Create config directory
mkdir -p ~/.config/devilspie2

# Create a script for DevTools window
cat > ~/.config/devilspie2/devtools.lua << 'EOL'
-- Match Developer Tools window
if (string.match(get_window_name(), "Developer Tools")) then
    -- Get screen info using xrandr
    local handle = io.popen("xrandr --current | grep ' connected'")
    local result = handle:read("*a")
    handle:close()
    
    -- Find secondary display if available
    local displays = {}
    for display, resolution in string.gmatch(result, "([%w%-]+)%s+connected[%s%w]*%s+([%d%a%+]+)") do
        table.insert(displays, {name=display, res=resolution})
    end
    
    local x_pos = 2000  -- Default X position
    local y_pos = 50    -- Default Y position
    
    -- If we have more than one display, position on the second one
    if #displays > 1 then
        -- Try to parse the position from the resolution string
        local second_display = displays[2].res
        local x_offset = string.match(second_display, "%+(%d+)%+%d+")
        
        if x_offset then
            x_pos = tonumber(x_offset) + 50  -- 50px from left of second monitor
        end
    end
    
    -- Position the window
    debug_print("Positioning Developer Tools at " .. x_pos .. "," .. y_pos)
    set_window_geometry(x_pos, y_pos, 800, 600);
end
EOL

# Create autostart entry
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/devilspie2.desktop << 'EOL'
[Desktop Entry]
Type=Application
Name=Devilspie2
Exec=devilspie2
Comment=Window positioning
X-GNOME-Autostart-enabled=true
EOL

echo "Devilspie2 has been set up!"
echo "To start it immediately, run: devilspie2 --debug"
echo "It will automatically start on your next login."
echo "Use the get-window-info.sh script to detect positions for other windows"
