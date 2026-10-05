#!/bin/sh

# Start the syncthing service

# Dependency: syncthing

sudo systemctl enable --now syncthing@$USER.service
