# -----------------------------------
# Pyenv configuration (DISABLED for now)
# -----------------------------------
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# -----------------------------------
# Your custom config BELOW conda
# -----------------------------------

export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/bin:$PATH"

ZSH_THEME="agnosterzak"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

export STARSHIP_CONFIG=~/.config/starship/starship.toml
export TERM=xterm-kitty
export COLORTERM=truecolor
eval "$(starship init zsh)"

autoload -U add-zsh-hook
load-nvm() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
  unfunction load-nvm
}
add-zsh-hook -Uz preexec load-nvm

fastfetch --kitty ~/Pictures/Wallpapers/spiderman.png --logo-width 55 --color "#F74B36"

export PATH=$PATH:/home/murt/.spicetify

# opencode
export PATH=/home/murt/.opencode/bin:$PATH
