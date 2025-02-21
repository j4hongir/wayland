eval "$(starship init zsh)"

echo""
~/tbt/./tbt.sh -d
~/tbt/./tbt.sh -w

autoload -Uz compinit
compinit

source ~/.config/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/fzf-tab/fzf-tab.plugin.zsh 

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_VERIFY              
setopt HIST_IGNORE_SPACE       
setopt HIST_REDUCE_BLANKS     
setopt HIST_NO_STORE         
setopt EXTENDED_HISTORY      
setopt INC_APPEND_HISTORY    

# Completion settings
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Autosuggestions configuration
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'

# Common aliases
alias ls="eza --icons=always"
alias grep='grep --color=auto'
alias ip='ip -color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias sys='systemctl'
alias pac='sudo pacman'

alias sshr='sudo systemctl restart ssh'
alias sshs='sudo systemctl stop ssh'
alias sshh='sudo systemctl status ssh'
alias wip="ip -4 addr show dev wlan0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'"
alias py='python3'
alias trash='mv --force -t ~/.local/share/Trash '
alias hg='history|grep'
alias ports='ss -tulpn'
alias path='echo -e ${PATH//:/\\n}'

# Enhanced key bindings and line editing
bindkey -v                      # Enable Vi mode
export KEYTIMEOUT=1            # Reduce mode switch delay

# History search
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# Key bindings
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey '^[b' backward-word
bindkey '^[f' forward-word
bindkey '^[^?' backward-kill-word  
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Navigate with yazi
autoload -Uz edit-command-line
zle -N edit-command-line

yazi-cd() {
    local tempfile=$(mktemp)
    yazi --cwd-file="$tempfile" "${@:-$(pwd)}" < $TTY
    [ -f "$tempfile" ] && cd -- "$(cat "$tempfile")" && rm -f "$tempfile"
    VISUAL=true zle edit-command-line
}
zle -N yazi-cd
bindkey '^o' yazi-cd

# C++ functions
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

# Git status function
function gits() {
    echo "\nEdited: "
    git diff --name-only
    echo "\nNew: "
    git ls-files --others --exclude-standard
}

# Environment variables
export EDITOR='nvim'
export VISUAL='nvim'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TERM=xterm-256color
export DISABLE_AUTO_UPDATE="true"
export NO_BELL=true
export PATH="$HOME/.cargo/bin:$PATH"

# Shell options
setopt NO_BEEP
setopt AUTO_CD
setopt EXTENDED_GLOB
setopt NO_CASE_GLOB
setopt NUMERIC_GLOB_SORT
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt NO_FLOW_CONTROL
setopt INTERACTIVE_COMMENTS

# FZF configuration
eval "$(fzf --zsh)"

# FZF theme (gruvbox colors)
fg="#ebdbb2"
bg="#282828"
bg_highlight="#504945"
yellow="#fabd2f"
orange="#fe8019"
blue="#83a598"
aqua="#8ec07c"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${yellow},fg+:${fg},bg+:${bg_highlight},hl+:${orange},info:${blue},prompt:${aqua},pointer:${aqua},marker:${aqua},spinner:${aqua},header:${aqua}"

# FZF command configuration
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# FZF completion functions
_fzf_compgen_path() {
    fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
    fd --type=d --hidden --exclude .git . "$1"
}

# Preview commands
show_file_or_dir_preview='if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi'

export FZF_CTRL_T_OPTS="--preview '${show_file_or_dir_preview}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# FZF completion runner
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

# Theme settings
export BAT_THEME="gruvbox-dark"
