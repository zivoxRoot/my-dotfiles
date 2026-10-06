#!/bin/sh

RESULT=$(echo -e " Apps\nChange wallpaper\nToggle theme\nEnroll fingerprint\nLock screen" | rofi -dmenu -i -matching fuzzy -p "> ")

case "$RESULT" in
	" Apps")
		rofi -show drun
		;;
	"Change wallpaper")
		"$HOME/my-dotfiles/scripts/change-wallpaper.sh"
		;;
	"Toggle theme")
		"$HOME/my-dotfiles/scripts/toggle-theme.sh"
		;;
	"Enroll fingerprint")
		"$HOME/my-dotfiles/scripts/enroll-fingerprint.sh"
		;;
	"Lock screen")
		hyprlock
		;;
esac
