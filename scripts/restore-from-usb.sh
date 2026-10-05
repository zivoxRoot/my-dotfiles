#!/usr/bin/env bash

# Restore data on the usb device at $SOURCE into ~/backup.
# If the BACKUP directory already exists it warns the user and exits
# It then shows what operations will be done, before prompt for user approval.

# Dependency: rsync

TARGET="$HOME/backup/"
SOURCE="/mnt/usb/"
EXCLUDE="lost+found"

# Check dependency
if ! command -v rsync &>/dev/null; then
	echo "Error: missing dependency: rsync" >&2
	exit 1
fi

# TODO: verify USB path valididy

# Check TARGET doesn't already exist
if [[ -d "$TARGET" ]]; then
	echo "Target $TARGET already exists, exiting"
	exit 0
fi

mkdir -p "$TARGET"

# Preview changes that will be made
echo -e "The following changes will be made\n"
rsync -av --itemize-changes --dry-run --exclude "$EXCLUDE" "$SOURCE" "$TARGET"

# Ask confirmation before running the command
read -ep "\nContinue? [y/N] \n" -r

if [[ "$REPLY" =~ ^[Yy]$ ]]; then
	rsync -av --progress --exclude "$EXCLUDE" "$SOURCE" "$TARGET"
	echo -e "\nRestore complete"
else
	echo "Aborting..."
fi
