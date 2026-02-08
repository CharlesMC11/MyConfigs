source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration" 2>/dev/null

# options ######################################################################

typeset -Ua opts
opts=(
    AUTOCD
    CDABLE_VARS
    CHASE_DOTS
    PUSHD_IGNORE_DUPS
    AUTO_LIST
    BAD_PATTERN
    EXTENDED_GLOB
    GLOB_STAR_SHORT
    HIST_ALLOW_CLOBBER
    HIST_EXPIRE_DUPS_FIRST
    HIST_FCNTL_LOCK
    HIST_FIND_NO_DUPS
    HIST_IGNORE_ALL_DUPS
    HIST_IGNORE_DUPS
    HIST_NO_FUNCTIONS
    HIST_NO_STORE
    HIST_REDUCE_BLANKS
    HIST_SAVE_NO_DUPS
    HIST_VERIFY
    SHARE_HISTORY
)
setopt "${(@)opts}"
unset opts

zmodload zsh/files

autoload -Uz compinit; compinit

# aliases ######################################################################

alias -g ...=../..
alias -g ....=../../..
alias -g .....=../../../..
alias -g ......=../../../../..

alias ls='ls -hp --color=auto'

alias paths='print -l -- "${(@)path}"'

alias exiftool='exiftool -P'

# functions ####################################################################

rm_ds_store () {
    (
        [[ -d $1 ]] && cd "$1"
        rm **/.DS_Store(N)
    )
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
