autoload -U colors && colors 

PS1="%{$fg[cyan]%}%n@%m%{$reset_color%}:%{$fg[yellow]%}%~%{$reset_color%}$ "

alias ls='ls -1G'

# opening directory/file in VSCodium
alias vsc="open $1 -a "VSC""

export VISUAL=vim
export EDITOR="$VISUAL"

# Intel homebrew (old) command: brow 
alias brow='arch --x86_64 /usr/local/Homebrew/bin/brew' 
path=('/usr/local/Homebrew/bin/brew' $path) 
export PATH

# Apple Silicon Homebrew 
path=('/opt/homebrew/bin' $path) 
export PATH


# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

export PATH="$PATH:/Users/rayker/.foundry/bin"
