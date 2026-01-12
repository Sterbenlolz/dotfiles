#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
alias conf='cd ~/.config'
alias ave='source .venv/bin/activate'
alias ssh='kitty +kitten ssh'
alias vi='nvim'
fastfetch

eval "$(starship init bash)"
