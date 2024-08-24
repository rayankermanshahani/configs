#!/bin/zsh

# Create dots directory if it doesn't exist
mkdir -p ./dots

# Copy config files
cp ~/.vimrc ./dots/.vimrc
cp ~/.config/nvim/init.lua ./dots/init.lua
cp ~/.zshrc ./dots/.zshrc
cp ~/.tmux.conf ./dots/.tmux.conf
cp ~/.clang-format ./dots/.clang-format

echo "Config files dump completed successfully!"
