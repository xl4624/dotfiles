#!/bin/sh
# Pick a clipboard entry, copy it, and paste into the previously focused window.

set -eu

target=$(hyprctl activewindow -j | jq -r '.address // ""')

selection=$(
    cliphist list | rofi -dmenu -i -p "clipboard" \
        -display-columns 2 -display-column-separator '\t' \
        -kb-custom-1 '' -kb-custom-2 '' -kb-custom-3 '' -kb-custom-4 '' \
        -kb-custom-5 '' -kb-custom-6 '' -kb-custom-7 '' -kb-custom-8 '' \
        -kb-custom-9 '' \
        -kb-select-1 'Alt+1' -kb-select-2 'Alt+2' -kb-select-3 'Alt+3' \
        -kb-select-4 'Alt+4' -kb-select-5 'Alt+5' -kb-select-6 'Alt+6' \
        -kb-select-7 'Alt+7' -kb-select-8 'Alt+8' -kb-select-9 'Alt+9'
) || exit 0

[ -n "$selection" ] || exit 0

case "$selection" in
    *"[[ binary data "*)
        printf '%s' "$selection" | cliphist decode | wl-copy
        ;;
    *)
        printf '%s' "$selection" | cliphist decode | wl-copy --type 'text/plain;charset=utf-8'
        ;;
esac

[ -n "$target" ] || exit 0

hyprctl dispatch "hl.dsp.send_shortcut({ mods = 'SHIFT', key = 'Insert', window = 'address:$target' })" \
    >/dev/null
