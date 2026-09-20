#!/bin/sh
# Suspend on idle, but only when running on battery.
#
# hypridle has no conditional listeners, so the AC check lives here.
# On AC the screen still locks and blanks (earlier listeners); it just
# does not suspend.

ac=/sys/class/power_supply/AC/online

if [ -r "$ac" ] && [ "$(cat "$ac")" = "1" ]; then
    exit 0
fi

systemctl suspend
