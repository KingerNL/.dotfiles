call plug#begin('~/.local/share/nvim/plugged')

Plug 'tpope/vim-sensible'

" Copilot and coc for autocompletion
Plug 'github/copilot.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" File explorer
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons' " Optional: file icons (requires patched font)

" themes for nvim
Plug 'morhetz/gruvbox'
Plug 'sainnhe/gruvbox-material'

" Treesitter core plugin
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

let g:python3_host_prog = '/usr/bin/python3'

" Dropbar
Plug 'Bekaboo/dropbar.nvim'

" comment out code
Plug 'numToStr/Comment.nvim'

" Bufferline (tab bar)
Plug 'akinsho/bufferline.nvim', { 'tag': '*' }

Plug 'MunifTanjim/nui.nvim'
Plug 'folke/noice.nvim'

Plug 'gelguy/wilder.nvim'

call plug#end()

" Set color scheme
set termguicolors
colorscheme gruvbox-material

" Override bufferline background color after colorscheme is applied
highlight BufferLineFill guibg=#2c2c2c

" Enable mouse support
set mouse=a

" Enable line numbers
let mapleader = " "
set showtabline=2
set number

" use the system clipboard for yank, delete, change, and put operations
set clipboard=unnamedplus

augroup RestoreCursorShapeOnExit
    autocmd!
    autocmd VimLeave * set guicursor=a:ver26 
augroup END

" Enable wrap-around for arrow keys (similar to VSCode)
set whichwrap+=<,>,[,]

let g:coc_disable_startup_warning = 1

" Map Ctrl+A to select all text
nnoremap <C-a> ggVG

" Map Ctrl+C to yank selected text to system clipboard
vnoremap <C-c> "+y

" Ctrl+X cuts selection to system clipboard
vnoremap <C-x> "+d

" Ctrl+X cuts the current line if nothing is selected
nnoremap <C-x> "+dd

" Shift+Arrow keys for visual selection like in VSCode
nnoremap <S-Up> v<Up>
nnoremap <S-Down> v<Down>
nnoremap <S-Left> v<Left>
nnoremap <S-Right> v<Right>

xnoremap <S-Up> <Up>
xnoremap <S-Down> <Down>
xnoremap <S-Left> <Left>
xnoremap <S-Right> <Right>

" Exit visual mode and move cursor with arrow keys
xnoremap <Up> <Esc>k
xnoremap <Down> <Esc>j
xnoremap <Left> <Esc>h
xnoremap <Right> <Esc>l

" Disable CoC handling of <Tab>
inoremap <silent><expr> <Tab> "\<Tab>"

" Accept CoC completion with Enter
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"

" Map Ctrl + / for normal mode (toggle current line)
nnoremap <C-_> :lua require('Comment.api').toggle.linewise.current()<CR>
"
" Map Ctrl + / for visual mode (toggle selection)
xnoremap <C-_> :lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>

" Enable nvim-tree
lua << EOF
require("nvim-tree").setup({
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

-- Dropbar setup
require("dropbar").setup()

-- comment out code
require('Comment').setup()

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

local wilder = require('wilder')
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

-- bufferline (tab bar)
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
EOF

