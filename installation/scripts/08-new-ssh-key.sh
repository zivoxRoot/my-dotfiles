#!/bin/sh

# Create a new SSH key that can be copied into Github to clone and push private repositories
# Read the user email from ~/.gitconfig, the script that sets it up must be run first

# Dependencies: openssh

# Check dependency
if ! command -v ssh >/dev/null 2>&1; then
	echo "Missing dependency: openssh, installing it"
	sudo pacman -S --needed openssh
fi

# Read email from ~/.gitconfig
EMAIL=$(cat "$HOME/.gitconfig" | grep "email" | awk '{print $3}')

# Create key
ssh-keygen -t ed25519 -C "$EMAIL"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Output it to the user
echo -e "\n=== Public key to copy to Github:"
cat ~/.ssh/id_ed25519.pub
