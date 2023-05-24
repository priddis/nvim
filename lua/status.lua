--https://zignar.net/2022/01/21/a-boring-statusline-for-neovim/
local M = {}
function M.statusline()
  local parts = {
   [[%{luaeval("require'me'.diagnostic_status()")}]],
  }
  return table.concat(parts, '')
end


function M.diagnostic_status()
  -- count the number of diagnostics with severity warning
  local num_errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  -- If there are any errors only show the error count, don't include the number of warnings
  if num_errors > 0 then
    return ' 💀 ' .. num_errors .. ' '
  end
  -- Otherwise show amount of warnings, or nothing if there aren't any.
  local num_warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  if num_warnings > 0 then
    return ' 💩' .. num_warnings .. ' '
  end
  return ''
end

return M
