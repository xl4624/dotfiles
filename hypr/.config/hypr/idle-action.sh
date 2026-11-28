#!/bin/sh
# Run idle actions on battery and resume actions only when their matching
# idle action ran. Stamp files prevent brightnessctl -r from restoring stale
# levels after an idle action was skipped.
#
# Read the Mains supply directly: this machine's UCSI nodes report 5V even
# when their ports are not charging. If AC state is unavailable, assume
# battery power so the display can still be shut off.

set -eu

state_dir=${XDG_RUNTIME_DIR:-/tmp}/hypridle-actions
ac=/sys/class/power_supply/AC/online

usage() {
    printf 'usage: %s [--resume] <name> <command> [args...]\n' "${0##*/}" >&2
    exit 2
}

is_resume=0
if [ "${1-}" = "--resume" ]; then
    is_resume=1
    shift
fi

[ $# -ge 2 ] || usage

name=$1
shift

case $name in
    "" | . | .. | */*) usage ;;
esac

stamp=$state_dir/$name

if [ "$is_resume" -eq 1 ]; then
    [ -e "$stamp" ] || exit 0
    rm -f "$stamp"
    exec "$@"
fi

if [ -r "$ac" ] && read -r online < "$ac" && [ "$online" = "1" ]; then
    exit 0
fi

mkdir -p "$state_dir"
: > "$stamp"
exec "$@"
