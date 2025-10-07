-- ~/.config/nvim/lua/plugins/autopairs.lua

local npairs = require("nvim-autopairs")

npairs.setup({
  check_ts = true,
  fast_wrap = {},
})

-- Delete any default <CR> mappings to avoid conflict
vim.api.nvim_del_keymap("i", "<CR>")

-- Custom <CR> mapping for CoC completion
vim.api.nvim_set_keymap("i", "<CR>",
  [[coc#pum#visible() ? coc#pum#confirm() : "\<CR>"]],
  { expr = true, noremap = true, silent = true })

