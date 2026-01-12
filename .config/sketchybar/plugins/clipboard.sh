#!/bin/bash

# SketchyBar Clipboard Manager Plugin  
# Opens Maccy directly to avoid keyboard simulation interference

# Provide immediate visual feedback
source "$CONFIG_DIR/colors.sh"
sketchybar --set "$NAME" icon.color=$LIGHT_BLUE

# Open Maccy directly - this should show the clipboard interface
# without interfering with keyboard input
open -a "Maccy"

# Reset visual feedback
sleep 0.1
sketchybar --set "$NAME" icon.color=$WHITE
