require'nvim-treesitter.configs'.setup {
	auto_install = true
  ensure_installed = { "cpp", "c", "lua", "python", "bash" }, -- install C++ and others
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
