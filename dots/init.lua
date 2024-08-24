 -- Basic settings
 vim.o.syntax = 'on'
 vim.o.number = true
 vim.o.tabstop = 4
 vim.o.shiftwidth = 4
 vim.o.expandtab = true
 vim.o.autoindent = true
 vim.o.smartindent = true
 vim.o.background = 'light'
 
 -- Search highlighting
 vim.o.hlsearch = true
 
 
 -- Additional visual settings
 vim.o.cursorline = true
 vim.o.cursorcolumn = true
 
 -- Custom crosshair highlights
 vim.cmd('highlight CursorLine guibg=#F0F0F0 guifg=NONE cterm=NONE ctermbg=255')
 vim.cmd('highlight CursorColumn guibg=#F0F0F0 guifg=NONE cterm=NONE ctermbg=255')
 
 
 -- Highlight matching parentheses and brackets with a shade of yellow
 vim.cmd('highlight MatchParen guibg=NONE guifg=#FFFF00 cterm=bold ctermbg=NONE ctermfg=Yellow')

-- Split window settings
vim.o.splitright = true
vim.o.splitbelow = true

-- Additional UI tweaks
vim.o.showcmd = true
vim.o.showmatch = true
vim.o.wildmenu = true
vim.o.lazyredraw = true
vim.o.ttyfast = true

-- Custom highlights
vim.cmd('highlight Comment ctermfg=DarkGray')
vim.cmd('highlight Keyword ctermfg=Blue')
vim.cmd('highlight String ctermfg=DarkGreen')

-- Plugin management using packer.nvim
require('packer').startup(function()

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Example plugin for better status line
  use 'vim-airline/vim-airline'

    use 'ziglang/zig.vim'

  use {
    'neovim/nvim-lspconfig',  -- Collection of configurations for built-in LSP client
    'hrsh7th/nvim-cmp',       -- Autocompletion plugin
    'hrsh7th/cmp-nvim-lsp',   -- LSP source for nvim-cmp
    'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
    'L3MON4D3/LuaSnip',       -- Snippets plugin
    'hrsh7th/cmp-buffer',     -- Buffer completions
    'hrsh7th/cmp-path',       -- Path completions
    'hrsh7th/cmp-cmdline',    -- Command line completions
    'hrsh7th/cmp-vsnip',      -- VSnip source for nvim-cmp
    'hrsh7th/vim-vsnip',      -- Snippets plugin
    'ray-x/lsp_signature.nvim', -- Function signature hints
  }

  use 'nvim-treesitter/nvim-treesitter'

  -- markdown preview 
  use 'iamcco/markdown-preview.nvim'

end)

-- Configure LSP
local lspconfig = require('lspconfig')

-- Autocompletion setup
local cmp = require'cmp'
local luasnip = require'luasnip'

local treesitter = require('nvim-treesitter')

treesitter.setup{
    highlight = {
        enable = true,
    }
}

cmp.setup{
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  mapping = {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
}

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Configure lsp_signature
require'lsp_signature'.setup({
  bind = true,
  floating_window = true,
  hint_enable = true,
  hint_prefix = {
      above = "↙ ", -- when hint is on the line above current line
      current = "← ", -- when hint is on the line above current line
      below = "↖ ", -- when hint is on the line above current line
  },
  handler_opts = {
    border = "single"
  }
})

-- Python LSP
lspconfig.pyright.setup{}
--
-- Elixir LSP
lspconfig.elixirls.setup{
    cmd =  { '/opt/homebrew/bin/elixir-ls' }
}

-- C/C++ LSP
lspconfig.clangd.setup{
  on_attach = function(client, bufnr)
    -- Keybindings for LSP
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local opts = { noremap = true, silent = true }

    -- Key mappings
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
    vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
  end,

  flags = {
    debounce_text_changes = 150,
  }
}

-- JavaScript/TypeScript LSP
lspconfig.tsserver.setup{}

-- Golang LSP
lspconfig.gopls.setup{}

-- Example for configuring Lua LSP
lspconfig.lua_ls.setup{
  settings = {
    Lua = {
      diagnostics = {
        globals = {'vim'}
      }
    }
  }
}

-- zig lsp
lspconfig.zls.setup({
    on_attach = function(client, bufnr)
        -- Add any custom on_attach functions here, if you have any
    end,
    flags = {
        debounce_text_changes = 150,
    },
    settings = {
        zls = {
            enable_inlay_hints = true, -- Enable inlay hints for Zig (optional)
            inlay_hints_show_builtin = true, -- Show hints for builtin types
        },
    },
})
