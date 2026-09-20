#!/bin/sh
# Battery line for the hyprlock screen.
#
# Reads BAT0 directly rather than the UCSI power supplies: the UCSI
# nodes report a fixed 5V and cannot be used to tell charging from
# discharging on this machine.

bat=/sys/class/power_supply/BAT0

[ -r "$bat/capacity" ] || exit 0

capacity=$(cat "$bat/capacity")
status=$(cat "$bat/status")

case "$status" in
    Charging)                 icon="󰂄" ;;
    "Not charging"|Full)      icon="󰂏" ;;
    *)
        if   [ "$capacity" -ge 80 ]; then icon="󰁹"
        elif [ "$capacity" -ge 60 ]; then icon="󰂀"
        elif [ "$capacity" -ge 40 ]; then icon="󰁾"
        elif [ "$capacity" -ge 20 ]; then icon="󰁼"
        else                              icon="󰁺"
        fi
        ;;
esac

printf '%s  %s%%\n' "$icon" "$capacity"
