#!/bin/zsh

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if pacman exists
if ! command_exists pacman; then
    echo "Error: pacman not found. This script is for Arch Linux systems."
    exit 1
fi

# Create pacman directory if it doesn't exist
mkdir -p ./pacman

# Dump explicitly installed packages
pacman -Qe > ./pacman/explicit_packages

# Dump AUR packages if yay is installed
if command_exists yay; then
    yay -Qm > ./pacman/aur_packages
else
    echo "yay not found, skipping AUR package list"
fi

echo "Arch Linux package dump completed successfully!"

