#!/bin/bash
# ~/.config/scripts/atajos_niri.sh

grep 'hotkey-overlay-title' ~/.config/niri/niri/blinds.kdl | \
awk '
  BEGIN {
    # Símbolos especiales
    sym["Xf86audiomicmute"]      = "󰍭"
    sym["Xf86audiomute"]         = "󰖁"
    sym["Xf86audionext"]         = "󰒬"
    sym["Xf86audiopause"]        = "󰐎"
    sym["Xf86audioPlay"]         = "󰐎"
    sym["Xf86audioprev"]         = "󰒫"
    sym["Xf86audiostop"]         = "󰓛"
    sym["Xf86audiolowervolume"]  = "󰖀"
    sym["Xf86audioraisevolume"]  = "󰕾"
    sym["Xf86monbrightnessdown"] = "󰃠"
    sym["Xf86monbrightnessup"]   = "󰃞"
    sym["Left"]                  = "󰨂"
    sym["Right"]                 = "󰨃"
    sym["Down"]                  = "󰚶"
    sym["Up"]                    = "󰚷"
    sym["Backspace"]             = "󰌍"
    sym["Ctrl"]                  = "󰘴"
    sym["Minus"]                 = "-"
    sym["Mod"]                   = "󰖳"
    sym["Plus"]                  = "+"
    sym["Print"]                 = "󰹑"
    sym["Return"]                = "󰌑"
    sym["Shift"]                 = "󰘶"
    sym["Space"]                 = "󱁐"
    sym["Tab"]                   = "󰌒"
    sym["U00BA"]                 = "º"
    sym["Escape"]                = "󱊷"
    sym["F1"]                    = "󱊫"
    sym["F2"]                    = "󱊬"
    sym["F3"]                    = "󱊭"
    sym["F4"]                    = "󱊮"
    sym["F5"]                    = "󱊯"
    sym["F6"]                    = "󱊰"
    sym["F7"]                    = "󱊱"
    sym["F8"]                    = "󱊲"
    sym["F9"]                    = "󱊳"
    sym["F10"]                   = "󱊴"
    sym["F11"]                   = "󱊵"
    sym["F12"]                   = "󱊶"
    sym["Home"]                  = "Inicio"
    sym["Touchpadscrollleft"]    = "← Scroll"
    sym["Touchpadscrollright"]   = "→ Scroll"
    sym["Touchpadscrolldown"]    = "↓ Scroll"
    sym["Touchpadscrollup"]      = "↑ Scroll"
  }
  {
    # Extraer keybind (todo lo que está antes de hotkey-overlay-title)
    if (!match($0, /hotkey-overlay-title="([^"]+)"/, m)) next

    line = $0
    gsub(/^[[:space:]]+/, "", line)

    # Keybind es la primera palabra de la línea
    split(line, parts, " ")
    keybind = parts[1]
    desc    = m[1]

    # Aplicar sustituciones de símbolos al keybind
    for (k in sym) {
      gsub(k, sym[k], keybind)
    }

    # Separar los modificadores con " + "
    gsub(/\+/, " + ", keybind)
    gsub(/  +/, " ", keybind)

    printf "%-40s %s\n", keybind, desc
  }
' | \
fzf \
  --prompt="󰍉 Buscar atajo: " \
  --height=80% \
  --border=rounded \
  --preview-window=hidden \
  --header="$(printf ' Atajos de Niri  |  󰖳 = Super  󰘶 = Shift  󰘴 = Ctrl\n')" \
  --color='header:italic:yellow,prompt:cyan,pointer:magenta'
