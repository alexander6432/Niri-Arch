#!/run/current-system/sw/bin/bash

# Script para cambiar colores según submapa

CONFIG_FILE="$HOME/.cache/dotfiles/colors_hyprland.conf"

# Función para obtener el valor rgba de una variable
get_color() {
  local varname="$1"
  grep "^\$${varname}[[:space:]]*=" "$CONFIG_FILE" | awk '{print $3}' | tr -d '[:space:]'
}

submaps() {
  # Aplicar colores a Hyprland
  hyprctl keyword general:col.active_border "$active_border"
  hyprctl keyword decoration:shadow:enabled false
  hyprctl keyword decoration:rounding 0
  hyprctl keyword decoration:rounding_power 0
  hyprctl keyword decoration:active_opacity 0.9
  hyprctl keyword decoration:inactive_opacity 0.75

  hyprctl keyword group:col.border_active "$active_border"
  hyprctl keyword group:col.border_locked_active "$active_border"
  hyprctl keyword group:groupbar:gradient_rounding 0

  # Notificación
  notify-send --app-name Submaps -u normal "$title" "$message"
}

restore() {
  # Aplicar colores a Hyprland
  hyprctl keyword general:col.active_border "$active_border $secondary_border 45deg"
  hyprctl keyword decoration:shadow:enabled false
  hyprctl keyword decoration:rounding 8
  hyprctl keyword decoration:rounding_power 4
  hyprctl keyword decoration:active_opacity 1.0
  hyprctl keyword decoration:inactive_opacity 0.9

  hyprctl keyword group:col.border_active "$active_border $secondary_border 90deg"
  hyprctl keyword group:col.border_locked_active "$active_border $secondary_border 90deg"
  hyprctl keyword group:groupbar:gradient_rounding 4

  # Notificación
  notify-send --app-name Submaps -u normal "$title" "$message"
}
# Comprobar argumento con case
case "$1" in
ventanas)
  active_border="$(get_color secondary_container)"
  title="🪟 Submaps"
  message="Entrando de Submapa de Ventanas"
  submaps
  ;;
grupos)
  active_border="$(get_color tertiary_container)"
  title="🔀 Submaps"
  message="Entrando de Submapa de Grupos"
  submaps
  ;;
reset)
  active_border="$(get_color primary)"
  secondary_border="$(get_color source_color)"
  title="🔀 Submaps"
  message="Saliendo de Submapas"
  restore
  ;;
*)
  echo "Uso: $0 [ventanas|grupos]"
  exit 1
  ;;
esac
