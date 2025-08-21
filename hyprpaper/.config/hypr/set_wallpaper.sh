#!/bin/env bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/.config/backgrounds/"

# Get list of wallpapers
WALLPAPERS=($(find "$WALLPAPER_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \)))
WALLPAPER_COUNT=${#WALLPAPERS[@]}

# Exit if no wallpapers found
if [ $WALLPAPER_COUNT -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Select a random wallpaper
RANDOM_INDEX=$(( RANDOM % WALLPAPER_COUNT ))
CURRENT_WALLPAPER="${WALLPAPERS[$RANDOM_INDEX]}"

# Get list of all monitors
MONITORS=($(hyprctl monitors | grep -oP 'Monitor \K[^ ]+' | sort -u))

# Apply the same random wallpaper to all monitors
for MONITOR in "${MONITORS[@]}"; do
    hyprctl hyprpaper wallpaper "$MONITOR,$CURRENT_WALLPAPER"
done
