#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

window_state() {
  # Get focused window info from aerospace
  WINDOW=$(aerospace list-windows --focused --json 2>/dev/null)

  args=()
  if [ -z "$WINDOW" ] || [ "$WINDOW" = "[]" ]; then
    args+=(--set $NAME icon=$AEROSPACE_TILED icon.color=$ORANGE label.drawing=off)
  else
    # Check window properties (aerospace has fewer window states than yabai)
    IS_FLOATING=$(echo "$WINDOW" | jq -r '.[0]["is-floating"]' 2>/dev/null)

    if [ "$IS_FLOATING" = "true" ]; then
      args+=(--set $NAME icon=$AEROSPACE_FLOAT icon.color=$MAGENTA label.drawing=off)
    else
      args+=(--set $NAME icon=$AEROSPACE_TILED icon.color=$ORANGE label.drawing=off)
    fi
  fi

  sketchybar -m "${args[@]}"
}

windows_on_spaces() {
  # Get all workspaces with windows
  WORKSPACES=$(aerospace list-workspaces --monitor all --empty no 2>/dev/null)

  args=()
  while IFS= read -r space; do
    [ -z "$space" ] && continue
    icon_strip=" "
    apps=$(aerospace list-windows --workspace "$space" --json 2>/dev/null | jq -r '.[]["app-name"]' 2>/dev/null)
    if [ -n "$apps" ]; then
      while IFS= read -r app; do
        [ -z "$app" ] && continue
        icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
      done <<< "$apps"
    fi
    args+=(--set space.$space label="$icon_strip" label.drawing=on)
  done <<< "$WORKSPACES"

  sketchybar -m "${args[@]}"
}

mouse_clicked() {
  # Toggle float with aerospace
  aerospace layout floating tiling 2>/dev/null
  window_state
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked
  ;;
  "forced") exit 0
  ;;
  "window_focus") window_state
  ;;
  "windows_on_spaces") windows_on_spaces
  ;;
esac
