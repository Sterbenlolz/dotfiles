#!/bin/bash

# Define the wallpaper directory
WALLPAPER_DIR="$HOME/.config/wallpapers"

# Check if the directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Error: Directory $WALLPAPER_DIR does not exist."
    exit 1
fi

# Check if wallust is installed
if ! command -v wallust &> /dev/null; then
    echo "Error: wallust is not installed."
    exit 1
fi

# Find all files recursively and run wallust on each
find "$WALLPAPER_DIR" -type f | while read -r file; do
    echo "Processing: $file"
    wallust run "$file"
done

echo "All wallpapers processed."
