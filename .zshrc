#### Language
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

#### Keybind
# Emacs keybind
bindkey -e

#### history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_reduce_blanks
setopt hist_find_no_dups
setopt hist_no_store
setopt hist_expand
setopt inc_append_history
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# 成功したコマンドだけ履歴に残す
# ref. https://smashawk.com/post-16
zshaddhistory() {
    # 以下の条件をすべて満たすものだけをヒストリに追加する
    [[ "$?" == 0 ]]
}

#### display
# color
autoload -Uz colors
colors

#### control
# enable backspace and delete
stty erase '^?'
bindkey "^[[3~" delete-char
# correct miss spelling
setopt correct
# wildcard
#setopt extended_glob
# disable C-s to lock and C-q to unlock
setopt no_flow_control
# directory traversal
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
# treat a part after '#' as a comment
setopt interactive_comments

#### search
# incremental search
# bindkey '^r' history-incremental-pattern-search-backward
# bindkey '^s' history-incremental-pattern-search-forward
## search for history with C-p and C-n
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

#### homebrew
arch=$(arch)

if [ $arch = "arm64" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$($HOME/intel/homebrew/bin/brew shellenv)"
fi

# HOMEBREW_PREFIXは`brew shellenv`でexportされている
export HOMEBREW_CACHE=$HOMEBREW_PREFIX/cache

#### sheldon
# installation:
#   brew install sheldon
eval "$(sheldon source)"

#### peco
# history search
# ref:
#   bash/zsh のヒストリを peco で便利にする - Qiita
#   https://qiita.com/comuttun/items/f54e755f22508a6c7d78
peco-select-history() {
    BUFFER=$(history 1 | sort -k1,1nr | sed -E 's/^[ |0-9|\*]+//' | peco --query "$LBUFFER")
    CURSOR=${#BUFFER}
    zle reset-prompt
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# cdr
# ref:
#   pecoを使って端末操作を爆速にする - Qiita
#   https://qiita.com/reireias/items/fd96d67ccf1fdffb24ed
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi

peco-cdr () {
    local selected_dir="$(cdr -l | sed -E 's/^[0-9]+ +//' | peco --prompt="cdr >" --query "$LBUFFER")"
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}
zle -N peco-cdr
bindkey '^s' peco-cdr

# ghq
# ref:
#   pecoを使って端末操作を爆速にする - Qiita
#   https://qiita.com/reireias/items/fd96d67ccf1fdffb24ed
function peco-ghq-look () {
    local selected_dir="$(ghq list --full-path | peco --prompt="cd-ghq >" --query "$LBUFFER")"
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}
zle -N peco-ghq-look
bindkey '^g' peco-ghq-look

#### completion
# case-insensitive completion
# ref:
#   zshで適度なcase-insensitive補完 - Qiita
#   https://qiita.com/watertight/items/2454f3e9e43ef647eb6b
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
# enable to select completion
zstyle ':completion:*:default' menu select=2

#### autosuggestion
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#80715e,underline"
bindkey '^ ' autosuggest-execute

#### prompt
PROMPT="%F{blue}%1~%f %% "

#### aliases
case `uname` in
    Darwin)
        alias ls='ls -FG'
        alias ll='ls -lAhFG'
        export PATH="/Applications/Emacs.app/Contents/MacOS/bin:$PATH"
        alias em='emacsclient_or_emacs'
        ;;
    Linux)
        alias ls='ls -FG --color'
        alias ll='ls -lAhFG --color'
        alias em='emacsclient_or_emacs'
esac
alias dc='docker-compose'
alias po='poetry'
alias cdiff='colordiff'
alias kc='kubectl'
alias kx='kubectx'
alias tf='terraform'
alias gi='git'
alias le='less'
alias op='open'
alias gs='gcloud storage'
alias ba='bat'

#### Emacs
# ref:
#   [Emacs] emacsclient を快適に使うための設定 - Qiita
#   https://qiita.com/sijiaoh/items/6bd9de68d596f6469129
function emacsclient_or_emacs() {
    # try to focus existing frame (server)
    if emacsclient -n -e "(select-frame-set-input-focus (selected-frame))" > /dev/null 2>&1; then
        # if the server exists, open file
        emacsclient -n "$@" > /dev/null &
    else
        # otherwise invoke new server
        emacs "$@" &
    fi
}

#### git
# ref:
#   【zsh】絶対やるべき！ターミナルでgitのブランチ名を表示&補完
#   【git-prompt / git-completion#】 - Qiita
#    https://qiita.com/mikan3rd/items/d41a8ca26523f950ea9d
source ~/.zsh/git-prompt.sh
fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto
setopt PROMPT_SUBST ; PS1='%F{cyan}%c%f %F{green}$(__git_ps1 "(%s) ")%f%% '

#### CUDA
export PATH="/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"

#### pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'

#### poetry
export PATH="$HOME/.local/bin:$PATH"

#### PyCharm
export PATH="$HOME/Library/Application Support/JetBrains/Toolbox/scripts:$PATH"

#### Go
export GOPATH=$HOME/go
export PATH="$GOPATH/bin:$PATH"

#### Visual Studio Code
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

#### trash-cli
if type trash-put &> /dev/null
then
    alias rm=trash-put
fi
