local a = vim.lsp.start({
    name = 'mlsp',
    cmd = {'/home/micah/bin/zls'},
    root_dir = '/home/micah/code/lsp/',
    on_attach = require('lsp_onattach')
  })
local b = vim.lsp.buf_attach_client(0,a)

