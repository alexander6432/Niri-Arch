#!/run/current-system/sw/bin/bash

CONFIG_FILE="$HOME/.cache/dotfiles/colors_hyprland.conf"
#
# Matar instancias anteriores del mismo script
SCRIPT_PATH="$(readlink -f "$0")"
CURRENT_PID=$$

for pid in $(pgrep -f "$SCRIPT_PATH"); do
  [[ "$pid" != "$CURRENT_PID" ]] && kill "$pid" 2>/dev/null
done
sleep 0.05 # pequeño retraso para evitar carrera

# Función para obtener el valor rgba de una variable
get_color() {
  local varname="$1"
  grep "^\$${varname}[[:space:]]*=" "$CONFIG_FILE" | awk '{print $3}' | tr -d '[:space:]'
}

# Colores de borde por dirección
COLOR_DEFAULT="$(get_color primary)"
COLOR_DEFAULT2="$(get_color source_color)"

# Función para resetear colores cuando se abra una ventana
wait_and_reset() {
  local initial_count timeout=0
  initial_count=$(hyprctl clients -j | jq 'length')

  while [[ $timeout -lt 50 ]]; do # 10 segundos máximo
    sleep 0.2
    ((timeout++))
    local current_count
    current_count=$(hyprctl clients -j | jq 'length')

    if [[ $current_count -gt $initial_count ]]; then
      hyprctl keyword general:col.active_border "$COLOR_DEFAULT $COLOR_DEFAULT2 45deg"
      break
    fi
  done
  # resetea colores aun cuando no se abra una ventana despues de cierto tiempo
  hyprctl keyword general:col.active_border "$COLOR_DEFAULT $COLOR_DEFAULT2 45deg"
}

# Lanzar el monitor en background
wait_and_reset &
