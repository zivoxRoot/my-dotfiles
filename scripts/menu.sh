#!/bin/sh

RESULT=$(echo -e "action > Open apps\nvisual > Change wallpaper\nvisual > Toggle theme\nsystem > Enroll fingerprint\nbackup > Backup to PI\naction > Lock screen" | rofi -dmenu -i -matching fuzzy -p "> ")

case "$RESULT" in
	"action > Open apps")
		rofi -show drun
		;;
	"visual > Change wallpaper")
		"$HOME/my-dotfiles/scripts/change-wallpaper.sh"
		;;
	"visual > Toggle theme")
		"$HOME/my-dotfiles/scripts/toggle-theme.sh"
		;;
	"system > Enroll fingerprint")
		"$HOME/my-dotfiles/scripts/enroll-fingerprint.sh"
		;;
	"backup > Backup to PI")
		"$HOME/my-dotfiles/scripts/backup-to-server.sh"
		;;
	"action > Lock screen")
		hyprlock
		;;
esac
