#### Keybind
# Emacs keybind
bindkey -e

#### history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt inc_append_history
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

#### display
# color
autoload -Uz colors
colors

#### control
# enable backspace and delete
stty erase ^H
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
bindkey '^r' history-incremental-pattern-search-backward
bindkey '^s' history-incremental-pattern-search-forward
## search for history with C-p and C-n
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

#### completion
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit -U
fi
# case-insensitive completion
# ref:
#   zshで適度なcase-insensitive補完 - Qiita
#   https://qiita.com/watertight/items/2454f3e9e43ef647eb6b
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
# enable to select completion
zstyle ':completion:*:default' menu select=2

#### prompt
PROMPT="%F{blue}%1~%f %% "

#### aliases
case `uname` in
    Darwin)
        alias ls='ls -FG'
        alias ll='ls -lAhtFG'
        alias em='open -a Emacs.app'
        ;;
    Linux)
        alias ls='ls -FG --color'
        alias ll='ls -lAhtFG --color'
        alias em='emacsclient_or_emacs'
esac
alias dc='docker-compose'

#### Emacs
# ref:
#   [Emacs] emacsclient を快適に使うための設定 - Qiita
#   https://qiita.com/sijiaoh/items/6bd9de68d596f6469129
function emacsclient_or_emacs() {
    if emacsclient -e 0 > /dev/null 2>&1; then
        emacsclient -n "$@"
    else
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
autoload -Uz compinit && compinit
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto
setopt PROMPT_SUBST ; PS1='%F{cyan}%c%f %F{green}$(__git_ps1 "(%s) ")%f%% '

#### pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
