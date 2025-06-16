-- ~/.config/nvim/lua/core/plugins.lua

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

-- Auto-reload and sync when plugins.lua is saved
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Your other plugins here
  use 'tpope/vim-sensible'
  use 'github/copilot.vim'
  use {'neoclide/coc.nvim', branch = 'release'}
  use 'nvim-tree/nvim-tree.lua'
  use 'nvim-tree/nvim-web-devicons'
  use 'morhetz/gruvbox'
  use 'sainnhe/gruvbox-material'
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use 'Bekaboo/dropbar.nvim'
  use 'MunifTanjim/nui.nvim'
  use 'folke/noice.nvim'
  use {'akinsho/bufferline.nvim', tag = '*'}
  use 'numToStr/Comment.nvim'
  use 'gelguy/wilder.nvim'

  -- Only sync if this is a fresh install
  if packer_bootstrap then
    require('packer').sync()
  end
end)

