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
alias ls='ls -FG'
alias ll='ls -lAhtFG'
alias em='open -a Emacs.app'

#### git
RPROMPT="%{${fg[blue]}%}[%~]%{${reset_color}%}"
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }
RPROMPT=$RPROMPT'${vcs_info_msg_0_}'

#### pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
