#!/bin/bash

volume=$(wpctl get-volume @DEFAULT_SINK@ | awk '{print $2}')

percent=$(echo "$volume * 100" | bc -l)
rounded=$(printf "%.0f\n" "$percent")
nearest5=$(( (rounded + 2) / 5 * 5 ))
echo ${nearest5}

# Cap at 150
if (( nearest5 > 150 )); then
    nearest5=150
fi

# Convert back to decimal for wpctl
newvol=$(echo "scale=2; $nearest5 / 100" | bc -l)

echo ${newvol}

# Set the volume
wpctl set-volume @DEFAULT_AUDIO_SINK@ "$newvol"
