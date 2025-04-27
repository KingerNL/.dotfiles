#!/bin/bash

set -e

# Always work relative to the bootstrap.sh's location
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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
# Install Oh My Zsh (if not already installed)
# --------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "🧙 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "✅ Oh My Zsh already installed"
fi

# --------------------------
# Install Starship prompt
# --------------------------
if ! command -v starship &> /dev/null; then
  echo "🚀 Installing Starship prompt..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
else
  echo "✅ Starship already installed"
fi

# --------------------------
# Install zsh plugins (autosuggestions + syntax highlighting)
# --------------------------
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# Autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "✨ Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  echo "✅ zsh-autosuggestions already installed"
fi

# Syntax Highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "🎨 Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
  echo "✅ zsh-syntax-highlighting already installed"
fi

# --------------------------
# Install Nerd Fonts from dotfiles/fonts
# --------------------------
echo "🎨 Installing Nerd Font(s)..."
mkdir -p ~/.local/share/fonts
cp -f ./fonts/*.TTF ~/.local/share/fonts/
fc-cache -fv > /dev/null
echo "✅ Fonts installed and cache updated."

# --------------------------
# Run install.sh for symlinks
# --------------------------
echo "🔗 Linking dotfiles..."
./install.sh

# --------------------------
# Restore Tilix layout
# --------------------------
echo "🖥️  Restoring Tilix layout..."
dconf load /com/gexperts/Tilix/ < "$SCRIPT_DIR/tilix/tilix.dconf"

echo "✅ Bootstrap complete! Restart terminal or log out and back in to apply all changes."

