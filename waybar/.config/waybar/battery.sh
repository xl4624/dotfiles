#!/bin/bash

# Get the battery percentage
BATTERY_PERCENT=$(cat /sys/class/power_supply/BAT0/capacity)
BATTERY_STATUS=$(cat /sys/class/power_supply/BAT0/status)

# Check if battery percentage is below 15% and if the battery is discharging
if [ "$BATTERY_PERCENT" -lt 15 ] && [ "$BATTERY_STATUS" = "Discharging" ]; then
    # Send a notification with Dunst
    dunstify -u critical "Battery Low" "Battery is at ${BATTERY_PERCENT}%!"
fi

