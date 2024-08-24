#!/bin/zsh

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if brew exists
if ! command_exists brew; then
    echo "Error: brew not found. This script is for macOS systems with Homebrew installed."
    exit 1
fi

# Create brew directory if it doesn't exist
mkdir -p ./brew

# Dump brew leaves and casks
brew leaves > ./brew/my_leaves
brew list --casks > ./brew/my_casks

echo "macOS package dump completed successfully!"
