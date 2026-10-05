#!/bin/sh

# Install docker and start service
# Add user to docker group

# Install packages
paru -S --noconfirm --needed docker docker-compose

# Start the service
sudo systemctl start docker.service
sudo systemctl enable docker.service

# Add user to docker group
sudo usermod -aG docker $USER
