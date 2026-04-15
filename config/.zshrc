echo ""

autoload -Uz compinit
if [[ -n $(find ~/.zcompdump -mtime +1 2>/dev/null) ]]; then
    compinit
else
    compinit -C
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

source ~/.config/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/fzf-tab/fzf-tab.plugin.zsh
source ~/zsh-tempo/tempo.plugin.zsh

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'

TBT_WIDTH=50
TBT_SHOW_ITEMS="day week "
TBT_FILLED_CHAR="#"
TBT_EMPTY_CHAR="."

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

setopt AUTO_CD
setopt EXTENDED_GLOB
setopt NO_CASE_GLOB
setopt NUMERIC_GLOB_SORT
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt NO_BEEP

export EDITOR="$VISUAL"
export VISUAL='helix'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TERM=xterm-256color
export DISABLE_AUTO_UPDATE="true"
export NO_BELL=true
export BAT_THEME="gruvbox-dark"

export PATH="$HOME/.cargo/bin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

alias ls="eza --icons=always"
alias hx="helix"
alias grep='grep --color=auto'
alias ip='ip -color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias py='python3'
alias hg='history|grep'
alias ports='ss -tulpn'
alias path='print -l $path'
alias temp='watch -n 1 sensors'
alias ycc='yc config list'
alias wip="ip -4 addr show dev wlan0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'"
alias gip="curl ipinfo.io"
alias chrome-proxy='chromium --proxy-server="socks5://127.0.0.1:1080"'
alias dpi='ciadpi --disorder 1 --auto=torst --tlsrec 1+s'

function gits() {
    echo "\nEdited: "
    git diff --name-only
    echo "\nNew: "
    git ls-files --others --exclude-standard
}

eval "$(fzf --zsh)"

fg="#ebdbb2"
bg="#282828"
bg_highlight="#504945"
yellow="#fabd2f"
orange="#fe8019"
blue="#83a598"
aqua="#8ec07c"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${yellow},fg+:${fg},bg+:${bg_highlight},hl+:${orange},info:${blue},prompt:${aqua},pointer:${aqua},marker:${aqua},spinner:${aqua},header:${aqua}"
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

show_file_or_dir_preview='if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi'

export FZF_CTRL_T_OPTS="--preview '${show_file_or_dir_preview}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_compgen_path() { fd --hidden --exclude .git . "$1" }
_fzf_compgen_dir()  { fd --type=d --hidden --exclude .git . "$1" }

_fzf_comprun() {
    local command=$1
    shift
    case "$command" in
        cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
        export|unset) fzf --preview "eval 'echo \${}'" "$@" ;;
        ssh)          fzf --preview 'dig {}' "$@" ;;
        *)            fzf --preview "${show_file_or_dir_preview}" "$@" ;;
    esac
}

bindkey -v
export KEYTIMEOUT=1

bindkey -M viins "^?" backward-delete-char
bindkey -M viins "^H" backward-kill-word
bindkey -M viins '\e[2;3~' backward-kill-word
bindkey -M viins '\e^?' backward-kill-word
bindkey -M viins '\e[1;3D' backward-word
bindkey -M viins '\e[1;3C' forward-word
bindkey -M viins '\e[1;3A' beginning-of-line
bindkey -M viins '\e[1;3B' end-of-line

bindkey -M viins '^[[A' up-line-or-search
bindkey -M viins '^[[B' down-line-or-search
bindkey -M viins '^[[H' beginning-of-line
bindkey -M viins '^[[F' end-of-line
bindkey -M viins '^[[3~' delete-char
bindkey -M viins '^[[1;5C' forward-word
bindkey -M viins '^[[1;5D' backward-word

function zle-keymap-select {
    if [[ $KEYMAP == vicmd ]]; then
        echo -ne '\e[2 q'
    else
        echo -ne '\e[5 q'
    fi
}
zle -N zle-keymap-select
precmd() { echo -ne '\e[5 q' }

autoload -Uz edit-command-line
zle -N edit-command-line

yazi-cd() {
    local tempfile=$(mktemp)
    yazi --cwd-file="$tempfile" "${@:-$(pwd)}" < $TTY
    [ -f "$tempfile" ] && cd -- "$(cat "$tempfile")" && rm -f "$tempfile"
    VISUAL=true zle edit-command-line
}
zle -N yazi-cd
bindkey -M viins '^o' yazi-cd

if [ -f '/home/mars/yandex-cloud/path.bash.inc' ]; then
    source '/home/mars/yandex-cloud/path.bash.inc'
fi
if [ -f '/home/mars/yandex-cloud/completion.zsh.inc' ]; then
    source '/home/mars/yandex-cloud/completion.zsh.inc'
fi


eval "$(starship init zsh)"
