#!/bin/bash
# niri_move_float.sh <left|right|up|down>

DIRECTION=$1
STEP=${2:-0}
CORRECTION=${3:-0}

# Obtener datos
OUTPUT=$(niri msg --json outputs | jq -r '.["eDP-1"]')
WINDOW=$(niri msg --json windows | jq '.[] | select(.is_focused and .is_floating)')

SCREEN_W=$(echo "$OUTPUT" | jq '.logical.width')
SCREEN_H=$(echo "$OUTPUT" | jq '.logical.height')

WIN_W=$(echo "$WINDOW" | jq '.layout.tile_size[0] | . + 0.5 | floor | tostring' -r)
WIN_H=$(echo "$WINDOW" | jq '.layout.tile_size[1] | . + 0.5 | floor | tostring' -r)

case "$DIRECTION" in
  left)
    NEW_X=$(( STEP + CORRECTION ))
    niri msg action move-floating-window -x "$NEW_X" -y "+0"
    ;;
  right)
    NEW_X=$(( SCREEN_W - WIN_W - STEP - CORRECTION))
    niri msg action move-floating-window -x "$NEW_X" -y "+0"
    ;;
  up)
    NEW_Y=$(( STEP + CORRECTION ))
    niri msg action move-floating-window -x "+0" -y "$NEW_Y"
    ;;
  down)
    NEW_Y=$(( SCREEN_H - WIN_H - STEP - CORRECTION ))
    niri msg action move-floating-window -x "+0" -y "$NEW_Y"
    ;;
esac
