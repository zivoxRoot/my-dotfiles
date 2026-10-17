#!/usr/bin/env bash

STATE="${XDG_STATE_HOME:-$HOME/.local/state}/backup-pi"

# already backed up today? stay quiet
[[ "$(cat "$STATE/last-success" 2>/dev/null)" == "$(date +%F)" ]] && exit 0

# dunstify -A blocks until the notification closes, then prints the action clicked
action=$(dunstify -u critical -h string:x-dunst-stack-tag:backup-pi \
  -A "default,Back up now" "Backup reminder" "Back up ~/backup to the Pi?")

[[ "$action" == "default" ]] && exec "/home/theophile/my-dotfiles/scripts/backup-to-server.sh" --notify
exit 0
