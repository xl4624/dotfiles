#!/bin/sh

# GRIMBLAST_HIDE_CURSOR skips grimblast's cursor-park hack, which creates a
# temporary headless output via hyprctl and segfaults Hyprland if a workspace
# switch races with it
GRIMBLAST_HIDE_CURSOR=1 grimblast --notify --freeze copysave area $HOME/Pictures/$(date -Is).png
