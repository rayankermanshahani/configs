-- Enable syntax highlighting
vim.cmd 'syntax on'

-- Crosshairs
vim.cmd [[
  hi CursorColumn cterm=NONE ctermbg=235
  hi CursorLine cterm=NONE ctermbg=235
]]
vim.wo.cursorline = true
vim.wo.cursorcolumn = true

-- Basic settings
vim.o.re = 0
vim.o.background = 'dark'
vim.o.nocompatible = true
vim.o.ai = true
vim.o.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.wo.number = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.smartcase = true

-- Highlighting for comments
vim.cmd 'hi Comment ctermfg=darkgreen'

vim.o.ruler = true
vim.o.belloff = 'all'
vim.o.scrolloff = 5
vim.o.laststatus = 2

-- Filetype plugin and indent
vim.cmd 'filetype plugin indent on'

-- Custom command for ClangFormat
vim.api.nvim_create_user_command(
  'ClangFormat',
  function(opts)
    vim.cmd(string.format('%d,%d!clang-format', opts.line1, opts.line2))
  end,
  {range = '%'}
)

-- Preserve cursor position function and autocmd
local function preserve_cursor_position()
  local pos = vim.fn.getpos(".")
  vim.cmd 'ClangFormat'
  vim.fn.setpos('.', pos)
end

vim.api.nvim_create_augroup('fmt', {clear = true})
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = {'*.cpp', '*.h', '*.hpp', '*.cxx', '*.cc'},
  callback = preserve_cursor_position,
  group = 'fmt',
})

-- Plugin setup
vim.cmd 'call plug#begin(\'~/.config/nvim/plugged\')'

vim.cmd 'Plug \'neovim/nvim-lspconfig\''
vim.cmd 'Plug \'alvan/vim-closetag\''
vim.g.closetag_filenames = '*.html,*.xhtml,*.xml,*.vue,*.phtml,*.js,*.jsx,*.coffee,*.erb'
-- vim.cmd 'Plug \'rust-lang/rust.vim\''
-- vim.cmd 'Plug \'bfrg/vim-cpp-modern\''

vim.cmd 'call plug#end()'

-- python lsp
require'lspconfig'.pyright.setup{}
-- typescript (javascript) lsp
require'lspconfig'.tsserver.setup{}
-- c/c++
require("lspconfig").clangd.setup{}
-- html lsp
require'lspconfig'.html.setup{}
-- rust lsp
require'lspconfig'.rust_analyzer.setup{}
-- go lsp
require'lspconfig'.gopls.setup{}
