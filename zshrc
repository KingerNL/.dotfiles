# Theme
ZSH_THEME=""

# Add local binaries (e.g. Neovim AppImage)
export PATH="$HOME/.local/bin:$PATH"

# Oh My Zsh (fixes sourcing issue)
DISABLE_MAGIC_FUNCTIONS=true
export ZSH="$HOME/.oh-my-zsh"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# Starship prompt
eval "$(starship init zsh)"

# conda add to path
# export PATH="$HOME/miniconda3/bin:$PATH"  # commented out by conda initialize

# export to path for ardupilot
export PATH="$HOME/ardupilot/Tools/autotest:$PATH"

# Node Version Manager (nvm)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Load nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Load nvm completion

