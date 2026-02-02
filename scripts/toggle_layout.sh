#!/run/current-system/sw/bin/bash

# ~/.config/hypr/scripts/toggle_layout.sh

CACHE_DIR="$HOME/.cache/dotfiles"
CONFIG_FILE="$CACHE_DIR/layout.conf"
BINDS_FILE="$CACHE_DIR/binds.conf"
mkdir -p "$CACHE_DIR"

# ============================
# Plantillas de Keybindings
# ============================
write_dwindle_binds() {
  cat <<EOF
source = ~/.config/hypr/hyprland/keybindings/dwindle.conf
EOF
}

write_master_binds() {
  cat <<EOF
source = ~/.config/hypr/hyprland/keybindings/master.conf
EOF
}

write_scrolling_binds() {
  cat <<EOF
source = ~/.config/hypr/hyprland/plugins/scrolling.conf
EOF
}

# ============================
# Inicialización de archivos
# ============================
if [ ! -f "$CONFIG_FILE" ]; then
  echo "\$layout = dwindle" >"$CONFIG_FILE"
fi

if [ ! -f "$BINDS_FILE" ]; then
  {
    echo "# Keybindings dinámicos iniciales (Dwindle)"
    echo
    write_dwindle_binds
  } >"$BINDS_FILE"
fi

# ============================
# Función para generar binds
# ============================
generate_binds() {
  local mode="$1"
  {
    echo "# Keybindings dinámicos ($mode)"
    echo
    case "$mode" in
    dwindle) write_dwindle_binds ;;
    master) write_master_binds ;;
    scrolling) write_scrolling_binds ;;
    esac
  } >"$BINDS_FILE"
}

# ============================
# Lógica de alternancia
# ============================
scrolling_exists() {
  CURRENT_LAYOUT=$(grep "layout =" "$CONFIG_FILE" | sed 's/.*layout = //')

  case "$CURRENT_LAYOUT" in
  scrolling)
    sed -i 's/layout = scrolling/layout = dwindle/' "$CONFIG_FILE"
    hyprctl keyword general:layout dwindle
    generate_binds "dwindle"
    notify-send --app-name Disposicion "🪟 Layout" "Disposición tipo: DWINDLE"
    ;;
  dwindle)
    sed -i 's/layout = dwindle/layout = master/' "$CONFIG_FILE"
    hyprctl keyword general:layout master
    generate_binds "master"
    notify-send --app-name Disposicion "🪟 Layout" "Disposición tipo: MASTER"
    ;;
  master)
    sed -i 's/layout = master/layout = scrolling/' "$CONFIG_FILE"
    hyprctl keyword general:layout scrolling
    generate_binds "scrolling"
    notify-send --app-name Disposicion "🪟 Layout" "Disposición tipo: SCROLLING"
    ;;
  esac
}

scrolling_not_exists() {
  CURRENT_LAYOUT=$(grep "layout =" "$CONFIG_FILE" | sed 's/.*layout = //')

  case "$CURRENT_LAYOUT" in
  master)
    sed -i 's/layout = master/layout = dwindle/' "$CONFIG_FILE"
    hyprctl keyword general:layout dwindle
    generate_binds "dwindle"
    notify-send --app-name Disposicion "🪟 Layout" "Disposición tipo: DWINDLE"
    ;;
  dwindle)
    sed -i 's/layout = dwindle/layout = master/' "$CONFIG_FILE"
    hyprctl keyword general:layout master
    generate_binds "master"
    notify-send --app-name Disposicion "🪟 Layout" "Disposición tipo: MASTER"
    ;;
  esac
}

# ============================
# Detección y ejecución
# ============================
# FIX: Agregar $(...) para ejecutar el comando
if hyprctl layouts | grep -q "scrolling"; then
  scrolling_exists
else
  scrolling_not_exists
fi
