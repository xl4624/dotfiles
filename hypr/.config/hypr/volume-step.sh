#!/usr/bin/env bash
# Step the default sink by one 5% tick, keeping the volume on the 5% grid.
#
# Usage: volume-step.sh +|-
#
# flock serializes presses so the snapping press cannot overwrite a relative
# step that ran while it was still reading.

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

# A gap longer than half a second means a new press, not a held key
if (( now - last > 500000 )); then
	read -r volume < <(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{ print $2 }')
	if [ -z "${volume:-}" ]; then
		echo "${0##*/}: could not read default sink volume" >&2
		exit 1
	fi

	percent=$(awk -v v="$volume" 'BEGIN { printf "%d", v * 100 + 0.5 }')
	target=$(( percent + step ))
	target=$(( (target + 2) / 5 * 5 ))

	(( target < 0 )) && target=0
	(( target > 100 )) && target=100

	wpctl set-volume @DEFAULT_AUDIO_SINK@ "$(awk -v p="$target" 'BEGIN { printf "%.2f", p / 100 }')" || exit 1
else
	if (( step > 0 )); then
		wpctl set-volume @DEFAULT_AUDIO_SINK@ "5%+" || exit 1
	else
		wpctl set-volume @DEFAULT_AUDIO_SINK@ "5%-" || exit 1
	fi
fi

printf '%s\n' "$now" >"$state"
