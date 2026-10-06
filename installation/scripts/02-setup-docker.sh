#!/bin/sh

# Start and enable service
# Add user to docker group

# Start the service
sudo systemctl start docker.service
sudo systemctl enable docker.service

# Add user to docker group
sudo usermod -aG docker $USER
