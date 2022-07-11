syntax on

"crosshairs
hi CursorColumn cterm=NONE ctermbg=235
hi CursorLine cterm=NONE ctermbg=235
:set cursorline! cursorcolumn!

"set mouse=a 

set re=0 

set background=dark

" colo bandw

set nocompatible

set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
"set smartindent
set ai 

set number

set hlsearch
set incsearch
set smartcase

hi Comment ctermfg=DarkGreen

set ruler

set belloff=all

set scrolloff=5

set laststatus=2

filetype plugin indent on
call plug#begin('~/.vim/plugged')

    "This is where you add your plugins 

"{{ Autopairs
" ---> closing XML tags <---
Plug 'alvan/vim-closetag'
" ---> files on which to activate tags auto-closing <---
  let g:closetag_filenames = '*.html,*.xhtml,*.xml,*.vue,*.phtml,*.js,*.jsx,*.coffee,*.erb'
"}}

"{{ TMux - Vim integration
Plug 'christoomey/vim-tmux-navigator'
"}}

"{{ JavaScript bundle -- improved syntax highliting + indentation 
Plug 'pangloss/vim-javascript'
"}}

"{{ TypeScript syntax 
Plug 'leafgarland/typescript-vim'
"}}

"{{ Solidity syntax highlighting 
Plug 'TovarishFin/vim-solidity'
"}}

"{{ Vyper syntax highlighting 
Plug 'vyperlang/vim-vyper'
"}}

"{{ Rust language support & syntax highlighting 
Plug 'rust-lang/rust.vim'
"}} 

call plug#end()


