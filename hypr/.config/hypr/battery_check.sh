#!/bin/sh

while true; do
    bat=$(upower -e | grep BAT)
    charging_status=$(upower -i "$bat" | awk '/state/{print $2}')
    if [ "$charging_status" = "discharging" ]; then
        battery=$(upower -i "$bat" | awk '/percentage/{gsub(/%/,"",$2); print $2}')
        if [ "$battery" -le "20" ]; then
            notify-send -u critical "Low battery" "Battery level at ${battery}%"
            sleep 300
        else
            sleep 120
        fi
    else
        sleep 120
    fi
done
