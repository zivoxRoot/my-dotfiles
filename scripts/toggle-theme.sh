#!/bin/sh

THEME_CACHE="$HOME/.cache/current-theme.txt"
WALLPAPER_CACHE="$HOME/.cache/current_wallpaper/current.jpg"

# Create file if don't exist
if [[ ! -f "$THEME_CACHE" ]]; then
	NEW_THEME="dark"
else
	# Get new theme
	CURRENT_THEME=$(cat "$THEME_CACHE")

	if [[ "$CURRENT_THEME" == "dark" ]]; then
		NEW_THEME="light"
		gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
		gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
	else
		NEW_THEME="dark"
		gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
		gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
	fi
fi

# Write new theme to cache
echo "$NEW_THEME" > "$THEME_CACHE"

# Launch matugen to change to the new theme
matugen --mode "$NEW_THEME" --type scheme-fruit-salad --source-color-index 0 image "$WALLPAPER_CACHE"
