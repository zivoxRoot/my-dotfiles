#!/bin/sh

# Update packages
echo -e "\n\n=======================\n=== Updating packages\n=======================\n"
sudo pacman -Syu

# Hide unwanted desktop apps (all installed by default)
echo -e "\n\n=======================\n=== Hiding unwanted desktop apps\n=======================\n"
mkdir -p ~/.local/share/applications
for f in /usr/share/applications/*.desktop; do
  out=~/.local/share/applications/$(basename "$f")
  [ -e "$out" ] && continue   # don't clobber existing user overrides
  sed -e '/^NoDisplay=/d' \
      -e '/^\[Desktop Entry\]/a NoDisplay=true' "$f" > "$out"
done
rm -rf ~/.cache/rofi*

# Install pacman packages
echo -e "\n\n=======================\n=== Installing pacman packages\n=======================\n"
sudo pacman -S --needed - < ../packages/packages.txt

# Install paru
echo -e "\n\n=======================\n=== Installing paru\n=======================\n"
git clone --depth=1 https://aur.archlinux.org/paru.git "$HOME/paru"
cd "$HOME/paru"
makepkg -si
cd -
rm -rf "$HOME/paru"  # Clean files

# Install AUR packages with paru
echo -e "\n\n=======================\n=== Installing AUR packages with paru\n=======================\n"
paru -S --needed - < ../packages/aur.txt

# Copy configuration files to their destination
echo -e "\n\n=======================\n=== Copying config file to their destination\n=======================\n"
mkdir -p "$HOME/.config"
for CONFIG in ../config/*; do
	echo "Copying $(basename $CONFIG) configuration"
	if [[ -d "$HOME/.config/$(basename $CONFIG)" ]]; then
		echo "Folder for $(basename $CONFIG) already exists, backing it up"
		mv "$HOME/.config/$(basename $CONFIG)" "$HOME/.config/$(basename $CONFIG).bak"
	fi
	cp -r "$CONFIG" "$HOME/.config/$(basename $CONFIG)"
done

# Calls subscripts to carry out the rest of the installation
echo -e "\n\n=======================\n=== Calling subscripts to carry out the installation\n=======================\n"
for SCRIPT in ./scripts/*.sh; do
	echo -e "\n\n=== Running $(basename $SCRIPT) ===\n"
	"./$SCRIPT"
done

# Remove unwanted default apps (file manager)
echo -e "\n\n=======================\n=== Removing unwanted default apps\n=======================\n"
sudo pacman -Rns dolphin

# Export vim as the user's default editor
echo "export EDITOR=vim" >> "$HOME/.bashrc"

# Install wallpapers
mkdir -p "$HOME/Pictures"
cp -r ../wallpapers "$HOME/Pictures/Wallpapers"

# Setup first wallpaper so awww picks it up on reboot
FIRST_WALLPAPER=$(find $HOME/Pictures/Wallpapers/ -type f -name "*.jpg" | head -1)
awww-daemon >/dev/null 2>&1 & sleep 1
awww img "$FIRST_WALLPAPER"

# Run matugen once to generate colors
matugen --mode dark --type scheme-fruit-salad --source-color-index 0 image "$FIRST_WALLPAPER"

# Cache wallpaper
mkdir -p "$HOME/.cache/current_wallpaper/"
cp "$FIRST_WALLPAPER" "$HOME/.cache/current_wallpaper/current.jpg"

# Cache theme file
echo "dark" > $HOME/.cache/current-theme.txt

# Create NEXT-STEPS.md
cat <<'EOF' > $HOME/NEXT-STEPS.md
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
echo -e "\n\nIt is strongly recommended to reboot now, so all services can properly start.\nRun 'sudo reboot now'"
