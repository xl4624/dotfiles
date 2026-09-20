#!/bin/sh
# Clipboard history picker: pick an entry, then paste it into whichever window
# was focused when the picker opened.
#
# `cliphist list` emits "<id>\t<preview>". That id is a monotonically
# increasing counter, NOT a position -- it has gaps, and re-copying an old
# value retires its id and issues a new one. Showing it would only mislead, so
# -display-columns 2 hides it; rofi still returns the whole line, which is
# what `cliphist decode` needs to resolve the entry.
#
# Alt+1..9 jump straight to the Nth row. Two rofi defaults are in the way:
# kb-select-N sits on Super+1..9 (which would collide with the workspace keys),
# and Alt+1..9 is already taken by kb-custom-1..10. So the custom bindings are
# cleared first, then kb-select-N is moved onto Alt+N. Without the unbind rofi
# refuses to start and reports "Binding already bound" in its own window --
# which is on screen, not on stderr.
#
# The target window is captured BEFORE rofi opens and the paste is addressed to
# it explicitly. Waiting for Hyprland to refocus after rofi exits would be a
# race, and a sleep long enough to paper over it would still be a race.

set -eu

# One jq pass, not two: each spawn costs ~6ms and this runs on every invocation.
eval "$(hyprctl activewindow -j | jq -r '@sh "target=\(.address // "") class=\(.class // "")"')"

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

# wl-copy sniffs the MIME type by shelling out to xdg-mime when none is given,
# which costs ~175ms -- about 25x the rest of the paste path combined. Text is
# the common case and its type is known, so declare it. Entries cliphist marked
# as binary keep the sniffing path, since their real type varies (png/jpeg/...)
# and correctness matters more than 175ms on the rare image paste.
case "$selection" in
    *"[[ binary data "*)
        printf '%s' "$selection" | cliphist decode | wl-copy
        ;;
    *)
        printf '%s' "$selection" | cliphist decode | wl-copy --type 'text/plain;charset=utf-8'
        ;;
esac

# Nothing was focused, or it vanished while rofi was open: leave the payload on
# the clipboard and let the user paste it wherever they land.
[ -n "$target" ] || exit 0

# Terminals paste with CTRL+SHIFT+V, everything else with CTRL+V. There is no
# way to ask an application which binding it uses, so this is a known-terminals
# list; extend it if a terminal pastes nothing or opens a menu instead.
case "$class" in
    kitty|foot|Alacritty|com.mitchellh.ghostty|org.wezfurlong.wezterm|WezTerm|st-256color|URxvt|XTerm)
        mods="CTRL SHIFT"
        ;;
    *)
        mods="CTRL"
        ;;
esac

# The selector must carry the "address:" prefix -- a bare 0x... address is
# rejected with "window not found".
hyprctl dispatch \
    "hl.dsp.send_shortcut({ mods = '$mods', key = 'V', window = 'address:$target' })" \
    >/dev/null
