local gitdir = vim.fs.dirname(vim.fs.find('.git', { type = 'directory', upward = true, stop = vim.loop.os_homedir()})[1])
local client = vim.lsp.start({
    name = 'mlsp',
    cmd = {'/home/micah/code/lsp/zig-out/bin/lsp'},
    root_dir = gitdir
  })

local ns = vim.api.nvim_create_namespace "reassigned_namespace"
local ts = require('nvim-treesitter')
local ts_utils = require('nvim-treesitter.ts_utils')

vim.cmd([[highlight link ReassignedVariables Underlined]])

local underline_reassignments = vim.api.nvim_create_augroup('underline_reassignments', {})
local assigned_vars = vim.treesitter.query.parse("java", [[(assignment_expression left: (identifier) @assigned) ]])

vim.api.nvim_create_autocmd({ 'WinScrolled', 'BufEnter', 'BufWritePost' }, {
    group = underline_reassignments,
    desc = 'underline reassigned vars',
    callback = function()
        if ts ~= nil then
            local bufnr = vim.api.nvim_get_current_buf() 
            local height = vim.api.nvim_win_get_height(0)
            local cursor = vim.fn.getcurpos()
            local start = math.max(cursor[2] - vim.fn.winline() - 5, 1)
            local max_line = vim.fn.line('$')
            local endl = math.min(start + height + 5, max_line)
            --
            -- Clearing the namespace removes the underline
            vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
            -- Query for identifiers on the left hand side of an assignment. This does not include declarations.
            local parser = vim.treesitter.get_parser(bufnr, "java", {})
            local tree = parser:parse()[1]
            local root = tree:root()
            local word_set = {}
            for id, node in assigned_vars:iter_captures(root, bufnr, 0, -1) do
              local id_text = vim.treesitter.get_node_text(node, bufnr)
              if word_set[id_text] == nil then
                    word_set[id_text] = true
              end
            end

            s = ""
            for k, _ in pairs(word_set) do 
                s = s .. k .. " "
            end

            -- Query again for identifiers that are in the word list and filter out method declarations
            local query = [[( (identifier) @id (#any-of? @id ]] .. s .. [[) (#not-has-parent? @id method_declaration class_declaration))]]
            local reassigned_vars = vim.treesitter.query.parse("java", query)
            
            for id, node in reassigned_vars:iter_captures(root, bufnr, start, endl) do
              ts_utils.highlight_node(node, bufnr, ns, "ReassignedVariables")
            end
        end
    end,
})
