" Basic settings
syntax on
set number                      " Show line numbers
set tabstop=4                   " Number of spaces that a <Tab> in the file counts for
set shiftwidth=4                " Number of spaces to use for each step of (auto)indent
set expandtab                   " Use spaces instead of tabs
set autoindent
set smartindent
set background=light            " Set the background color (light or dark)

" search highlighting 
set hlsearch

" Color scheme
" You might need to install a plugin or a colorscheme file for a specific look
" Here, we use a default light scheme as an example
" colorscheme peachpuff

" Additional visual settings
set cursorline                  " Highlight the current line
" set cursorcolumn
" highlight CursorLine   cterm=NONE ctermbg=lightblue ctermfg=NONE guibg=#f8f8f8 guifg=NONE
" highlight CursorColumn cterm=NONE ctermbg=lightblue ctermfg=NONE guibg=#f8f8f8 guifg=NONE

" Split window settings
set splitright                  " Vertical splits will automatically be to the right
set splitbelow                  " Horizontal splits will automatically be below

" Plugins and additional configurations (if any)
" Consider using vim-plug or any other plugin manager
call plug#begin('~/.vim/plugged')

" Example: Plugin for better status line
Plug 'vim-airline/vim-airline'

call plug#end()

" Airline theme (optional)
let g:airline_theme='light'

" Additional UI tweaks (optional)
set showcmd                    " Show incomplete commands
set showmatch                  " Highlight matching parentheses
set wildmenu                   " Visual autocomplete for command menu
set lazyredraw                 " Faster scrolling
set ttyfast                    " Faster rendering

" Custom highlights (if needed)
highlight Comment ctermfg=DarkGray
highlight Keyword ctermfg=Blue
highlight String ctermfg=DarkGreen

