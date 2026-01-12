#!/usr/bin/env bash

# Use absolute paths for critical components
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"

# Set wallpaper directory
WALLPAPER_DIR="$HOME/.config/wallpapers"

# Get current wallpapers if hyprpaper is running
CURRENT_WALLS=""
if pgrep hyprpaper >/dev/null; then
    CURRENT_WALLS=$(hyprctl hyprpaper listloaded 2>/dev/null | awk -F/ '{print $NF}')
fi

# Get a random wallpaper that is not the current one
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | \
                grep -v -f <(echo "$CURRENT_WALLS" | sed 's/.*/&$/') | \
                shuf -n 1)

# Exit if no wallpaper found
if [[ -z "$WALLPAPER" ]]; then
    echo "No new wallpapers found in $WALLPAPER_DIR" >&2
    exit 1
fi

sleep 0.5

# Apply colors using wallust
wallust run -qw "$WALLPAPER"

# Preload and set wallpaper
hyprctl hyprpaper preload "$WALLPAPER"

# Get monitors after Hyprland has fully initialized
MONITORS=$(hyprctl monitors -j | jq -r '.[].name')
if [[ -z "$MONITORS" ]]; then
    # If no monitors detected, try again after delay
    MONITORS=$(hyprctl monitors -j | jq -r '.[].name')
fi

for MONITOR in $MONITORS; do
    echo "Changing wallpaper for monitor: $MONITOR"
    hyprctl hyprpaper wallpaper "$MONITOR,$WALLPAPER"
done

# Create symlink to current wallpaper
ln -sf "$(hyprctl hyprpaper listactive | head -n1 | awk '{print $3}')" "$HOME/.cache/current-wallpaper"

# Restart waybar if it's running
if pgrep waybar >/dev/null; then
    killall waybar
fi
waybar >/dev/null 2>&1 &

# Restart swaync if it's running
if pgrep swaync >/dev/null; then
    swaync-client -rs
fi
