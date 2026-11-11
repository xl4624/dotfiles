#!/bin/sh
# Usage: screenshot.sh <area|screen|output|active>
# Copies the capture to the clipboard and saves it to ~/Pictures.

case "$1" in
    area|screen|output|active) ;;
    *) echo "usage: $0 <area|screen|output|active>" >&2; exit 2 ;;
esac

# GRIMBLAST_HIDE_CURSOR skips grimblast's cursor-park hack, which creates a
# temporary headless output via hyprctl and segfaults Hyprland if a workspace
# switch races with it
GRIMBLAST_HIDE_CURSOR=1 exec grimblast --notify --freeze copysave "$1" "$HOME/Pictures/$(date -Is).png"
