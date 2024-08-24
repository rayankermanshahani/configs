#!/bin/zsh

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Run config dump script
./config_dump.sh

# Check the OS and run the appropriate package dump script
if command_exists brew; then
    ./macos_dump.sh
elif command_exists pacman; then
    ./arch_dump.sh
else
    echo "Unsupported operating system. Package dump skipped."
fi

echo "All dump operations completed!"
