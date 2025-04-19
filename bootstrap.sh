#!/bin/bash

set -e

echo "🚀 Starting full system bootstrap..."

# --------------------------
# Install system dependencies
# --------------------------
echo "📦 Installing required packages..."
sudo apt update && sudo apt install -y \
  zsh \
  curl \
  git \
  neovim \
  tilix \
  ripgrep \
  xclip \
  fonts-firacode \
  unzip \
  fd-find \
  dconf-cli

# --------------------------
# Set ZSH as the default shell
# --------------------------
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "🐚 Setting ZSH as default shell..."
  chsh -s $(which zsh)
fi

# --------------------------
# Install Neovim AppImage (latest)
# --------------------------
if ! command -v nvim &> /dev/null; then
  echo "📥 Installing Neovim AppImage..."
  mkdir -p ~/.local/bin
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o ~/.local/bin/nvim
  chmod +x ~/.local/bin/nvim
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
  export PATH="$HOME/.local/bin:$PATH"
fi

# --------------------------
# Install Oh My Zsh if not already installed
# --------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "🧙 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# --------------------------
# Run install.sh for symlinks
# --------------------------
echo "🔗 Running dotfile symlinking script..."
./install.sh

# --------------------------
# Restore Tilix layout
# --------------------------
if command -v dconf &> /dev/null && [ -f ./tilix/tilix.dconf ]; then
  echo "🖥️  Restoring Tilix layout..."
  dconf load /com/gexperts/Tilix/ < ./tilix/tilix.dconf
fi

echo "✅ Bootstrap complete! You may want to reboot or log out and back in."

