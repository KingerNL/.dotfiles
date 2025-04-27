#!/bin/bash

set -e

# Always work relative to the bootstrap.sh's location
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# --------------------------
# Detect package manager
# --------------------------
if command -v apt &> /dev/null; then
  PM="apt"
elif command -v pacman &> /dev/null; then
  PM="pacman"
else
  echo "❌ Unsupported package manager. Exiting."
  exit 1
fi

echo "🚀 [1/12] Starting full system bootstrap for [$PM] system..."

# --------------------------
# Install system dependencies
# --------------------------
echo "📦 [2/12] Installing required packages..."

APT_PACKAGES=(
  zsh
  curl
  git
  neovim
  tilix
  ripgrep
  xclip
  fonts-firacode
  unzip
  fd-find
  dconf-cli
)

PACMAN_PACKAGES=(
  zsh
  curl
  git
  neovim
  tilix
  ripgrep
  xclip
  ttf-fira-code
  unzip
  fd
  dconf
)

if [ "$PM" = "apt" ]; then
  sudo apt update
  sudo apt install -y "${APT_PACKAGES[@]}"
elif [ "$PM" = "pacman" ]; then
  sudo pacman -Syu --noconfirm
  sudo pacman -S --noconfirm "${PACMAN_PACKAGES[@]}"
fi

# --------------------------
# Set ZSH as the default shell
# --------------------------
echo "🐚 [3/12] Setting ZSH as default shell (if needed)..."
if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)"
fi

# --------------------------
# Install Neovim AppImage (only for apt-based systems)
# --------------------------
echo "📥 [4/12] Checking Neovim installation..."
if ! command -v nvim &> /dev/null; then
  if [ "$PM" = "apt" ]; then
    echo "📥 Installing Neovim AppImage..."
    mkdir -p ~/.local/bin
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o ~/.local/bin/nvim
    chmod +x ~/.local/bin/nvim
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
    export PATH="$HOME/.local/bin:$PATH"
  else
    echo "✅ Neovim installed via pacman."
  fi
else
  echo "✅ Neovim already installed."
fi

# --------------------------
# Install Oh My Zsh (if not already installed)
# --------------------------
echo "🧙 [5/12] Checking Oh My Zsh installation..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "🧙 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "✅ Oh My Zsh already installed."
fi

# --------------------------
# Install Starship prompt
# --------------------------
echo "🚀 [6/12] Checking Starship prompt installation..."
if ! command -v starship &> /dev/null; then
  echo "🚀 Installing Starship prompt..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
else
  echo "✅ Starship already installed."
fi

# --------------------------
# Install zsh plugins (autosuggestions + syntax highlighting)
# --------------------------
echo "🔌 [7/12] Installing ZSH plugins..."
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "✨ Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  echo "✅ zsh-autosuggestions already installed."
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "🎨 Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
  echo "✅ zsh-syntax-highlighting already installed."
fi

# --------------------------
# Install Nerd Fonts from dotfiles/fonts
# --------------------------
echo "🎨 [8/12] Installing Nerd Font(s)..."
mkdir -p ~/.local/share/fonts
cp -f "$SCRIPT_DIR/fonts/"*.TTF ~/.local/share/fonts/
fc-cache -fv > /dev/null
echo "✅ Fonts installed and cache updated."

# --------------------------
# Run install.sh for symlinks
# --------------------------
echo "🔗 [9/12] Linking dotfiles..."
"$SCRIPT_DIR/install.sh"

# --------------------------
# Restore Tilix layout
# --------------------------
echo "🖥️ [10/12] Restoring Tilix layout..."
if [ -f "$SCRIPT_DIR/tilix/tilix.dconf" ]; then
  dconf load /com/gexperts/Tilix/ < "$SCRIPT_DIR/tilix/tilix.dconf" 2>&1 | tee -a "$SCRIPT_DIR/tilix_restore.log"
  echo "✅ Tilix layout restored."
else
  echo "⚠️  No Tilix config found, skipping Tilix restore."
fi

# --------------------------
# Clean up and refresh
# --------------------------
echo "🧹 [11/12] Cleaning up font cache again just in case..."
fc-cache -fv > /dev/null

# --------------------------
# Finish and refresh terminal
# --------------------------
echo "🎉 [12/12] Bootstrap complete! Refreshing terminal session..."

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

