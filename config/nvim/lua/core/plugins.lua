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
	use 'wbthomason/packer.nvim'                 -- Plugin manager
	use 'tpope/vim-sensible'                     -- Sensible default settings
	use 'nvim-tree/nvim-tree.lua'                -- File explorer sidebar
	use 'nvim-tree/nvim-web-devicons'            -- Icons for files and folders
	use 'sainnhe/gruvbox-material'               -- Gruvbox color scheme (modern and richer)
	use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'} -- Better syntax highlighting and parsing
	use 'Bekaboo/dropbar.nvim'                   -- Smart breadcrumbs/status bar for navigation
	use 'MunifTanjim/nui.nvim'                   -- UI component library used by other plugins
	use 'folke/noice.nvim'                       -- Better UI for messages, cmdline, and LSP
	use 'karb94/neoscroll.nvim'                  -- Smooth scrolling animations
	use {'akinsho/bufferline.nvim', tag = '*'}   -- Tab-like buffer management bar
	use 'gelguy/wilder.nvim'                     -- Enhanced command-line autocomplete UI
	use 'nvim-lualine/lualine.nvim'              -- Statusline with mode, git, diagnostics, etc.
	use 'lewis6991/gitsigns.nvim'                -- Git change indicators in the gutter (add, modify, delete)
	use 'folke/which-key.nvim'                   -- Popup showing available keybindings
	use 'windwp/nvim-autopairs'                  -- Auto-insert pairs of brackets, quotes, etc.
	use 'norcalli/nvim-colorizer.lua'            -- Highlight color codes with their actual color
	use 'goolord/alpha-nvim'                     -- Welcome/startup dashboard screen
	use 'folke/todo-comments.nvim'               -- Highlight and manage TODO comments

	-- Completion (blink)
	use(require("plugins.blink"))
	

	use {
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim" },
	}

	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})


	-- Only sync if this is a fresh install
	if packer_bootstrap then
		require('packer').sync()
	end
end)
