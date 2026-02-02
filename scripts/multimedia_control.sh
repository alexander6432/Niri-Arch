#!/run/current-system/sw/bin/bash

# Script unificado para controles multimedia
# Compatible con niri y Hyprland

case "$1" in
    volume-up)
        wpctl set-volume -l 1.25 @DEFAULT_AUDIO_SINK@ 5%+
        volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%d%%", $2 * 100}')
        notify-send --app-name Volumen -u low "🔊 Volumen +" "$volume"
        ;;

    volume-down)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%d%%", $2 * 100}')
        notify-send --app-name Volumen -u low "🔉 Volumen -" "$volume"
        ;;

    volume-mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED; then
            notify-send --app-name Volumen -u low "🔇 Audio" "Silenciado"
        else
            notify-send --app-name Volumen -u low "🔊 Audio" "Activado"
        fi
        ;;

    mic-mute)
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED; then
            notify-send --app-name Micrófono -u low "🎙️ Micrófono" "Silenciado"
        else
            notify-send --app-name Micrófono -u low "🎙️ Micrófono" "Activado"
        fi
        ;;

    brightness-up)
        brightnessctl -e4 -n2 set 5%+
        brightness=$(brightnessctl | grep -oP '\(\K[0-9]+(?=%\))')
        notify-send --app-name Brillo -u low "🔆 Brillo ↑" "${brightness}%"
        ;;

    brightness-down)
        brightnessctl -e4 -n2 set 5%-
        brightness=$(brightnessctl | grep -oP '\(\K[0-9]+(?=%\))')
        notify-send --app-name Brillo -u low "🌙 Brillo ↓" "${brightness}%"
        ;;

    gamma-up)
        hyprctl hyprsunset gamma +10
        notify-send --app-name Gamma -u low "🌖 Gamma ↑" "Incrementada"
        ;;

    gamma-down)
        hyprctl hyprsunset gamma -10
        notify-send --app-name Gamma -u low "🌘 Gamma ↓" "Reducida"
        ;;

    temp-normal)
        hyprctl hyprsunset identity
        notify-send --app-name Hyprsunset -u low "🌕 Temperatura" "Normal"
        ;;

    temp-warm)
        hyprctl hyprsunset temperature 4500
        notify-send --app-name Hyprsunset -u low "🌑 Temperatura" "Modo Cálido"
        ;;

    media-plpa)
        playerctl play-pause
        status=$(playerctl status)
        notify-send --app-name Multimedia -u low "⏯️ Reproducción" "$status"
        ;;

    media-stop)
        playerctl stop
        notify-send --app-name Multimedia -u low "⏹️ Reproducción" "Stop"
        ;;

    media-prev)
        playerctl previous
        notify-send --app-name Multimedia -u low "⏮️ Reproducción" "Anterior pista"
        ;;

    media-next)
        playerctl next
        notify-send --app-name Multimedia -u low "⏭️ Reproducción" "Siguiente pista"
        ;;

    screenshot-window)
        hyprshot -m window -o ~/Imágenes/"Capturas de pantalla" -f "Captura_de_Ventana_$(date +%F_%H-%M-%S).png"
        ;;

    screenshot-screen)
        hyprshot -m output -o ~/Imágenes/"Capturas de pantalla" -f "Captura_de_Pantalla_$(date +%F_%H-%M-%S).png"
        ;;

    screenshot-region)
        hyprshot -m region -o ~/Imágenes/"Capturas de pantalla" -f "Captura_de_Región_$(date +%F_%H-%M-%S).png"
        ;;

    *)
        echo "Uso: $0 {volume-up|volume-down|volume-mute|mic-mute|brightness-up|brightness-down|gamma-up|gamma-down|temp-normal|temp-warm|media-play-pause|media-stop|media-prev|media-next|screenshot-window|screenshot-screen|screenshot-region}"
        exit 1
        ;;
esac
