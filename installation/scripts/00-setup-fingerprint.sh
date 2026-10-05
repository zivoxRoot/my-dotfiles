#!/bin/sh

# Setup the fingerprint system so the user can enroll easily

# Dependency: python-validity (aur)

# Enable service
sudo systemctl enable --now python3-validity.service

# Add configuration to pam
for file in /etc/pam.d/login /etc/pam.d/sudo; do
    sudo sed -i '/^auth[[:space:]]\+sufficient[[:space:]]\+pam_fprintd\.so$/d' "$file"  # Remove line if already exists
    sudo sed -i '1i auth    sufficient    pam_fprintd.so' "$file"  # Add line
done
