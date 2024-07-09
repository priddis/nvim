local zls_path = '/var/home/mp/.local/opt/zls/zig-out/bin/zls'
local client_capabilities = vim.lsp.protocol.make_client_capabilities()
client_capabilities.textDocument["semanticTokens"] = nil
local a = vim.lsp.start({
    name = 'lsp',
    cmd = {zls_path},
    root_dir = vim.fn.getcwd(),
    capabilities = client_capabilities
  })
local b = vim.lsp.buf_attach_client(0,a)

