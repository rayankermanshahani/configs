-- universal indent settings: 2‑space, spaces not tabs, everywhere
vim.opt.expandtab     = true   -- use spaces instead of real tabs
vim.opt.shiftwidth    = 2      -- number of spaces to use for each step of (auto)indent
vim.opt.tabstop       = 2      -- number of spaces that a <Tab> counts for
vim.opt.softtabstop   = 2      -- number of spaces that <Tab>/<BS> uses while editing

-- make sure no filetype ever overrides your above defaults
vim.api.nvim_create_augroup('GlobalIndent', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = 'GlobalIndent',
  pattern = '*',
  callback = function()
    -- re‑apply your 2‑space settings locally for every filetype
    vim.opt_local.expandtab   = true
    vim.opt_local.shiftwidth  = 2
    vim.opt_local.tabstop     = 2
    vim.opt_local.softtabstop = 2
  end,
})

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
-- vim.o.background = 'dark'
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
    -- color theme
    "ellisonleao/gruvbox.nvim",
    'maxmx03/solarized.nvim',

    -- auto dark mode
    "f-person/auto-dark-mode.nvim",


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
          ensure_installed = { "haskell", "ocaml", "python", "c", "cpp", "javascript", "typescript", },
          highlight = { enable = true },
        }
      end
    },


    -- add more plugins here
  },

  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- set theme
require("gruvbox").setup({contrast = "hard"})
vim.cmd("colorscheme gruvbox")
-- vim.cmd("colorscheme solarized")


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
-- local lspconfig = require('lspconfig')
-- local util = require('lspconfig.util')
-- lspconfig.lua_ls.setup{} -- lua support
-- lspconfig.pyright.setup{} -- python support
-- lspconfig.clangd.setup{} -- c/c++ support
-- lspconfig.ts_ls.setup{} -- ts/js support
-- lspconfig.hls.setup{} -- haskell support
-- lspconfig.ocamllsp.setup{} -- ocaml support
-- lspconfig.rust_analyzer.setup{ -- rust support
--   settings = {
--     ['rust-analyzer'] = {
--       rustfmt = {
--         extraArgs = {"--config", "tab_spaces=2"}
--       },
--       checkOnSave = { command = "clippy" },
--     }
--   }
-- }
-- === LSP (Neovim 0.11+ style) ===============================================

-- capabilities for nvim-cmp completion
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Define per-server configs
vim.lsp.config.lua_ls = {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
    },
  },
}

vim.lsp.config.pyright = {
  capabilities = capabilities,
}

vim.lsp.config.clangd = {
  capabilities = capabilities,
}

vim.lsp.config.ts_ls = {
  capabilities = capabilities,
}

vim.lsp.config.hls = {
  capabilities = capabilities,
}

vim.lsp.config.ocamllsp = {
  capabilities = capabilities,
}

vim.lsp.config.rust_analyzer = {
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      rustfmt = { extraArgs = { "--config", "tab_spaces=2" } },
      -- checkOnSave = { command = "clippy" },
      checkOnSave = true,
    },
  },
}

-- enable all the servers configured above
vim.lsp.enable({
  "lua_ls",
  "pyright",
  "clangd",
  "ts_ls",
  "hls",
  "ocamllsp",
  "rust_analyzer",
  "sourcekit",
})
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

-- c/c++: 2‑space indents
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"c", "cpp"},
  callback = function()
    vim.opt_local.tabstop     = 2
    vim.opt_local.shiftwidth  = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab   = true
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

-- Add OCaml-specific indentation settings (similar to your Haskell setup)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "ocaml", "dune", "opam", "ocamllex", "ocamlyacc", "menhir" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
    vim.opt_local.softtabstop = 2

    -- OCaml-specific keymaps
    local opts = { noremap=true, silent=true, buffer=true }
    vim.keymap.set('n', '<leader>ot', vim.lsp.buf.hover, opts)       -- show type info
    vim.keymap.set('n', '<leader>of', vim.lsp.buf.format, opts)      -- format code
    vim.keymap.set('n', '<leader>or', vim.lsp.buf.references, opts)  -- show references
    vim.keymap.set('n', '<leader>od', vim.lsp.buf.definition, opts)  -- go to definition
  end,
})

-- Add auto-formatting for OCaml files (similar to your other format-on-save setups)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.ml", "*.mli", "*.mll", "*.mly" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- python: 2‑space indents
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop     = 2
    vim.opt_local.shiftwidth  = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab   = true
  end,
})

-- python: format on save via LSP
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.py",
  callback = function()
    -- format with whatever LSP/formatter you have configured
    vim.lsp.buf.format({ async = false })
  end,
})


-- format rust on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",
  callback = function()
    -- format with whatever LSP/formatter you have configured
    vim.lsp.buf.format({ async = false })
  end,
})

-- format swift on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.swift",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

