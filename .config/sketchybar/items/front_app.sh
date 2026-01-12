#!/bin/bash

source "$CONFIG_DIR/icons.sh"

FRONT_APP_SCRIPT='sketchybar --set $NAME label="$INFO"'

# Aerospace window state indicator (replaces yabai)
aerospace=(
  script="$PLUGIN_DIR/aerospace_state.sh"
  icon.font="$FONT:Bold:16.0"
  label.drawing=off
  icon.width=30
  icon=$AEROSPACE_TILED
  icon.color=$ORANGE
  associated_display=active
)

front_app=(
  script="$FRONT_APP_SCRIPT"
  icon.drawing=off
  padding_left=0
  label.color=$WHITE
  label.font="$FONT:Black:12.0"
  associated_display=active
)

sketchybar --add event window_focus            \
           --add event windows_on_spaces       \
           --add item aerospace left           \
           --set aerospace "${aerospace[@]}"   \
           --subscribe aerospace window_focus  \
                             windows_on_spaces \
                             mouse.clicked     \
                                               \
           --add item front_app left           \
           --set front_app "${front_app[@]}"   \
           --subscribe front_app front_app_switched
