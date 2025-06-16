#!/usr/bin/env bash

WALLPAPER_DIR=~/.config/wallpapers/
# Get just the basename of the current wallpaper(s)
CURRENT_WALLS=$(hyprctl hyprpaper listloaded | awk -F/ '{print $NF}')

# Get a random wallpaper that is not the current one
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | \
                grep -v -f <(echo "$CURRENT_WALLS" | sed 's/.*/&$/') | \
                shuf -n 1)


# Get the name of the focused monitor with hyprctl
hyprctl hyprpaper preload "$WALLPAPER"
for FOCUSED_MONITOR in $(hyprctl monitors -j | jq -r '.[].name')
do
    echo "Changing wallpaper for monitor: $FOCUSED_MONITOR"
    
    
    if [[ -n "$WALLPAPER" ]]; then
        echo "Setting wallpaper: $WALLPAPER"
        hyprctl hyprpaper wallpaper "$FOCUSED_MONITOR,$WALLPAPER"
    else
        echo "No new wallpapers found in $WALLPAPER_DIR"
    fi
done

ln -sf $(hyprctl hyprpaper listactive | head -n1 | awk '{print $3}') ~/.cache/current-wallpaper

wallust run -qw "$WALLPAPER"

killall waybar

hyprctl reload

swaync-client -rs

waybar &

