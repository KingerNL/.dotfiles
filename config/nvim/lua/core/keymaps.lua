
-- Yank/Copy
vim.keymap.set('n', '<C-a>', 'ggVG')
vim.keymap.set('v', '<C-c>', '"+y')
vim.keymap.set('v', '<C-x>', '"+d')
vim.keymap.set('n', '<C-c>', '"+yy')
vim.keymap.set('n', '<C-x>', '"+dd')

-- Tab/Shift+Tab indent
vim.keymap.set("v", "<Tab>", ">gv", { noremap = true, silent = true })
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true })
vim.keymap.set("n", "<Tab>", ">>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Tab>", "<<", { noremap = true, silent = true })
vim.keymap.set("x", "<S-Tab>", "<<", { noremap = true, silent = true })

-- move commands
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- cursor stays in middle when searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- not changing the clipboard when pasting
vim.keymap.set("x", "p", "\"_dP")

-- Keep clipboard when deleting
vim.keymap.set("n", "x", '"_x')
vim.keymap.set("n", "dd", '"_dd')
vim.keymap.set("n", "d", '"_d', { noremap = true })
vim.keymap.set("x", "d", '"_d')
vim.keymap.set("x", "x", '"_x')

-- opens nvimtree on t press
vim.keymap.set("n", "t", function()
  if vim.bo.filetype == "NvimTree" then
    vim.cmd("wincmd p")
  else
    vim.cmd("NvimTreeFocus")
  end
end, { silent = true })
