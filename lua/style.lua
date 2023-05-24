require('onedark').setup({

  style = 'light',
  colors = {
    white = '#FFFFFF',
    gray = '#8C8C8C',
    blue = '#0033B3',
    lightblue = '268BD2',
    green = '#067017',
    cyan = '#006271',
    red = '#FF0000',
    orange = '#B97634',
    yellow = '#9E880D',
    purple = '#871094',
    magenta = '#D16D9E'
  },
  highlights = {
    ["@keyword"] = { fg = '$blue' },
    ["@string"] = { fg = '$green', fmt = 'italic' },
    ["@function"] = { fg = 'lightblue' },
    ["@constant"] = { fg = '$purple' },
    ["@parameter"] = { fg = '$orange' },
    ["@annotation"] = { fg = '$yellow' },
  }

})

vim.cmd.colorscheme 'onedark'
vim.opt.background = 'light'
