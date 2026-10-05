#!/bin/sh

# Install necessary packages and start services

sudo pacman -S --noconfirm --needed pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber alsa-utils
systemctl --user enable --now pipewire pipewire-pulse wireplumber
