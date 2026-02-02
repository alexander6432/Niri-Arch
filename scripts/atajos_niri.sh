#!/bin/bash
# ~/.local/bin/niri-keys-search
grep 'hotkey-overlay-title' ~/.config/niri/niri/blinds.kdl | \
    sed 's/^\s*//' | \
    sed 's/hotkey-overlay-title=//g' | \
    sed 's/"//g' | \
    sed 's/allow-when-locked=true//g' | \
    sed 's/allow-when-locked=false//g' | \
    sed 's/repeat=true//g' | \
    sed 's/repeat=false//g' | \
    sed 's/{.*//' | \
    sed 's/  \+/ /g' | \
    sed 's/XF86AudioRaiseVolume/󰕾/g' | \
    sed 's/XF86AudioLowerVolume/󰖀/g' | \
    sed 's/XF86AudioMute/󰖁/g' | \
    sed 's/XF86AudioMicMute/󰍭/g' | \
    sed 's/XF86MonBrightnessUp/󰃞/g' | \
    sed 's/XF86MonBrightnessDown/󰃠/g' | \
    sed 's/XF86AudioPlay/󰐎/g' | \
    sed 's/XF86AudioPause/󰐎/g' | \
    sed 's/XF86AudioStop/󰓛/g' | \
    sed 's/XF86AudioPrev/󰒫/g' | \
    sed 's/XF86AudioNext/󰒬/g' | \
    sed 's/Mod//g' | \
    sed 's/Shift/󰘶/g' | \
    sed 's/Return/󰌑/g' | \
    sed 's/Up/󰚷/g' | \
    sed 's/Left/󰨂/g' | \
    sed 's/Right/󰨃/g' | \
    sed 's/Down/󰚶/g' | \
    sed 's/Up/󰚷/g' | \
    sed 's/Left/󰨂/g' | \
    sed 's/Right/󰨃/g' | \
    sed 's/Print/ImprPant/g' | \
    sed 's/BackSpace/󰌍/g' | \
    sed 's/Space/󱁐/g' | \
    sed 's/Escape/Esc/g' | \
    sed 's/Minus/-/g' | \
    sed 's/Plus/+/g' | \
    sed 's/Home/Inicio/g' | \
    sed 's/TouchpadScroll/Scroll/g' | \
    sed 's/+/xxx/g' | \
    awk '{
        # Encuentra donde termina el keybind (primer espacio)
        match($0, /^[^ ]+/)
        keybind = substr($0, 1, RLENGTH)
        desc = substr($0, RLENGTH+1)
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", desc)
        printf "%-30s %s\n", keybind, desc
    }' | \
    sed 's/xxx/ + /g' | \
    fzf --prompt="🔍 Buscar atajo: " \
        --height=70% \
        --border=rounded \
        --preview-window=hidden \
        --header='Busca por tecla o descripción'
