#!/usr/bin/env bash

# Backup ~/backup/* to a USB card at $TARGET using rsync.
# It first shows what operations will be done, then wait for user approval

# Dependencies: rsync

TARGET="/run/media/theophile/BACKUP/"
SOURCE="$HOME/backup/"

# Verify USB path valididy
mountpoint -q "$TARGET" || { echo "USB not mounted at $TARGET" >&2; exit 1; }

echo "The following changes will be made"
echo

rsync -av --itemize-changes --dry-run "$SOURCE" "$TARGET"

# Ask confirmation
echo
read -p "Continue? [y/N] " -r
echo

if [[ "$REPLY" =~ ^[Yy]$ ]]; then
	rsync -av --progress "$SOURCE" "$TARGET"
	echo
	echo "Backup complete"
else
	echo "Aborting..."
fi
