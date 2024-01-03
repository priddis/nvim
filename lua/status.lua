--https://zignar.net/2022/01/21/a-boring-statusline-for-neovim/

--Autocommand to get git branch if it exists
local get_branch = vim.api.nvim_create_augroup('get_branch', {})
vim.api.nvim_create_autocmd({ 'BufRead' }, {
    group = get_branch,
    desc = 'git branch',
    callback = function()
        local branch = vim.fn.system "git branch --show-current"
        if vim.v.shell_error ~= 0 then
            vim.b.current_branch = ''
            return
        end
        vim.b.current_branch = string.gsub(branch, "\n", "")
    end,
})

local function strip_keywords(line)
    line = string.gsub(line, "class", "")
    line = string.gsub(line, "public", "")
    line = string.gsub(line, "static", "")
    line = string.gsub(line, "private", "")
    line = string.gsub(line, "throws", "")
    return line
end

local highlight_reassignments = vim.api.nvim_create_augroup('highlight_reassignments', {})
vim.api.nvim_create_autocmd({ 'CursorHold' }, {
    group = highlight_reassignments
    desc = 'highlight reassigned vars',
    callback = function()
        local ts = require('nvim-treesitter')
        if ts ~= nil then
            local bufnr = vim.api.nvim_get_current_buf()
            local parser = vim.treesitter.get_parser(bufnr, "java", {})
            local tree = parser:parse()[1]
            local root = tree:root()
            --ts.highlight_node(node, buf, hl_namespace, hl_group)
            local status = ts.statusline()
            if status ~= nil then
                status = strip_keywords(status)
                vim.b.breadcrumbs = status
            end
        end
    end,
})

function BUILDSTATUS()
    local breadcrumbs = ''
    if vim.b.breadcrumbs ~= nil then
        breadcrumbs = '% ' .. vim.b.breadcrumbs
    end
    local branch_name = ''
    if vim.b.current_branch ~= nil then
        branch_name = '% ' .. vim.b.current_branch
    end
    return table.concat {
        breadcrumbs,
        ' %=', --Everything after is right aligned
        branch_name,
        ' %t'  --Displays current file
    }
end

--vim.opt.statusline = [[%!v:lua.BUILDSTATUS()]]
