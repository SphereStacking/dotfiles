#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# AeroSpaceカスタムイベントを登録
sketchybar --add event aerospace_workspace_change

# ワークスペース1-9を静的に作成（FelixKratz style）
SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9")

sid=0
spaces=()
for i in "${!SPACE_ICONS[@]}"
do
  sid=$(($i+1))

  space=(
    icon=${SPACE_ICONS[i]}
    icon.padding_left=10
    icon.padding_right=10
    padding_left=2
    padding_right=2
    label.padding_right=20
    icon.highlight_color=$RED
    label.font="sketchybar-app-font:Regular:16.0"
    label.background.height=26
    label.background.drawing=on
    label.background.color=$BACKGROUND_2
    label.background.corner_radius=8
    label.drawing=off
    script="$PLUGIN_DIR/space.sh"
  )

  sketchybar --add item space.$sid left    \
             --set space.$sid "${space[@]}" \
             --subscribe space.$sid mouse.clicked aerospace_workspace_change
done

spaces_bracket=(
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
  background.border_width=2
  background.drawing=on
)

sketchybar --add bracket spaces '/space\..*/' \
           --set spaces "${spaces_bracket[@]}"

# 初期のワークスペース状態を更新
$PLUGIN_DIR/space.sh
