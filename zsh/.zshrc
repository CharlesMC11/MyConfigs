source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration" 2>/dev/null

# options ######################################################################

setopt AUTOCD
setopt CDABLE_VARS
setopt CHASE_DOTS
setopt PUSHD_IGNORE_DUPS

setopt AUTO_LIST

setopt BAD_PATTERN
setopt EXTENDED_GLOB
setopt GLOB_STAR_SHORT

setopt HIST_ALLOW_CLOBBER
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FCNTL_LOCK
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_NO_FUNCTIONS
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt SHARE_HISTORY

autoload -Uz compinit
compinit

# aliases ######################################################################

alias -g ...=../..
alias -g ....=../../..
alias -g .....=../../../..
alias -g ......=../../../../..

alias ls='ls -hp --color=auto'

alias ppath='echo "${PATH//:/\n}"'

alias exiftool='exiftool -P'

alias make=gmake

# functions ####################################################################

rm_ds_store () {
    if [[ -n $1 && -d $1 ]]; then
         cd "$1"
        shift
    fi
    rm **/.DS_Store
}

brew_update () {
    local cmd
    for cmd in update upgrade 'upgrade --cask' autoremove cleanup; do
        brew ${=cmd}
    done
}

todo () {
    echo "- $@" >> ~/Desktop/todo.txt
}

refresh () {
    source ~CONFIGS/zsh/.zprofile ~CONFIGS/zsh/.zshrc
}

# prompt #######################################################################

eval "$(starship init zsh)"
