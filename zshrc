# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/bin:$PATH"

ZSH_THEME="agnosterzak"

plugins=( 
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Alias to open ROS environment in singularity container
alias roslab='singularity shell ~/tudelft_coursework/robot_software_practicals/ro47003_humble_v8.sif'


# Display Pokemon-colorscripts
POKE_DIR="$HOME/.dotfiles/pokemon_ascii"
POKE_PICK=$(find "$POKE_DIR" -type f | shuf -n 1)

cat "$POKE_PICK" | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc \
    --logo-type file-raw --logo-height 10 --logo-width 5 --logo -


# Set-up icons for files/directories in terminal using lsd
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# Starship prompt
eval "$(starship init zsh)"

# Lazy-load nvm only when a Node command is run
autoload -U add-zsh-hook

load-nvm() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
  unfunction load-nvm
}

add-zsh-hook -Uz preexec load-nvm

# >>> conda initialize >>>
__conda_setup="$('$HOME/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Pyenv configuration
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Initialize pyenv
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# --- Enable local X11 display access for Singularity and ROS GUI apps ---
if command -v xhost >/dev/null 2>&1; then
    xhost +local:root > /dev/null 2>&1
fi

