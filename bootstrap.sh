#!/bin/bash

set -e

# Always work relative to the bootstrap.sh's location
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "🚀 [1/11] Starting full system bootstrap..."

# --------------------------
# Install system dependencies
# --------------------------
echo "📦 [2/11] Installing required packages..."
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
echo "🐚 [3/11] Setting ZSH as default shell (if needed)..."
if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)"
fi

# --------------------------
# Install Neovim AppImage (latest)
# --------------------------
echo "📥 [4/11] Checking Neovim installation..."
if ! command -v nvim &> /dev/null; then
  echo "📥 Installing Neovim AppImage..."
  mkdir -p ~/.local/bin
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o ~/.local/bin/nvim
  chmod +x ~/.local/bin/nvim
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
  export PATH="$HOME/.local/bin:$PATH"
else
  echo "✅ Neovim already installed."
fi

# --------------------------
# Install Oh My Zsh (if not already installed)
# --------------------------
echo "🧙 [5/11] Checking Oh My Zsh installation..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "🧙 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "✅ Oh My Zsh already installed."
fi

# --------------------------
# Install Starship prompt
# --------------------------
echo "🚀 [6/11] Checking Starship prompt installation..."
if ! command -v starship &> /dev/null; then
  echo "🚀 Installing Starship prompt..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
else
  echo "✅ Starship already installed."
fi

# --------------------------
# Install zsh plugins (autosuggestions + syntax highlighting)
# --------------------------
echo "🔌 [7/11] Installing ZSH plugins..."
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# Autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "✨ Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  echo "✅ zsh-autosuggestions already installed."
fi

# Syntax Highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "🎨 Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
  echo "✅ zsh-syntax-highlighting already installed."
fi

# --------------------------
# Install Nerd Fonts from dotfiles/fonts
# --------------------------
echo "🎨 [8/11] Installing Nerd Font(s)..."
mkdir -p ~/.local/share/fonts
cp -f "$SCRIPT_DIR/fonts/"*.TTF ~/.local/share/fonts/
fc-cache -fv > /dev/null
echo "✅ Fonts installed and cache updated."

# --------------------------
# Run install.sh for symlinks
# --------------------------
echo "🔗 [9/11] Linking dotfiles..."
"$SCRIPT_DIR/install.sh"

# --------------------------
# Restore Tilix layout
# --------------------------
echo "🖥️ [10/11] Restoring Tilix layout..."
if [ -f "$SCRIPT_DIR/tilix/tilix.dconf" ]; then
  dconf load /com/gexperts/Tilix/ < "$SCRIPT_DIR/tilix/tilix.dconf" 2>&1 | tee -a "$SCRIPT_DIR/tilix_restore.log"
  echo "✅ Tilix layout restored."
else
  echo "⚠️  No Tilix config found, skipping Tilix restore."
fi

# --------------------------
# Finish and refresh terminal
# --------------------------
echo "🎉 [11/11] Bootstrap complete! Refreshing terminal session..."

# Check if inside Tilix
if [ "$TILIX_ID" ]; then
  echo "✅ Inside Tilix. Reloading ZSH..."
  exec zsh
else
  echo "🚀 Not inside Tilix. Launching Tilix and exiting..."
  tilix &
  disown
  exit
fi

