#!/bin/zsh

# check if a command exists 
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# create directories if they don't exist
mkdir -p ./brew
mkdir -p ./pacman
mkdir -p ./dots

# check if using macos (brew exists) or arch linux (pacman exists)
if command_exists brew; then
    echo "detected macOS environment"
    brew leaves > ./brew/my_leaves
    brew list --casks > ./brew/my_casks
elif command_exists pacman; then
    echo "detected arch linux environment"
    pacman -Qe > ./pacman/explicit_packages
    if command_exists yay; then
        yay -Qm > ./pacman/aur_packages
    else
        echo "yay not found, skipping AUR package list"
    fi
else
    echo "neither brew nor pacman found. unsupported environment."
    exit 1
fi

# copy config files (common for both envs)
cp ~/.vimrc ./dots/.vimrc
cp ~/.config/nvim/init.lua ./dots/init.lua
cp ~/.zshrc ./dots/.zshrc
cp ~/.tmux.conf ./dots/.tmux.conf
cp ~/.clang-format ./dots/.clang-format

echo "dump completed successfully."
