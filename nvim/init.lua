-- Set Python provider
vim.g.python3_host_prog = '/usr/bin/python3'

-- Leader key
vim.g.mapleader = ' '

-- Core configs
require('core.options')
require('core.keymaps')
require('core.autocmds')
require('core.plugins')  -- Packer plugin list

-- Plugin setups
require('plugins.nvim-tree')
require('plugins.comment')
require('plugins.bufferline')
require('plugins.noice')
require('plugins.dropbar')
require('plugins.wilder')

-- Colorscheme
vim.cmd('colorscheme gruvbox-material')
vim.cmd('highlight BufferLineFill guibg=#2c2c2c')

