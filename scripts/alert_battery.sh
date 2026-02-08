#!/bin/bash
# Matar instancias anteriores del mismo script
SCRIPT_PATH="$(readlink -f "$0")"
CURRENT_PID=$$
for pid in $(pgrep -f "$SCRIPT_PATH"); do
  [[ "$pid" != "$CURRENT_PID" ]] && kill "$pid" 2>/dev/null
done
sleep 0.05

# Variables para rastrear estados y tiempos
previous_status=""
last_low_battery_notify=0
last_charging_notify=0
last_full_notify=0

# Bucle principal - verifica cada segundo
while true; do
  bat=$(cat /sys/class/power_supply/BAT1/capacity)
  status=$(cat /sys/class/power_supply/BAT1/status)
  current_time=$(date +%s)

  # Detectar cambio de estado (conectar/desconectar cargador)
  if [ -n "$previous_status" ] && [ "$previous_status" != "$status" ]; then
    if [ "$status" = "Charging" ]; then
      notify-send --app-name Alerta_Bateria -u normal "🔌 Cargador conectado" "Cargando: $bat%" -u normal
    elif [ "$status" = "Discharging" ] && [ "$previous_status" = "Charging" ]; then
      notify-send --app-name Alerta_Bateria -u normal "🔋 Cargador desconectado" "Batería: $bat%" -u normal
    elif [ "$status" = "Full" ] && [ "$previous_status" = "Charging" ]; then
      notify-send --app-name Alerta_Bateria -u low "🔋 Batería llena" "Puedes desconectar el cargador" -u normal
      last_full_notify=$current_time
    fi
  fi

  # Actualizar estado anterior
  previous_status="$status"

  # Notificaciones periódicas según estado (con cooldown)
  if [ "$status" = "Discharging" ]; then
    if [ "$bat" -le 10 ]; then
      # Crítico: notifica cada 5 segundos
      if [ $((current_time - last_low_battery_notify)) -ge 5 ]; then
        notify-send "🪫 Batería crítica" "Nivel: $bat%" -u critical
        last_low_battery_notify=$current_time
      fi
    elif [ "$bat" -le 25 ]; then
      # Bajo: notifica cada 5 minutos
      if [ $((current_time - last_low_battery_notify)) -ge 300 ]; then
        notify-send --app-name Alerta_Bateria -u critical "🪫 Batería baja" "Nivel: $bat%" -u normal
        last_low_battery_notify=$current_time
      fi
    fi
  elif [ "$status" = "Charging" ]; then
    if [ "$bat" -ge 95 ]; then
      # Casi llena: notifica cada 10 minutos
      if [ $((current_time - last_charging_notify)) -ge 600 ]; then
        notify-send --app-name Alerta_Bateria -u low "⚡ Batería casi llena" "Nivel: $bat%" -u normal
        last_charging_notify=$current_time
      fi
    elif [ "$bat" -ge 85 ]; then
      # Cargando alto: notifica cada 10 minutos
      if [ $((current_time - last_charging_notify)) -ge 600 ]; then
        notify-send --app-name Alerta_Bateria -u normal "⚡ Cargando" "Nivel: $bat%" -u low
        last_charging_notify=$current_time
      fi
    fi
  elif [ "$status" = "Full" ]; then
    # Llena: notifica cada 10 minutos si no cambió de estado
    if [ $((current_time - last_full_notify)) -ge 600 ]; then
      notify-send --app-name Alerta_Bateria -u low "🔋 Batería llena" "Puedes desconectar el cargador" -u normal
      last_full_notify=$current_time
    fi
  else
    notify-send --app-name Alerta_Bateria -u critical "⚠️ Estado desconocido" "No se puede leer el estado de la batería" -u normal
  fi

  # Verifica cada segundo para detectar cambios rápidamente
  sleep 1
done
