#!/bin/sh

# Hide unwanted desktop apps (all installed by default)
mkdir -p ~/.local/share/applications
for f in /usr/share/applications/*.desktop; do
  out=~/.local/share/applications/$(basename "$f")
  [ -e "$out" ] && continue   # don't clobber existing user overrides
  sed -e '/^NoDisplay=/d' \
      -e '/^\[Desktop Entry\]/a NoDisplay=true' "$f" > "$out"
done
rm -rf ~/.cache/rofi*

# Install pacman packages
sudo pacman -S --needed --noconfirm - < ../packages/packages.txt

# Install paru
git clone --depth=1 https://aur.archlinux.org/paru.git "$HOME/paru"
cd "$HOME/paru"
makepkg -si
cd $HOME # Clean files
rm -rf paru

# Install AUR packages with paru
paru -S --needed --noconfirm - < ../packages/aur.txt

# Copy configuration files to their destination
for CONFIG in ../config/*; do
	echo "Copying $(basename $CONFIG) configuration"
	if [[ -d "$HOME/.config/$(basename $CONFIG)" ]]; then
		echo "Folder for $(basename $CONFIG) already exists, backing it up"
		mv "$HOME/.config/$(basename $CONFIG)" "$HOME/.config/$(basename $CONFIG).bak"
	fi
	cp -r "$CONFIG" "$HOME/.config/$(basename $CONFIG)"
done

# Calls subscripts to carry out the rest of the installation
for SCRIPT in ./scripts/*.sh; do
	echo -e "\n\n=== Running $(basename $SCRIPT) ===\n"
	"./$SCRIPT"
done

# Remove unwanted default apps (file manager)
sudo pacman -Rns dolphin

# Export vim as the user's default editor
echo "export EDITOR=vim" > "$HOME/.bashrc"

# Setup first wallpaper so awww picks it up on reboot
FIRST_WALLPAPER=$(find $HOME/Pictures/Wallpapers/ -type f -name "*.jpg" | head -1)
awww-daemon &
awww img "$FIRST_WALLPAPER"

# Cache wallpaper
cp "$FIRST_WALLPAPER" "$HOME/.cache/current_wallpaper/current.jpg"

# Cache theme file
echo "dark" > $HOME/.cache/current-theme.txt

# Create NEXT-STEPS.md
cat <<'EOF' > NEXT-STEPS.md
# Next steps

This file holds recommendations on the last manual steps to take to completely setup your machine.

## Telegram

Open telegram and connect your account
- Turn dark mode on
- Turn off spellchecker (Settings > Advanced > Use spell checker)
- Turn off sound on notification, and attention drawing to the window if necessary (Settings > Notification and sound)

## Librewolf

- Connect to your most used apps with your accounts (YouTube, ChatGPT, Infomaniak, Claude AI...)
- Turn on **open previous window and tabs** (Settings > Home and startup > Startup)
- Turn off Enable ResistFingerprinting (Settings > Privacy and security > Fingerprinting > Enable ResistFingerprinting)
- Set appearance to System (Settings > Appearance > Website appearance > System)

## Restore your files from USB
- Open the main menu and launch **Restore from USB**

## Sync laptop with phone
- Open `syncthing`'s web UI on laptop (localhost:8384)

## Register your fingerprints for sudo and login
- Open the main menu and launch **Register fingerprint**
EOF

# Prompt to reboot
echo -e "\n\nIt is strongly recommended to reboot now, so all services can properly start.\nRun `sudo reboot now`"
