autoload -U colors && colors 

PS1="%{$fg[cyan]%}%n@%m%{$reset_color%}: %{$fg[yellow]%}%(4~|.../%3~|%~) %{$reset_color%}$ "

alias ls='ls -1G'

export VISUAL=vim
export EDITOR="$VISUAL"

# Intel homebrew (old) command: brow 
alias brow='arch --x86_64 /usr/local/Homebrew/bin/brew' 
path=('/usr/local/Homebrew/bin/brew' $path) 
export PATH

# Apple Silicon Homebrew 
path=('/opt/homebrew/bin' $path) 
export PATH

# adding solana to path
PATH='/Users/rayker/Developer/solana/bin':$PATH



