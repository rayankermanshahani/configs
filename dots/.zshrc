autoload -Uz colors && colors 

# PS1="%{$fg[cyan]%}%n@%m%{$reset_color%}:%{$fg[yellow]%}%~%{$reset_color%}$ "
PS1="%n@%m:%~$ "

setopt autocd
bindkey -v

alias ..='cd ..'
alias ls='ls -1G --color'
alias space="du -h --max-depth=1 | sort -hr"

# lazy git
alias gitup="~/scripts/gitup $1"

export VISUAL=nvim
export EDITOR="$VISUAL"

# activate python uv venv
alias vact=". ./.venv/bin/activate"
#
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

export NVM_DIR="$HOME/.nvm"
source $(brew --prefix nvm)/nvm.sh
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Created by `pipx` on 2022-11-27 20:06:56
export PATH="$PATH:/Users/rayker/.local/bin"

# Created by `pipx` on 2022-11-27 20:06:59
export PATH="$PATH:/Users/rayker/Library/Python/3.10/bin"

alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
. "$HOME/.cargo/env"

# bun completions
[ -s "/Users/rayker/.bun/_bun" ] && source "/Users/rayker/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# opam configuration
[[ ! -r /Users/rayker/.opam/opam-init/init.zsh ]] || source /Users/rayker/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# pnpm
export PNPM_HOME="/Users/rayker/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# clean ssh into my rig 
alias box="~/scripts/connect_box.sh"

