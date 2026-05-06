echo ""
autoload -Uz compinit
if [[ -n $(find ~/.zcompdump -mtime +1 2>/dev/null) ]]; then
    compinit
else
    compinit -C
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

export TEMPO_WIDTH=50
export TEMPO_ITEMS="day week"
source ~/tempo/tempo.plugin.zsh
source ~/.config/fzf-tab/fzf-tab.plugin.zsh
source ~/.config/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

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
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS    
setopt HIST_REDUCE_BLANKS   
setopt HIST_VERIFY          
setopt INC_APPEND_HISTORY   

export EDITOR="helix"
export VISUAL='helix'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export BAT_THEME="gruvbox-dark"
[[ ":$PATH:" != *":$HOME/.cargo/bin:"* ]] && export PATH="$HOME/.cargo/bin:$PATH"
[[ ":$PATH:" != *":$PYENV_ROOT/bin:"* ]] && export PATH="$PYENV_ROOT/bin:$PATH"
export VBOX_LOG_DEST=nofile
export VBOX_RELEASE_LOG_DEST=nofile

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

local _fzf_cache="$HOME/.cache/fzf-zsh.zsh"
if [[ ! -f "$_fzf_cache" || "$(command -v fzf)" -nt "$_fzf_cache" ]]; then
    fzf --zsh > "$_fzf_cache"
fi
source "$_fzf_cache"

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

export KEYTIMEOUT=1
bindkey -v
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

function _reset_cursor_precmd() { echo -ne '\e[5 q' }
autoload -Uz add-zsh-hook
add-zsh-hook precmd _reset_cursor_precmd

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
eval "$(starship init zsh)"
