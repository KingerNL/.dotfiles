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

