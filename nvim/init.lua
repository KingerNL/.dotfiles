-- ~/.config/nvim/init.lua

-- Set Python3 provider (adjust path if needed)
vim.g.python3_host_prog = '/usr/bin/python3'

-- Set leader key
vim.g.mapleader = ' '

-- Packer plugin manager setup (replace with vim-plug if you prefer that)
-- If you don't have packer installed:
-- git clone --depth 1 https://github.com/wbthomason/packer.nvim\
-- ~/.local/share/nvim/site/pack/packer/start/packer.nvim

require('plugins')

-- General settings
vim.o.termguicolors = true
vim.o.mouse = 'a'
vim.o.number = true
vim.o.clipboard = 'unnamedplus'
vim.o.showtabline = 2
vim.o.whichwrap = vim.o.whichwrap .. '<,>,[,]'

-- Keymaps
vim.keymap.set('n', '<C-a>', 'ggVG')
vim.keymap.set('v', '<C-c>', '"+y')
vim.keymap.set('v', '<C-x>', '"+d')
vim.keymap.set('n', '<C-c>', '"+yy')
vim.keymap.set('n', '<C-x>', '"+dd')

-- Visual mode movement like VSCode
vim.keymap.set('n', '<S-Up>', 'v<Up>')
vim.keymap.set('n', '<S-Down>', 'v<Down>')
vim.keymap.set('n', '<S-Left>', 'v<Left>')
vim.keymap.set('n', '<S-Right>', 'v<Right>')

vim.keymap.set('x', '<S-Up>', '<Up>')
vim.keymap.set('x', '<S-Down>', '<Down>')
vim.keymap.set('x', '<S-Left>', '<Left>')
vim.keymap.set('x', '<S-Right>', '<Right>')

vim.keymap.set('x', '<Up>', '<Esc>k')
vim.keymap.set('x', '<Down>', '<Esc>j')
vim.keymap.set('x', '<Left>', '<Esc>h')
vim.keymap.set('x', '<Right>', '<Esc>l')

-- Cursor fix on exit
vim.api.nvim_create_autocmd('VimLeave', {
  callback = function()
    vim.opt.guicursor = 'a:ver26'
  end
})

-- Colorscheme
vim.cmd('colorscheme gruvbox-material')
vim.cmd('highlight BufferLineFill guibg=#2c2c2c')

-- Plugin setups
require('nvim-tree').setup({
  view = {
    width = 30,
    side = "left",
    preserve_window_proportions = true,
  },
  renderer = {
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
    },
  },
  git = {
    enable = true,
  },
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("nvim-tree.api").tree.open()
  end,
})

require("dropbar").setup()
require("Comment").setup()
require("bufferline").setup({
  options = {
    offsets = {
      {
        filetype = "NvimTree",
        text = "",
        padding = 1
      }
    }
  }
})

require("noice").setup({
  cmdline = {
    view = "cmdline",
    format = {
      cmdline = { icon = "", title = "Command" },
    },
  },
  messages = {
    enabled = true,
  },
  popupmenu = {
    enabled = true,
  },
  lsp = {
    progress = { enabled = false },
    hover = { enabled = false },
    signature = { enabled = false },
  },
})

-- Wilder setup (Python check)
if vim.fn.has('python3') == 1 then
  local ok, wilder = pcall(require, 'wilder')
  if ok then
    wilder.setup({ modes = {':', '/', '?'} })
    wilder.set_option('renderer', wilder.popupmenu_renderer(
      wilder.popupmenu_border_theme({
        border = 'rounded',
        highlights = {
          border = 'Normal',
          accent = 'Statement',
        },
        highlighter = wilder.basic_highlighter(),
      })
    ))
  else
    vim.notify("wilder.nvim not available", vim.log.levels.WARN)
  end
else
  vim.notify("Python3 not available for Neovim", vim.log.levels.ERROR)
end

