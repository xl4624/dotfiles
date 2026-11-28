#!/bin/sh
# Waybar toggle that keeps the screen on and the lid from suspending.
#
# Waybar's built-in idle_inhibitor only uses the Wayland idle-inhibit protocol,
# which does not stop logind from suspending on lid close. A logind inhibitor
# covers both: hypridle honors "idle" inhibitors, and logind honors
# "handle-lid-switch". The inhibitor lives as long as the transient user unit,
# so state survives a waybar restart.
#
#   caffeine.sh status   print waybar JSON
#   caffeine.sh toggle   flip state

unit=caffeine-inhibit

active() { systemctl --user --quiet is-active "$unit.service"; }

case ${1:-status} in
toggle)
    if active; then
        systemctl --user stop "$unit.service"
    else
        systemd-run --user --quiet --unit="$unit" \
            systemd-inhibit --what=idle:handle-lid-switch --who=waybar \
            --why="Caffeine toggle" --mode=block sleep infinity
    fi
    ;;
status)
    if active; then
        printf '{"text":"\\udb80\\udd76","class":"activated","tooltip":"Screen stays on, lid close ignored"}\n'
    else
        printf '{"text":"\\udb81\\udeca","class":"deactivated","tooltip":"Screen will sleep, lid close suspends"}\n'
    fi
    ;;
esac
