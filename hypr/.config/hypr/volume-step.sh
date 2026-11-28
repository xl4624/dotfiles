#!/usr/bin/env bash
# Step the default sink volume by one 5% tick, snapping to the 5% grid.
#
# Usage: volume-step.sh +|-
#
# Every invocation reads the current volume, rounds to the next 5% mark in
# the requested direction, clamps to [0%, 100%], and sets it.
#
# flock serializes concurrent presses. A timestamp throttle limits the
# effective repeat rate to ~10/sec without changing global keyboard repeat
# settings; Hyprland's repeating bind fires at repeat_rate (default 25/sec),
# so this avoids spawning processes that do nothing.

set -u

case "${1:-}" in
	+) step=5 ;;
	-) step=-5 ;;
	*)
		echo "usage: ${0##*/} +|-" >&2
		exit 2
		;;
esac

runtime=${XDG_RUNTIME_DIR:-/tmp}
state="$runtime/hypr-volume.last"
exec 9>"$runtime/hypr-volume.lock"
flock 9

now=${EPOCHREALTIME//[!0-9]/}
last=0
if [ -r "$state" ]; then
	read -r last <"$state" || last=0
	[[ $last =~ ^[0-9]+$ ]] || last=0
fi

if (( last > 0 && now - last < 100000 )); then
	exit 0
fi

read -r volume < <(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{ print $2 }')
if [ -z "${volume:-}" ]; then
	echo "${0##*/}: could not read default sink volume" >&2
	exit 1
fi

percent=$(awk -v v="$volume" 'BEGIN { printf "%d", v * 100 + 0.5 }')
target=$(( (percent + step + 2) / 5 * 5 ))

(( target < 0 )) && target=0
(( target > 100 )) && target=100

wpctl set-volume @DEFAULT_AUDIO_SINK@ "$(awk -v p="$target" 'BEGIN { printf "%.2f", p / 100 }')"

printf '%s\n' "$now" >"$state"
