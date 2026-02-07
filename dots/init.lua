-- universal indent settings: 2‑space, spaces not tabs, everywhere
vim.opt.expandtab     = true   -- use spaces instead of real tabs
vim.opt.shiftwidth    = 2      -- number of spaces to use for each step of (auto)indent
vim.opt.tabstop       = 2      -- number of spaces that a <Tab> counts for
vim.opt.softtabstop   = 2      -- number of spaces that <Tab>/<BS> uses while editing

-- use nvim-tree as the file explorer
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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

    -- better statusline
    'vim-airline/vim-airline',

    -- plenary
    'nvim-lua/plenary.nvim',

    -- directory tree explorer
    {
      "nvim-tree/nvim-tree.lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        local api = require("nvim-tree.api")

        local function on_attach(bufnr)
          api.config.mappings.default_on_attach(bufnr)

          local function opts(desc)
            return {
              desc = "nvim-tree: " .. desc,
              buffer = bufnr,
              noremap = true,
              silent = true,
              nowait = true,
            }
          end

          vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
          vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
        end

        require("nvim-tree").setup({
          on_attach = on_attach,
          update_focused_file = {
            enable = true,
          },
          view = {
            width = 35,
          },
        })

        local function focus_tree_or_clear_search()
          if api.tree.is_visible() then
            if vim.bo.filetype == "NvimTree" then
              vim.cmd("wincmd p")
            else
              api.tree.focus()
            end
          else
            vim.cmd("nohlsearch")
          end
        end

        vim.keymap.set("n", "<C-[>", focus_tree_or_clear_search, {
          noremap = true,
          silent = true,
          desc = "Toggle focus between file tree and editor",
        })
        vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", {
          noremap = true,
          silent = true,
          desc = "Toggle file tree",
        })
      end,
    },

    -- VSCode-like file switcher
    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<C-p>", function()
          builtin.find_files({ hidden = true })
        end, {
          noremap = true,
          silent = true,
          desc = "Search files",
        })
      end,
    },


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
      main = 'nvim-treesitter',
      opts = {
        ensure_installed = { "python", "c", "cpp", "javascript", "typescript" },
      },
    },


    -- LaTeX support
    {
      'lervag/vimtex',
      lazy = false,  -- don't lazy-load VimTeX
      init = function()
        vim.g.vimtex_view_method = 'zathura'  -- or 'skim' on macOS, 'sioyek', 'mupdf'
        vim.g.vimtex_compiler_method = 'latexmk'
        vim.g.vimtex_compiler_latexmk = {
          out_dir = '',  -- or set a build dir like 'build'
          options = {
            '-pdf',
            '-interaction=nonstopmode',
            '-synctex=1',
          },
        }
        vim.g.vimtex_quickfix_mode = 0  -- don't open quickfix on warnings
      end,
    },

    -- LaTeX symbol completion for nvim-cmp
    'kdheepak/cmp-latex-symbols',

    -- add more plugins here
  },

  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- set theme: Campbell (Windows Terminal default)
vim.o.termguicolors = true

local function set_campbell()
  local c = {
    bg = "#0C0C0C",
    fg = "#CCCCCC",
    cursor = "#FFFFFF",
    black = "#0C0C0C",
    red = "#C50F1F",
    green = "#13A10E",
    yellow = "#C19C00",
    blue = "#0037DA",
    magenta = "#881798",
    cyan = "#3A96DD",
    white = "#CCCCCC",
    bright_black = "#767676",
    bright_red = "#E74856",
    bright_green = "#16C60C",
    bright_yellow = "#F9F1A5",
    bright_blue = "#3B78FF",
    bright_magenta = "#B4009E",
    bright_cyan = "#61D6D6",
    bright_white = "#F2F2F2",
    line = "#2A2D2E",
    visual = "#3A3D41",
    comment = "#767676",
  }

  vim.g.colors_name = "campbell"
  vim.o.background = "dark"

  vim.g.terminal_color_0 = c.black
  vim.g.terminal_color_1 = c.red
  vim.g.terminal_color_2 = c.green
  vim.g.terminal_color_3 = c.yellow
  vim.g.terminal_color_4 = c.blue
  vim.g.terminal_color_5 = c.magenta
  vim.g.terminal_color_6 = c.cyan
  vim.g.terminal_color_7 = c.white
  vim.g.terminal_color_8 = c.bright_black
  vim.g.terminal_color_9 = c.bright_red
  vim.g.terminal_color_10 = c.bright_green
  vim.g.terminal_color_11 = c.bright_yellow
  vim.g.terminal_color_12 = c.bright_blue
  vim.g.terminal_color_13 = c.bright_magenta
  vim.g.terminal_color_14 = c.bright_cyan
  vim.g.terminal_color_15 = c.bright_white

  local set = vim.api.nvim_set_hl
  set(0, "Normal", { fg = c.fg, bg = c.bg })
  set(0, "NormalNC", { fg = c.fg, bg = c.bg })
  set(0, "Comment", { fg = c.comment, italic = true })
  set(0, "Constant", { fg = c.cyan })
  set(0, "String", { fg = c.yellow })
  set(0, "Character", { fg = c.yellow })
  set(0, "Number", { fg = c.bright_magenta })
  set(0, "Boolean", { fg = c.bright_magenta, bold = true })
  set(0, "Identifier", { fg = c.bright_blue })
  set(0, "Function", { fg = c.bright_cyan })
  set(0, "Statement", { fg = c.bright_red })
  set(0, "Keyword", { fg = c.bright_red })
  set(0, "Type", { fg = c.bright_green })
  set(0, "PreProc", { fg = c.magenta })
  set(0, "Special", { fg = c.bright_yellow })
  set(0, "Operator", { fg = c.fg })
  set(0, "Delimiter", { fg = c.fg })
  set(0, "Error", { fg = c.bright_white, bg = c.red })
  set(0, "Todo", { fg = c.bg, bg = c.yellow, bold = true })

  set(0, "Cursor", { fg = c.bg, bg = c.cursor })
  set(0, "CursorLine", { bg = c.line })
  set(0, "CursorColumn", { bg = c.line })
  set(0, "LineNr", { fg = c.bright_black })
  set(0, "CursorLineNr", { fg = c.bright_white, bold = true })
  set(0, "SignColumn", { bg = c.bg })
  set(0, "ColorColumn", { bg = c.line })
  set(0, "VertSplit", { fg = c.line, bg = c.bg })
  set(0, "WinSeparator", { fg = c.line, bg = c.bg })

  set(0, "Visual", { bg = c.visual })
  set(0, "Search", { fg = c.bg, bg = c.bright_yellow })
  set(0, "IncSearch", { fg = c.bg, bg = c.bright_cyan })
  set(0, "Pmenu", { fg = c.fg, bg = c.line })
  set(0, "PmenuSel", { fg = c.bg, bg = c.blue })
  set(0, "StatusLine", { fg = c.fg, bg = c.line })
  set(0, "StatusLineNC", { fg = c.bright_black, bg = c.line })

  set(0, "DiagnosticError", { fg = c.bright_red })
  set(0, "DiagnosticWarn", { fg = c.bright_yellow })
  set(0, "DiagnosticInfo", { fg = c.bright_blue })
  set(0, "DiagnosticHint", { fg = c.bright_cyan })
  set(0, "DiagnosticVirtualTextError", { fg = c.bright_red, bg = c.bg })
  set(0, "DiagnosticVirtualTextWarn", { fg = c.bright_yellow, bg = c.bg })
  set(0, "DiagnosticVirtualTextInfo", { fg = c.bright_blue, bg = c.bg })
  set(0, "DiagnosticVirtualTextHint", { fg = c.bright_cyan, bg = c.bg })
end

set_campbell()


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
    { name = 'latex_symbols', option = { strategy = 0 } },
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

vim.lsp.config.texlab = {
  capabilities = capabilities,
  settings = {
    texlab = {
      build = {
        executable = 'latexmk',
        args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
        onSave = false,  -- VimTeX handles this
      },
      forwardSearch = {
        executable = 'zathura',
        args = { '--synctex-forward', '%l:1:%f', '%p' },
      },
    },
  },
}

-- enable all the servers configured above
vim.lsp.enable({
  "lua_ls",
  "pyright",
  "clangd",
  "ts_ls",
  "rust_analyzer",
  "texlab",
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
