#!/bin/sh

while true; do
    charging_status=$(upower -i "$(upower -e | grep BAT)" | grep -E "state" | awk '{print $2}')
    if [ "$charging_status" = "discharging" ]; then
        battery=$(upower -i "$(upower -e | grep BAT)" | grep -E "percentage" | awk '{print $2}' | tr -d '%')
        if [ "$battery" -le "20" ]; then
            notify-send -u critical "Low battery" "Battery level at ${battery}%"
            sleep 300
        else
            sleep 120
        fi
    fi
done
