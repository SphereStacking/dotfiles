#!/bin/bash

sketchybar --add item apple_logo left \
           --set apple_logo icon=$APPLE \
                            icon.font="SF Pro:Black:16.0" \
                            icon.color=$WHITE \
                            icon.y_offset=1 \
                            label.drawing=off \
                            padding_left=6 \
                            padding_right=10 \
                            icon.padding_left=8 \
                            icon.padding_right=8 \
                            background.corner_radius=15 \
                            background.height=28 \
                            background.color=$ITEM_BG_COLOR \
                            background.drawing=on \
                            click_script="$PLUGIN_DIR/apple_menu.sh"
