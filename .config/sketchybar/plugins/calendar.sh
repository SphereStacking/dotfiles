#!/bin/bash

# 日本語の曜日
WEEKDAYS=("日" "月" "火" "水" "木" "金" "土")
DAY_OF_WEEK=${WEEKDAYS[$(date '+%w')]}

sketchybar --set $NAME icon="$(date '+%m月%d日')($DAY_OF_WEEK)" label="$(date '+%H:%M')"
