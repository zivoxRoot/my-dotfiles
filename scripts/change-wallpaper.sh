#!/bin/sh

THEME_CACHE="$HOME/.cache/current-theme.txt"
WALLPAPER_CACHE="$HOME/.cache/current_wallpaper/current.jpg"

# CHOICE=$(find "$HOME/Pictures/Wallpapers/" -type f -name "*.jpg" | xargs basename | rofi -dmenu)
CHOICE=$(find "$HOME/Pictures/Wallpapers/" -type f -name "*.jpg" | rofi -dmenu)

# Get theme
THEME=$(cat "$THEME_CACHE")

# Change wallpaper
awww img --transition-type wave --transition-wave 50,50 "$CHOICE"

# Change theme
matugen --mode "$THEME" --type scheme-fruit-salad --source-color-index 0 image "$CHOICE"

# Cache the wallpaper for the lockscreen to use and switch between light/dark theme
mkdir -p $HOME/.cache/current_wallpaper/
cp "$CHOICE" "$WALLPAPER_CACHE"
