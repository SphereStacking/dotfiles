#!/bin/bash

sketchybar --add item lock right \
           --set lock icon=$LOCK_SCREEN \
                      icon.font="SF Pro:Semibold:16.0" \
                      icon.width=33 \
                      icon.color=$PINK \
                      label.drawing=off \
                      background.drawing=on \
                      script="$PLUGIN_DIR/lock.sh" \
           --subscribe lock mouse.clicked mouse.entered mouse.exited
