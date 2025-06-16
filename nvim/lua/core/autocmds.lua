vim.api.nvim_create_autocmd('VimLeave', {
  callback = function()
    vim.opt.guicursor = 'a:ver26'
  end
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("nvim-tree.api").tree.open()
  end,
})

