# 🧠 Murt's Dotfiles — Neovim + Zsh + Starship + Tilix Dev Environment

Welcome to my personal dev environment setup!  
This repository contains all the key configuration files I use to create a powerful and portable terminal-based coding experience on Ubuntu 22.04.

---

## 🧰 What’s Included

- **Neovim 0.11+** with:
  - `coc.nvim` (LSP, autocomplete)
  - `copilot.vim` (AI completions)
  - `nvim-tree` (file explorer)
  - `dropbar.nvim` (breadcrumb navigation)
  - `treesitter` (syntax-aware highlighting)
  - Gruvbox theme + icons
- **ZSH** with:
  - Oh My Zsh
  - Starship prompt
  - Autocompletion and syntax highlighting
- **Tilix** terminal configuration

---

## 🚀 Quickstart (New Machine Setup)

### 1. Clone this repository

```bash
git clone https://github.com/<your-username>/dotfiles ~/.dotfiles
cd ~/.dotfiles
```

> 🗁 Replace `<your-username>` with your actual GitHub username.

---

### 2. Run the install script

```bash
./install.sh
```

This will:
- Symlink your Neovim, Zsh, and Starship configs
- Restore your Tilix layout (if `dconf` is installed)

---

### 3. Install required packages

> ⚠️ Run these manually or include them in a future setup script:

```bash
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
  fd-find
```

---

### 4. Install Neovim (AppImage version)

If Neovim isn't already installed or if the version is too old:

```bash
mkdir -p ~/.local/bin
cd ~/.local/bin
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod +x nvim.appimage
mv nvim.appimage nvim
```

Ensure `~/.local/bin` is in your `$PATH` (already handled in `.zshrc`).

---

### 5. Set ZSH as default shell

```bash
chsh -s $(which zsh)
```

Then reboot or log out and back in.

---

### 6. Install Oh My Zsh (if not already installed)

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

---

### 7. Launch Neovim and install plugins

```bash
nvim
```

Then run inside Neovim:

```
:PlugInstall
```

After plugins are installed, run:

```
:TSInstall python
:TSUpdate
```

---

### 8. (Optional) Restore Tilix layout

```bash
dconf load /com/gexperts/Tilix/ < ~/.dotfiles/tilix/tilix.dconf
```

---

## 📝 Notes

- Copilot requires a GitHub account and subscription
- You may want to install Nerd Fonts for icons (e.g., FiraCode Nerd Font)
- Fonts can be placed in `~/.local/share/fonts` and refreshed with:
  ```bash
  fc-cache -fv
  ```

---

## 📦 Future Improvements

- Add `bootstrap.sh` to automate all steps
- Store fonts and other assets in the repo
- Add GitHub CLI/GPG keys setup
- Make custom Ubuntu ISO for full offline recovery

---

## 💬 Questions?

Hit up your future self:
```bash
# look at .zshrc
less ~/.zshrc

# revisit the README
cat ~/.dotfiles/README.md
```

---

## 🧠 Philosophy

This setup is about speed, focus, keyboard-first editing, and long-term portability.  
Forget VSCode — this is **terminal-native deep work**.

---
