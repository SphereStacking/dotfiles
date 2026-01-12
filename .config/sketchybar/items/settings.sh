#!/bin/bash

sketchybar --add item settings right \
           --set settings icon=$SETTINGS \
                          icon.font="SF Pro:Semibold:16.0" \
                          icon.color=$WHITE \
                          icon.padding_left=6 \
                          icon.padding_right=6 \
                          label.drawing=off \
                          background.drawing=on \
                          click_script="open 'x-apple.systempreferences:'"
