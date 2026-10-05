#!/bin/sh

# Create the ~/.gitconfig file with the user's username and email
# It first prompts the user to enter his username and email used on github, then create a simple ~/.gitconfig file

# Prompt the user
read -p "Enter your Github's username: " username
read -p "Enter your Github's email: " email

# Write informations to ~/.gitconfig
cat <<EOF > "$HOME/.gitconfig"
[user]
	name = $username
	email = $email
EOF
