source /etc/zshrc

export PATH="/opt/homebrew/bin:$PATH"

export PATH="\
${ASDF_DATA_DIR:-$HOME/.asdf}/shims\
:$HOME/.local/bin\
:$HOME/go/bin\
:$(brew --prefix)/opt/riscv-gnu-toolchain/bin\
:$HOME/Library/Application Support/texbld/bin\
:$PATH"

setopt autocd

# worksapces variable for tmuxs to read in
export WORKSPACES="\
$HOME/Documents/prog:\
$HOME/Documents/repos:\
$HOME/Documents/work:\
$HOME/Documents/classes:\
$HOME/mit/s3:\
$HOME/.config/nvim:\
$HOME/.config/borders:\
$HOME/.config/aerospace:\
$HOME/.config/alacritty:\
"

# =============================================
# vi mode bullshit

export ZVM_CURSOR_STYLE_ENABLED=false

zvm_after_init() {
  bindkey -M viins '^A' undefined-key
  bindkey -M viins '^E' undefined-key
  bindkey -M viins '^B' undefined-key
  bindkey -M viins '^F' undefined-key
  bindkey -M viins '^K' undefined-key
  bindkey -M viins '^W' undefined-key
  bindkey -M viins '^U' undefined-key
  bindkey -M viins '^Y' undefined-key
  bindkey -M viins '^_' undefined-key

  bindkey -s '^F' 'tmuxs -d 3\n'
}

# =============================================
# Random Convenient Configurations

if [[ "$(command -v nvim)" ]]; then
    export EDITOR='nvim'
    export MANPAGER='nvim +Man!'
    export MANWIDTH=999
fi

# =============================================
# Juni's Aliases

alias ls='ls -G'
alias c='clear'
alias s='ls'
alias e='exit'

alias v='nvim'
alias vc='nvim ~/.config/nvim'
alias vz='nvim ~/.zshrc'

alias b='brew'

alias g='git'
alias gac='git add . && git commit'
alias gp='git push'
alias gr='git remote'
alias gb='git branch'

alias sz='source ~/.zshrc'
alias lpp='latexmk -pdf -pvc'
alias cp='cp -r'

mkcd() {
  mkdir -p "$1" && cd "$1"
}

z() {
  zathura --fork "$@" > /dev/null 2>&1
}

# =============================================
# Additional zsh configuration

# completion paths
fpath=(
  "${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
  "$(brew --prefix)/share/zsh/site-functions"
  $fpath
)
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select=2

# pure prompt (Install via homebrew)
autoload -U promptinit; promptinit
prompt pure

source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
