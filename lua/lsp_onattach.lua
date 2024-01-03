local on_attach = function(client, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
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

return on_attach
