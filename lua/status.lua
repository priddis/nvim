--https://zignar.net/2022/01/21/a-boring-statusline-for-neovim/
local M = {}

--Autocommand to get git branch if it exists
local get_branch = vim.api.nvim_create_augroup('get_branch', {})
vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'FocusGained' }, {
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

function M.buildstatus()
    local breadcrumbs = ''
    local ts = require('nvim-treesitter')
    if ts ~= nil and ts.statusline() ~= nil then
        breadcrumbs = '% ' .. ts.statusline()
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

return M
