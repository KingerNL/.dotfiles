vim.o.termguicolors = true
vim.o.mouse = 'a'
vim.o.number = true
vim.o.clipboard = 'unnamedplus'
vim.o.whichwrap = vim.o.whichwrap .. '<,>,[,]'

vim.opt.nu = true
vim.opt.relativenumber  = true
vim.opt.cursorline = true
vim.api.nvim_set_hl(0, 'LineNr', { fg='#5A524C' })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#EC4935", bold = true })

-- Indentation settings, just set tabstop=4 in init.lua
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.o.showtabline = 2

-- not highlight all the search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- nicely scrolling
vim.opt.scrolloff = 8

-- faster update time
vim.opt.updatetime = 50

-- Leader key
vim.g.mapleader = ' '



