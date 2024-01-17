require('base')
require('highlights')
require('maps')
require('plugins')
require('gitsigns').setup {}

local has = function(x)
  return vim.fn.has(x) == 1
end

local nvim_lsp = require "lspconfig"
nvim_lsp.tailwindcss.setup {}
