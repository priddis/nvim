--[[
---- Wishlist ----
JDTLS config
  autoimport
  go to definition gpb proto
  signature help https://github.com/mfussenegger/nvim-jdtls/discussions/124
  current method name in status bar
  methods as text objects
  customize warnings
  symbols outline?
  quickfix
  debug

telescope list methods in file
git branch in status bar
shada to save sessions + leader key shortcut
unit test snippet
restructure dot files
git blame
notifications?
highlight reassigned variables

https://sookocheff.com/post/vim/neovim-java-ide/
https://github.com/antonk52/bad-practices.nvim
]]
--https://github.com/m4xshen/hardtime.nvim


vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { "mfussenegger/nvim-jdtls" },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim' }
  },                                                                                           --Fuzzyfinder
  { 'hrsh7th/nvim-cmp',       dependencies = { 'hrsh7th/cmp-nvim-lsp', "L3MON4D3/LuaSnip" } }, --autocomplete and autocomplete source from lsp,
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
  --{'tpope/vim-sleuth' }, --Detect tabstop and shiftwidth automatically. Probably not needed.
  { 'folke/which-key.nvim', opts = {}, }, -- Shows keybinds
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true }, --Automatic lsp install
      'williamboman/mason-lspconfig.nvim',
      { 'folke/neodev.nvim',       opts = {} }
    },
  },
  --{'lewis6991/gitsigns.nvim', -- Adds symbols in gutter for git diff
  --  opts = {
  --    signs = {
  --      add = { text = '+' },
  --      change = { text = '~' },
  --      delete = { text = '_' },
  --      topdelete = { text = '‾' },
  --      changedelete = { text = '~' },
  --    },
  --    on_attach = function(bufnr)
  --      vim.keymap.set('n', '[c', require('gitsigns').prev_hunk, { buffer = bufnr, desc = 'Go to Previous Hunk' })
  --      vim.keymap.set('n', ']c', require('gitsigns').next_hunk, { buffer = bufnr, desc = 'Go to Next Hunk' })
  --      vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
  --    end,
  --  },
  --},
}, {})

vim.cmd.colorscheme 'ron'
vim.wo.relativenumber = true
vim.wo.number = true
vim.o.mouse = 'a'        --enable mouse for all modes
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true --word wrap lines are indented
vim.o.undofile = true    --save undo history
vim.o.hlsearch = false
vim.o.incsearch = true   --show results while typing
vim.o.ignorecase = true  -- Case insensitive search
vim.o.smartcase = true
vim.wo.signcolumn = 'no' -- keep sign column
vim.o.updatetime = 250   -- Time to write swp to disk
vim.o.timeout = true
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true --24bit RGB in TUI
vim.o.autoread = true      --Load file changes automatically
vim.o.shortmess =
'aoO'                      -- Use abbreviations for shorter messages
vim.o.jumpoptions = 'stack'
vim.o.wildignore =
".git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**" --ignore for diff mode
vim.o.shada = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.wrap = true
vim.o.scrolloff = 8 -- Number of lines above/below cursor when scrolling
vim.o.cmdwinheight = 1
vim.o.cmdheight = 0
--vim.o.colorcolumn = ""

--status line
vim.opt.statusline = "%#Normal#%=%t"

--TODO what does this do
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]


local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }) -- highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
    path_display = { "tail" }
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`

require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'java', 'vimdoc', 'vim' },

  auto_install = false,
  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

local servers = {
  --Language servers to install with mason
  clangd = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  --customConfiguration means don't use lspconfig. config is in ftplugin/java.lua
  jdtls = { customConfiguration = true }
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    if servers[server_name] and not servers[server_name].customConfiguration then
      require('lspconfig')[server_name].setup {
        capabilities = capabilities,
        on_attach = require("lsp_onattach"),
        settings = servers[server_name],
      }
    end
  end,
}

-- nvim-cmp setup
local cmp = require('cmp')
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },
  sources = {
    {
      name = 'nvim_lsp',
      entry_filter = function(entry, ctx)
        local kind = require('cmp.types').lsp.CompletionItemKind[entry:get_kind()]

        if kind == "Text" then return false end
        return true
      end
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
