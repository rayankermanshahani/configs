#!/bin/zsh

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# copy neovim config
cp ~/.config/nvim/init.lua ./dots/init.lua 
echo "copied neovim config"
#
# copy tmux config
cp ~/.tmux.conf ./dots/.tmux.conf 
echo "copied tmux config"

# Check the OS and run the appropriate package dump script
if command_exists brew; then
    ./macos_dump.sh
elif command_exists pacman; then
    ./arch_dump.sh
else
    echo "unsupported os: package dump skipped."
fi

echo "dumps complete."
