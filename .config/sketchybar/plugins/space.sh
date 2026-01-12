#!/bin/bash

source "$CONFIG_DIR/colors.sh"

update() {
  # Get current focused workspace from aerospace
  FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)

  # Extract space ID from item name (e.g., space.1 -> 1)
  SPACE_ID=$(echo "$NAME" | sed 's/space\.//')

  # Check if this space is the focused one
  if [ "$SPACE_ID" = "$FOCUSED" ]; then
    SELECTED="true"
  else
    SELECTED="false"
  fi

  # Update highlight state
  WIDTH="dynamic"
  # if [ "$SELECTED" = "true" ]; then
  #   WIDTH="0"
  # fi

  sketchybar --animate tanh 20 --set $NAME icon.highlight=$SELECTED label.width=$WIDTH

  # Update app icons for this space
  WINDOWS=$(aerospace list-windows --workspace "$SPACE_ID" --json 2>/dev/null)
  if [ "$WINDOWS" != "[]" ] && [ -n "$WINDOWS" ]; then
    icon_strip=" "
    while IFS= read -r app; do
      [ -z "$app" ] && continue
      icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
    done <<< "$(echo "$WINDOWS" | jq -r '.[].["app-name"]' 2>/dev/null | sort -u)"
    sketchybar --set $NAME label="$icon_strip" label.drawing=on
  else
    sketchybar --set $NAME label.drawing=off
  fi
}

mouse_clicked() {
  # Focus workspace on click (aerospace doesn't support space destruction like yabai)
  SPACE_ID=$(echo "$NAME" | sed 's/space\.//')
  aerospace workspace "$SPACE_ID" 2>/dev/null
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked
  ;;
  *) update
  ;;
esac
