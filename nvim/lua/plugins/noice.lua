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


