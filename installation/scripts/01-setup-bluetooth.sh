#!/bin/sh

# Setup bluetooth
# Install necessary packages and run the service

sudo pacman -S --needed bluez bluez-utils
sudo systemctl enable --now bluetooth.service
