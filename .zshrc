autoload -U colors && colors 

PS1="%{$fg[cyan]%}%n@%m%{$reset_color%}: %{$fg[yellow]%}%(4~|.../%3~|%~) %{$reset_color%}$ "

alias ls='ls -1G'

export VISUAL=vim
export EDITOR="$VISUAL"

export PATH=$PATH:~/Library/Python/3.8/bin
