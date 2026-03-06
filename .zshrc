eval "$(starship init zsh)"

echo""
autoload -Uz compinit
compinit

source ~/.config/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/fzf-tab/fzf-tab.plugin.zsh 
source ~/zsh-tempo/tempo.plugin.zsh

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

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'

alias ls="eza --icons=always"
# alias telegram="echo mannotdothis"
alias grep='grep --color=auto'
alias ip='ip -color=auto'
alias ..='cd ..'
alias ...='cd ../..'

alias wip="ip -4 addr show dev wlan0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'"
alias gip="curl ipinfo.io"
alias py='python3'
alias trash='mv --force -t ~/.local/share/Trash '
alias hg='history|grep'
alias ports='ss -tulpn'
alias path='echo -e ${PATH//:/\\n}'
alias temp='watch -n 1 sensors'
alias ycc='yc config list'

alias chrome-proxy='chromium --proxy-server="socks5://127.0.0.1:1080"'
alias dpi='ciadpi --disorder 1 --auto=torst --tlsrec 1+s'

########################navigate######################################
autoload -Uz edit-command-line
zle -N edit-command-line

yazi-cd() {
    local tempfile=$(mktemp)
    # Запускаем yazi и передаем выбранный путь в tempfile
    yazi --cwd-file="$tempfile" "${@:-$(pwd)}" < $TTY
    # Если tempfile существует, переходим в выбранную директорию
    [ -f "$tempfile" ] && cd -- "$(cat "$tempfile")" && rm -f "$tempfile"
    VISUAL=true zle edit-command-line
}
zle -N yazi-cd
bindkey '^o' yazi-cd
####################################################################

########################cpp#########################################
compile_and_run_cpp() {
    local source_file="$1"
    local executable_file="${source_file%.cpp}"

    g++ -std=c++17 -o "$executable_file" "$source_file" && ./"$executable_file"
}
alias cpp='compile_and_run_cpp'
mkcpp() {
    if [[ $1 == *.cpp ]]; then
        echo -e "#include <iostream>\nusing namespace std;\n\nint main() {\n    // Your code here\n    return 0;\n}" > "$1" && nvim "$1"
    else
        echo "Error: The file must have a .cpp extension"
    fi
}
###################################################################

function gits() {
    echo "\nEdited: "
    git diff --name-only
    echo "\nNew: "
    git ls-files --others --exclude-standard
}

export EDITOR='nvim'
export VISUAL='nvim'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export TERM=xterm-256color
export DISABLE_AUTO_UPDATE="true"
export NO_BELL=true
setopt NO_BEEP  
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word


setopt AUTO_CD
setopt EXTENDED_GLOB
setopt NO_CASE_GLOB
setopt NUMERIC_GLOB_SORT
setopt CORRECT
setopt COMPLETE_IN_WORD


eval "$(fzf --zsh)"

# --- setup fzf theme using gruvbox colors ---
fg="#ebdbb2"        # gruvbox light0
bg="#282828"        # gruvbox dark0
bg_highlight="#504945"  # gruvbox dark2
yellow="#fabd2f"    # gruvbox bright_yellow
orange="#fe8019"    # gruvbox bright_orange
blue="#83a598"      # gruvbox bright_blue
aqua="#8ec07c"      # gruvbox bright_aqua

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${yellow},fg+:${fg},bg+:${bg_highlight},hl+:${orange},info:${blue},prompt:${aqua},pointer:${aqua},marker:${aqua},spinner:${aqua},header:${aqua}"

# -- Use fd instead of find --
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
    fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
    fd --type=d --hidden --exclude .git . "$1"
}


show_file_or_dir_preview='if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi'

export FZF_CTRL_T_OPTS="--preview '${show_file_or_dir_preview}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

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

export BAT_THEME="gruvbox-dark"

alias ls="eza --icons=always"


if [ -f '/home/mars/yandex-cloud/path.bash.inc' ]; then source '/home/mars/yandex-cloud/path.bash.inc'; fi

if [ -f '/home/mars/yandex-cloud/completion.zsh.inc' ]; then source '/home/mars/yandex-cloud/completion.zsh.inc'; fi

export PATH="$PATH:$(go env GOPATH)/bin"

export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

