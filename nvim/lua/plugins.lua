-- ~/.config/nvim/lua/plugins.lua

-- Auto-install packer.nvim if not installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Reload Neovim whenever you save this file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Plugin list
return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Sensible defaults
  use 'tpope/vim-sensible'

  -- Copilot and coc.nvim
  use 'github/copilot.vim'
  use {'neoclide/coc.nvim', branch = 'release'}

  -- File explorer
  use 'nvim-tree/nvim-tree.lua'
  use 'nvim-tree/nvim-web-devicons'

  -- Themes
  use 'morhetz/gruvbox'
  use 'sainnhe/gruvbox-material'

  -- Treesitter
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

  -- UI Enhancements
  use 'Bekaboo/dropbar.nvim'
  use 'MunifTanjim/nui.nvim'
  use 'folke/noice.nvim'
  use {'akinsho/bufferline.nvim', tag = '*'}

  -- Commenting
  use 'numToStr/Comment.nvim'

  -- Wilder (requires Python3 and pynvim)
  use 'gelguy/wilder.nvim'

  if packer_bootstrap then
    require('packer').sync()
  end
end)
