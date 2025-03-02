-- general ui
vim.g.maplocalleader = "\\"
vim.o.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.o.syntax = 'on'
vim.o.number = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.breakindent = true
vim.o.background = 'dark'
vim.o.showcmd = true
vim.o.showmatch = true
vim.o.wildmenu = true
vim.o.lazyredraw = true
vim.o.ttyfast = true
vim.cmd('highlight Comment ctermfg=DarkGray')
vim.cmd('highlight MatchParen guibg=NONE guifg=#FFFF00 cterm=bold ctermbg=NONE ctermfg=Yellow')

-- custom crosshair highlighting
vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.cmd('highlight CursorLine guibg=#303030 guifg=NONE cterm=NONE ctermbg=236')
vim.cmd('highlight CursorColumn guibg=#303030 guifg=NONE cterm=NONE ctermbg=236')
vim.cmd('highlight Cursor guibg=#303030  guifg=NONE cterm=NONE ctermbg=236')

-- bootstrap lazy.nvim (PLUGIN MANAGER)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- setup lazy.nvim
require("lazy").setup({
  spec = {
    -- flexoki theme
    { "nuvic/flexoki-nvim", name = "flexoki" },

    -- better statusline
    'vim-airline/vim-airline',

    -- plenary
    'nvim-lua/plenary.nvim',

    -- lsp and autocomplete
    {
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
    },

    -- better syntax highlighting
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      event = 'BufRead',
      config = function()
        require('nvim-treesitter.configs').setup {
          ensure_installed = { "haskell" },
          highlight = {
            enable = true,
          },
        }
      end
    },

    -- js/ts auto-formatting 
    {
      "jose-elias-alvarez/null-ls.nvim",
      config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
          sources = {
            null_ls.builtins.formatting.prettier, -- Use Prettier for JS/TS
          },
        })
      end,
    },

    { -- rust support
      'mrcjkb/rustaceanvim',
      version = '^5', -- Recommended
      lazy = false, -- This plugin is already lazy
    },

    -- add more plugins here
  },

  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- set theme
vim.cmd("colorscheme flexoki")

-- autocompletion setup
local cmp = require'cmp'
local luasnip = require'luasnip'
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

-- use buffer source for `/`
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- use cmdline & path source for `:`
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- fancy lsp_signature lol
require'lsp_signature'.setup({
  bind = true,
  floating_window = true,
  hint_enable = true,
  hint_prefix = {
      above = "↙ ",
      current = "← ",
      below = "↖ ",
  },
  handler_opts = {
    border = "single"
  }
})

-- setup lsp
local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup{} -- lua support
lspconfig.pyright.setup{} -- python support
lspconfig.clangd.setup{} -- c/c++ support
lspconfig.ts_ls.setup{} -- ts/js support
lspconfig.hls.setup{} -- haskell support

-- expand error message from lsp
vim.keymap.set('n', 'gl', "<cmd>lua vim.diagnostic.open_float()<CR>", { noremap = true, silent = true })

-- configure clipboard explicitly
vim.opt.clipboard = "unnamedplus"

-- format c/cpp/cu on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.c", "*.cpp", "*.h", "*.hpp", "*.cu", "*.cuh"},
    callback = function()
        vim.lsp.buf.format({ async = true })  -- use LSP's built-in formatter (clangd)
    end,
})

-- format js/ts on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.js", "*.ts", "*.jsx", "*.tsx" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- format haskell on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.hs", "*.lhs", "*.cabal" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- add haskell indentation settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "haskell", "lhaskell", "cabal" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
    vim.opt_local.softtabstop = 2

    -- haskell-specific keymaps
    local opts = { noremap=true, silent=true, buffer=true }
    vim.keymap.set('n', '<leader>ht', vim.lsp.buf.hover, opts)       -- show type info
    vim.keymap.set('n', '<leader>hf', vim.lsp.buf.format, opts)      -- format code
    vim.keymap.set('n', '<leader>hr', vim.lsp.buf.references, opts)  -- show references
    vim.keymap.set('n', '<leader>hd', vim.lsp.buf.definition, opts)  -- go to definition
  end,
})
