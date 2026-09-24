#!/bin/sh
# Gate hypridle's idle actions on AC state.
#
# hypridle listeners fire unconditionally, but on mains power an idle laptop
# should keep its backlight, its session and its lock state alone. Each idle
# listener therefore calls
#
#     idle-action.sh <name> <command> [args...]
#
# which runs the command only while on battery and records that it did so in
# a stamp file. The paired on-resume command calls
#
#     idle-action.sh --resume <name> <command> [args...]
#
# which runs only if the matching idle action actually ran. Without that
# pairing a resume would undo something that never happened -- notably
# `brightnessctl -r`, which would restore a backlight level saved hours ago.
#
# AC state comes from the Mains supply only. The ucsi-source-psy-* nodes are
# ignored on purpose: they report a fixed 5V on this machine and cannot tell
# a live charging port from an idle one. If the node is missing or unreadable
# we act anyway -- draining the battery is the worse failure.

set -eu

state_dir=${XDG_RUNTIME_DIR:-/tmp}/hypridle-actions
ac=/sys/class/power_supply/AC/online

usage() {
    echo "usage: ${0##*/} [--resume] <name> <command> [args...]" >&2
    exit 2
}

resume=0
if [ "${1-}" = "--resume" ]; then
    resume=1
    shift
fi

[ $# -ge 2 ] || usage

name=$1
shift

# The name becomes a file name, so it must be a single harmless path component.
case $name in
    "" | . | .. | */*) usage ;;
esac

stamp=$state_dir/$name

if [ "$resume" -eq 1 ]; then
    [ -e "$stamp" ] || exit 0
    rm -f "$stamp"
    exec "$@"
fi

if [ -r "$ac" ] && [ "$(cat "$ac")" = "1" ]; then
    exit 0
fi

mkdir -p "$state_dir"
: > "$stamp"
exec "$@"
