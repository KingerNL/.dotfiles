local keymap = vim.keymap.set

-- Yank/Copy
keymap('n', '<C-a>', 'ggVG')
keymap('v', '<C-c>', '"+y')
keymap('v', '<C-x>', '"+d')
keymap('n', '<C-c>', '"+yy')
keymap('n', '<C-x>', '"+dd')

-- Visual mode movement
keymap('n', '<S-Up>', 'v<Up>')
keymap('n', '<S-Down>', 'v<Down>')
keymap('n', '<S-Left>', 'v<Left>')
keymap('n', '<S-Right>', 'v<Right>')

keymap('x', '<S-Up>', '<Up>')
keymap('x', '<S-Down>', '<Down>')
keymap('x', '<S-Left>', '<Left>')
keymap('x', '<S-Right>', '<Right>')

keymap('x', '<Up>', '<Esc>k')
keymap('x', '<Down>', '<Esc>j')
keymap('x', '<Left>', '<Esc>h')
keymap('x', '<Right>', '<Esc>l')

-- Tab/Shift+Tab indent
keymap("v", "<Tab>", ">gv", { noremap = true, silent = true })
keymap("v", "<S-Tab>", "<gv", { noremap = true, silent = true })
keymap("n", "<Tab>", ">>", { noremap = true, silent = true })
keymap("n", "<S-Tab>", "<<", { noremap = true, silent = true })
keymap("x", "<S-Tab>", "<<", { noremap = true, silent = true })

-- clears search highlight
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })


-- Comment keymap (with Copilot-safe bind)
keymap('n', '<C-_>', function()
  require('Comment.api').toggle.linewise.current()
end, { noremap = true, silent = true })

keymap('v', '<C-_>', function()
  local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
  vim.api.nvim_feedkeys(esc, 'x', false)
  require('Comment.api').toggle.linewise(vim.fn.visualmode())
end, { noremap = true, silent = true })

-- Use <CR> to confirm completion, or insert newline if no suggestion is visible
vim.api.nvim_create_autocmd("User", {
  pattern = "CocJumpPlaceholder",
  callback = function()
    vim.api.nvim_set_keymap("i", "<CR>",
      [[coc#pum#visible() ? coc#pum#confirm() : "\<CR>"]],
      { noremap = true, silent = true, expr = true }
    )
  end
})

