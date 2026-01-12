#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# フォーカス中のワークスペースを取得
FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)

# フォーカス中のアプリ名を取得
FOCUSED_APP=$(aerospace list-windows --focused --json 2>/dev/null | jq -r '.[0]["app-name"]' 2>/dev/null)

# 非空ワークスペースを取得
WORKSPACES=$(aerospace list-workspaces --monitor all --empty no 2>/dev/null)

# 現在のspaceアイテムを取得
CURRENT_ITEMS=$(sketchybar --query bar | jq -r '.items[]' 2>/dev/null | grep '^space\.' | grep -v separator)

# 必要なアイテムのリスト
NEEDED_ITEMS=""

if [ -z "$WORKSPACES" ]; then
    # すべて削除
    for item in $CURRENT_ITEMS; do
        sketchybar --remove "$item" 2>/dev/null
    done
    exit 0
fi

# ワークスペースごとにアイテムを更新/作成
while IFS= read -r sid; do
    [ -z "$sid" ] && continue

    NEEDED_ITEMS="$NEEDED_ITEMS space.$sid.num space.$sid.apps"

    # ワークスペース内のウィンドウを取得
    WINDOWS=$(aerospace list-windows --workspace "$sid" --json 2>/dev/null)

    # フォーカス中のワークスペースかどうか
    if [ "$sid" = "$FOCUSED" ]; then
        BG_DRAWING="on"
        BG_COLOR="$LIGHT_GREY"
        NUM_COLOR="$WHITE"
        ACTIVE_COLOR="$CYAN"
        OTHER_COLOR="$WHITE"

        # アクティブアプリのアイコンをiconに、他をlabelに分離
        ACTIVE_ICON=""
        OTHER_ICONS=""

        if [ "$WINDOWS" != "[]" ] && [ -n "$WINDOWS" ]; then
            APP_NAMES=$(echo "$WINDOWS" | jq -r '.[].["app-name"]' 2>/dev/null | sort -u)
            while IFS= read -r app; do
                [ -z "$app" ] && continue
                APP_ICON=$($CONFIG_DIR/plugins/icon_map_fn.sh "$app")
                if [ "$app" = "$FOCUSED_APP" ]; then
                    ACTIVE_ICON="$APP_ICON"
                else
                    OTHER_ICONS="$OTHER_ICONS $APP_ICON"
                fi
            done <<< "$APP_NAMES"
        fi
    else
        BG_DRAWING="off"
        BG_COLOR="0x00000000"
        NUM_COLOR="$WHITE"
        ACTIVE_COLOR="$WHITE"
        OTHER_COLOR="$WHITE"

        # 非フォーカス: 全アプリをアイコンに
        ACTIVE_ICON=""
        OTHER_ICONS=""
        FIRST=true
        if [ "$WINDOWS" != "[]" ] && [ -n "$WINDOWS" ]; then
            APP_NAMES=$(echo "$WINDOWS" | jq -r '.[].["app-name"]' 2>/dev/null | sort -u)
            while IFS= read -r app; do
                [ -z "$app" ] && continue
                APP_ICON=$($CONFIG_DIR/plugins/icon_map_fn.sh "$app")
                if [ "$FIRST" = true ]; then
                    ACTIVE_ICON="$APP_ICON"
                    FIRST=false
                else
                    OTHER_ICONS="$OTHER_ICONS $APP_ICON"
                fi
            done <<< "$APP_NAMES"
        fi
    fi

    # 番号アイテムが存在するか確認
    if echo "$CURRENT_ITEMS" | grep -q "^space\.$sid\.num$"; then
        # 既存アイテムを更新
        sketchybar --set space.$sid.num icon="$sid"                              \
                                        icon.color="$NUM_COLOR"
    else
        # 新規作成（背景なし）
        sketchybar --add item space.$sid.num left                                \
                   --set space.$sid.num icon="$sid"                              \
                                        icon.font="SF Pro:Bold:14.0"             \
                                        icon.color="$NUM_COLOR"                  \
                                        icon.padding_left=6                      \
                                        icon.padding_right=6                     \
                                        label.drawing=off                        \
                                        background.drawing=off                   \
                                        padding_left=3                           \
                                        padding_right=0                          \
                                        script="$CONFIG_DIR/plugins/space.sh"    \
                   --subscribe space.$sid.num mouse.clicked
    fi

    # labelが空かどうかでdrawingとpaddingを切り替え
    if [ -z "$OTHER_ICONS" ] || [ "$OTHER_ICONS" = " " ]; then
        LABEL_DRAWING="off"
        ICON_PADDING_RIGHT=6
        LABEL_PADDING_LEFT=0
        LABEL_PADDING_RIGHT=0
    else
        LABEL_DRAWING="on"
        ICON_PADDING_RIGHT=2
        LABEL_PADDING_LEFT=2
        LABEL_PADDING_RIGHT=8
    fi

    # アプリアイコンアイテムが存在するか確認
    if echo "$CURRENT_ITEMS" | grep -q "^space\.$sid\.apps$"; then
        # 既存アイテムを更新
        sketchybar --set space.$sid.apps icon="$ACTIVE_ICON"                     \
                                         icon.color="$ACTIVE_COLOR"              \
                                         icon.padding_right="$ICON_PADDING_RIGHT" \
                                         label="$OTHER_ICONS"                    \
                                         label.drawing="$LABEL_DRAWING"          \
                                         label.padding_left="$LABEL_PADDING_LEFT" \
                                         label.padding_right="$LABEL_PADDING_RIGHT" \
                                         label.color="$OTHER_COLOR"              \
                                         background.drawing="$BG_DRAWING"        \
                                         background.color="$BG_COLOR"            \
                                         popup.background.color="$ITEM_BG_COLOR" \
                                         popup.background.corner_radius=10       \
                                         popup.background.border_width=1         \
                                         popup.background.border_color=$LIGHT_GREY \
                                         popup.y_offset=-1                       \
                   --subscribe space.$sid.apps mouse.clicked mouse.entered mouse.exited
    else
        # 新規作成
        sketchybar --add item space.$sid.apps left                               \
                   --set space.$sid.apps icon="$ACTIVE_ICON"                     \
                                         icon.font="sketchybar-app-font:Regular:17.0" \
                                         icon.color="$ACTIVE_COLOR"              \
                                         icon.padding_left=4                     \
                                         icon.padding_right="$ICON_PADDING_RIGHT" \
                                         label="$OTHER_ICONS"                    \
                                         label.font="sketchybar-app-font:Regular:17.0" \
                                         label.color="$OTHER_COLOR"              \
                                         label.drawing="$LABEL_DRAWING"          \
                                         label.padding_left="$LABEL_PADDING_LEFT" \
                                         label.padding_right="$LABEL_PADDING_RIGHT" \
                                         label.y_offset=-1                       \
                                         background.corner_radius=10             \
                                         background.height=24                    \
                                         background.drawing="$BG_DRAWING"        \
                                         background.color="$BG_COLOR"            \
                                         padding_left=2                          \
                                         padding_right=3                         \
                                         script="$CONFIG_DIR/plugins/space.sh"   \
                                         popup.background.color="$ITEM_BG_COLOR" \
                                         popup.background.corner_radius=10       \
                                         popup.background.border_width=1         \
                                         popup.background.border_color=$LIGHT_GREY \
                                         popup.y_offset=-1                       \
                   --subscribe space.$sid.apps mouse.clicked mouse.entered mouse.exited
    fi

done <<< "$WORKSPACES"

# 不要なアイテムを削除
for item in $CURRENT_ITEMS; do
    if ! echo "$NEEDED_ITEMS" | grep -q "$item"; then
        sketchybar --remove "$item" 2>/dev/null
    fi
done

# アイテムの順序を整理
ORDER_ARGS="apple_logo"
while IFS= read -r sid; do
    [ -z "$sid" ] && continue
    ORDER_ARGS="$ORDER_ARGS space.$sid.num space.$sid.apps"
done <<< "$WORKSPACES"
ORDER_ARGS="$ORDER_ARGS space_separator"

sketchybar --reorder $ORDER_ARGS 2>/dev/null
