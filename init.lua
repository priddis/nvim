--[[
---- Wishlist ---- JDTLS config
mj autoimport
  go to definition gpb proto
  quickfix
  debug
hello
shada to save sessions + leader key shortcut
unit test snippet
restructure dot files git blame
highlight reassigned variables
reverse J motion
]]
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.zig_fmt_autosave = 0
vim.keymap.set({ 'n', 'v' }, 'w', function() return vim.fn.search([[\<]]) end, { silent = true, noremap = true })
vim.keymap.set({ 'n', 'v' }, 'b', function() return vim.fn.search([[\<]], "b") end, { silent = true, noremap = true })
--Enable escape for terminal mode
vim.keymap.set({ 't' }, '<esc>', [[<C-\><C-N>]], { silent = true, noremap = true })

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
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "neovim/nvim-lspconfig" },
  { 'folke/which-key.nvim',   opts = {}, }, -- Shows keybinds
  { 'nvim-treesitter/nvim-treesitter',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects', 'nvim-treesitter/nvim-treesitter-context', 'nvim-treesitter/nvim-treesitter-refactor'  },
    build = ':TSUpdate', }, --
  { 'nvim-treesitter/playground' }, --debug for treesitter based development
  { 'ibhagwan/fzf-lua' }, --search
  { 'echasnovski/mini.completion', version = false }, --completion
  { 'sindrets/diffview.nvim' },
}, {})
vim.cmd([[colorscheme catppuccin]])

--require('status')
vim.cmd.set('splitright')
vim.wo.relativenumber = true
vim.wo.number = true
vim.o.mouse = 'a'        --enable mouse for all modes
vim.o.breakindent = true --word wrap lines are indented
vim.o.undofile = true    --save undo history
vim.o.hlsearch = false
vim.o.incsearch = true   --show results while typing
vim.o.ignorecase = true  -- Case insensitive search
vim.o.smartcase = true
vim.wo.signcolumn = 'no' -- keep sign column
vim.o.updatetime = 200  -- Time to write swp to disk
vim.o.timeout = true
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true --24bit RGB in TUI
vim.o.autoread = true      --Load file changes automatically
vim.o.shortmess = 'aoO'    -- Use abbreviations for shorter messages
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
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

vim.keymap.set('n', '<leader><space>', require('fzf-lua').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', require('fzf-lua').lgrep_curbuf, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>/', require('fzf-lua').lgrep_curbuf, { desc = '[/] Fuzzily search in current buffer' })

-- start insert mode when moving to a terminal window
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
  callback = function()
    if vim.bo.buftype == 'terminal' then vim.cmd('startinsert') end
  end,
  group = vim_term
})

-- highlight yanked text
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end, group = highlight_group, pattern = '*', })

--Remove annoying default format options
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Disable automatic comment insertion",
  group = vim.api.nvim_create_augroup("AutoComment", {}),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    vim.opt_local.formatoptions:append("t")
  end,
})

vim.defer_fn(function() 
require('nvim-treesitter.configs').setup {
  ensure_installed = { 'zig', 'bash', 'c', 'cpp', 'go', 'lua', 'java', 'vimdoc', 'vim' },
  auto_install = false,
  highlight = { enable = true, disable = function(lang, bufnr) return vim.api.nvim_buf_line_count(bufnr) > 50000 end },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = { enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  refactor = {
    highlight_definitions = { enable = true, clear_on_cursor_move = true, disable = function(lang, bufnr) return vim.api.nvim_buf_line_count(bufnr) > 4000 end },
    smart_rename = { enable = true, keymaps = { smart_rename = "<leader>r", }, },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj
      keymaps = {
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
        [']]'] = '@class.outer', },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer', },
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
end, 0)
require('treesitter-context')
vim.cmd([[highlight TreesitterContextBottom gui=underline guisp=Grey]])

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    require('mini.completion').setup()
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf, desc = '[g]oto [d]efinition'})
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = ev.buf, desc = '[g]oto [D]eclaration'})
    vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { buffer = ev.buf, desc = '[g]oto [I]mplementation' })
    vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, { buffer = ev.buf, desc = '[g]oto [r]eferences' })
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { buffer = ev.buf, desc = 'Type [D]efinition' })
  end,
})
-- vim: ts=2 sts=2 sw=2 et
