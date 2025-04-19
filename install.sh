#!/bin/bash

echo "🔗 Linking dotfiles..."

ln -sf ~/.dotfiles/zshrc ~/.zshrc
ln -sf ~/.dotfiles/starship/starship.toml ~/.config/starship.toml
rm -rf ~/.config/nvim
ln -sf ~/.dotfiles/nvim ~/.config/nvim

echo "✅ Dotfiles linked!"

