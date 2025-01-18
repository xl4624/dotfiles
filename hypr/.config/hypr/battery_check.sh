#!/bin/sh

while true; do
    battery=$(upower -i "$(upower -e | grep BAT)" | grep -E "percentage" | awk '{print $2}' | tr -d '%')
    charging_status=$(upower -i "$(upower -e | grep BAT)" | grep -E "state" | awk '{print $2}')
    if [ "$charging_status" = "discharging" ]; then
        if [ "$battery" -le "20" ]; then
            notify-send -u critical "Low battery" "Battery level at ${battery}%"
            sleep 240
        else
            sleep 120
        fi
    fi
done
