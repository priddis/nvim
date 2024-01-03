--[[
---- Wishlist ---- JDTLS config
mj autoimport
  go to definition gpb proto
  quickfix
  debug
hello
shada to save sessions + leader key shortcut
unit test snippet
restructure dot files
git blame
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

--require('vim.lsp.log').set_format_func(vim.inspect)

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
  { 'neovim/nvim-lspconfig'},
  { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'hrsh7th/nvim-cmp', dependencies = { 'hrsh7th/cmp-nvim-lsp', "L3MON4D3/LuaSnip" } },
  { 'folke/which-key.nvim',   opts = {}, }, -- Shows keybinds
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = function() return vim.fn.executable 'make' == 1 end, },
  { 'nvim-treesitter/nvim-treesitter',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects', 'nvim-treesitter/nvim-treesitter-context', 'nvim-treesitter/nvim-treesitter-refactor'  },
    build = ':TSUpdate', },
  { 'nvim-treesitter/playground' },
}, {})
vim.cmd([[colorscheme catppuccin]])


--require('status')
vim.cmd.set('splitright')
vim.wo.relativenumber = false
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
vim.o.formatoptions = 't'

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
--format on save
--vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
--vim.cmd [[autocmd WinNew * wincmd L]]

-- highlight yanked text
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end, group = highlight_group, pattern = '*', })

require('telescope').setup { defaults = { path_display = { "tail" } }, }

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function() require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    previewer = false, }) end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [g]it [f]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[s]earch [f]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[s]earch [h]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[s]earch current [w]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[s]earch by [g]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[s]earch [d]iagnostics' })
vim.keymap.set('n', '<leader>sm', function() require("telescope.builtin").treesitter( {symbols = {"method", "function"}}) end, { desc = '[s]earch [m]ethods' })

vim.defer_fn(function() 
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
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
    smart_rename = { enable = true, keymaps = { smart_rename = "grr", }, },
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
        [']]'] = '@class.outer', },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer', },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer', },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer', },
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
require'treesitter-context'
vim.cmd([[highlight TreesitterContextBottom gui=underline guisp=Grey]])
--
-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

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
  keyword_length = 5,
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    --['<C-Space>'] = cmp.mapping.complete {},
    ['<C-Space>'] = cmp.mapping.confirm {
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
    {
      name = "buffer",
      keyword_length = 5
    }
  },
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end
        vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[r]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction')
    nmap('gd', vim.lsp.buf.definition, '[g]oto [d]efinition')
    nmap('gD', vim.lsp.buf.declaration, '[g]oto [D]eclaration')
    nmap('gI', vim.lsp.buf.implementation, '[g]oto [I]mplementation')
    nmap('gr', require('telescope.builtin').lsp_references, '[g]oto [r]eferences')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[d]ocument [s]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[w]orkspace [s]ymbols')
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Create a command `:Format` local to the LSP buffer
    --vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        --vim.lsp.buf.format()
    --end, { desc = 'Format current buffer with LSP' })
  end
})
--
-- vim: ts=2 sts=2 sw=2 et
