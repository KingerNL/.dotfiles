-- Set Python provider
vim.g.python3_host_prog = '/usr/bin/python3'

-- Leader key
vim.g.mapleader = ' '

-- Core configs
require('core.options')        -- Sets editor options (line numbers, tabs, etc.)
require('core.keymaps')        -- Defines custom keybindings
require('core.autocmds')       -- Adds autocommands (startup, auto-format, highlights, etc.)
require('core.plugins')        -- Lists and installs plugins via packer.nvim

-- Plugin setups
require('plugins.alpha')       -- Startup dashboard 
require('plugins.comment')     -- Adds `gc` and similar keybindings to comment code 
require('plugins.bufferline')  -- Visual tabs for open buffers 
require('plugins.noice')       -- Better UI for messages, command line, and LSP 
require('plugins.dropbar')     -- Context-aware breadcrumb bar 
require('plugins.wilder')      -- Improved command-line UI with fuzzy matching )
require('plugins.neoscroll')   -- Smooth scrolling animations 
require('plugins.lualine')     -- Customizable status line 
require('plugins.gitsigns')    -- Git diff markers + inline blame 
require("plugins.autopairs")   -- Automatically close brackets/quotes 
require("plugins.nvim-tree")   -- File explorer panel on the left 
require("plugins.which-key")   -- Shows available keybindings in a popup 
require('plugins.treesitter')  -- Better syntax highlighting and code parsing

-- Colorscheme
vim.cmd('colorscheme gruvbox-material')
vim.cmd('highlight BufferLineFill guibg=#2c2c2c')

-- Indentation settings, just set tabstop=4 in init.lua
vim.opt["tabstop"] = 4
vim.opt["shiftwidth"] = 4
-- vim.o.expandtab = true       -- Use spaces instead of tabs
-- vim.o.shiftwidth = 4         -- Number of spaces to use for each step of (auto)indent
-- vim.o.softtabstop = 4        -- Number of spaces that a <Tab> counts for while performing editing operations
