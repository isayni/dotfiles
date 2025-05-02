#            _
#    _______| |__  _ __ ___
#   |_  / __| '_ \| '__/ __|
#    / /\__ \ | | | | | (__
#   /___|___/_| |_|_|  \___|
#
autoload -Uz vcs_info
precmd() {vcs_info}
zstyle ':vcs_info:git:*' formats ' (%b)'
setopt PROMPT_SUBST

PROMPT='%B%F{red}%~%b%F{yellow}${vcs_info_msg_0_} %B%F{cyan}>%b%f '

alias ls='lsd'
alias l='ls'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias grep='grep --color=auto'
alias ip='ip -color=auto'
alias hist='history'
alias clip='xclip -sel clipboard'
alias vi='vim'
alias p='sudo pacman'
alias py='bpython'
alias please='sudo'
alias shut='shutdown --poweroff now'
alias v='volumecontrol'
alias rg='ranger'

bindkey -e
bindkey "^[[3~"   delete-char
bindkey "^H"      backward-kill-word
bindkey "[3;5~" kill-word
bindkey "[3^"   kill-word
bindkey "[1;5C" forward-word
bindkey "[1;5D" backward-word
bindkey "^[Oc"    forward-word
bindkey "^[Od"    backward-word

HISTFILE=~/.cache/zsh/history
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
unsetopt beep

# these characters are parts of words
WORDCHARS='*?-.[]~=&;!#$%^(){}<>'

export EDITOR=vim
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"

c(){
    cd $1 && ls
}

# The following lines were added by compinstall
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' menu select
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
zstyle ':completion::complete:*' gain-privileges 1
zstyle :compinstall filename '/home/lenny/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
