local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Header
dashboard.section.header.val = {
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣤⣴⣶⣶⣶⣶⣶⣦⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣶⣿⡿⠿⠛⠛⠋⠉⠉⠉⠉⠉⠙⠛⠻⠿⣿⣷⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⠿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⢿⣿⣦⣄⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⣠⣾⡿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣄⣀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣷⡄⠀⠀⠀⠀⠀",
    "⠀⠀⠀⢀⣾⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣴⣾⣿⣿⣿⡿⣶⣦⡀⠀⠀⠀⠀⠀⠈⠻⣿⣦⡀⠀⠀⠀",
    "⠀⠀⢠⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢤⣤⣿⣿⣿⣿⣿⣿⣿⣆⠘⣿⠟⣷⣦⣄⡀⠀⠀⠀⠘⣿⣷⡀⠀⠀",
    "⠀⢠⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢶⣤⣽⣿⣿⣿⣿⣿⣿⣿⡋⢠⣿⡧⠈⠙⣿⣿⣿⣶⣦⡄⠘⣿⣷⡀⠀",
    "⠀⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⣦⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣴⣯⣩⣿⣿⣿⣿⣦⠘⣿⣧⠀",
    "⢸⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣏⠉⠉⠉⠛⢻⣿⢿⡿⡿⡿⢿⡟⠀⢻⣿⡄",
    "⣾⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢲⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣳⠀⠀⠀⠹⠋⠛⠽⠟⠋⠋⠀⠀⢸⣿⡇",
    "⣿⣿⠀⠀⠀⠀⠀⠀⠀⢀⡀⣦⣪⣿⣿⣿⣿⣿⡿⠹⠹⣿⣿⣿⣿⣷⣓⣴⢀⡀⡀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡇",
    "⣿⣿⠀⠀⠀⠀⠀⣤⣳⣶⣿⣿⣿⣿⣿⣿⡏⡿⠃⢀⡀⠈⠉⠛⠻⠿⣿⣷⣽⣟⠷⠶⡄⠀⠀⠀⠀⠀⢸⣿⡇",
    "⢸⣿⡆⣤⣄⣻⣷⣿⣿⣿⣿⣿⣿⡿⣿⡁⠇⠁⠀⢻⡞⠉⠀⠀⠀⠀⠀⠙⠻⠿⠟⠛⠀⠀⠀⠀⠀⠀⣸⣿⠇",
    "⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣾⣄⣠⣠⡴⠿⣣⣿⡵⠧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⡿⠀",
    "⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⣿⠿⣿⣿⣿⣿⣴⡞⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⠃⠀",
    "⠀⠀⠹⣿⣿⣿⣿⣿⣿⢻⠿⣆⠘⠢⡘⠘⠛⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⠃⠀⠀",
    "⠀⠀⠀⠙⣿⣿⣿⡏⠙⢦⣣⠈⠖⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣄⣀⢀⣦⣀⠀⢀⣠⣾⡿⠃⠀⠀⠀",
    "⠀⠀⠀⠀⠈⠻⣿⣧⡀⠀⠉⠣⡀⠀⠀⣠⣤⣀⣠⣤⣐⣴⣷⣅⣤⣦⣟⣿⢿⣸⣿⣿⣾⣿⣿⠟⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠉⠻⣿⣷⣄⣀⣴⣦⣤⣽⣟⣙⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠻⠿⠿⣿⣿⣿⣿⣿⣿⠿⠿⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
}

-- Apply highlight (works with `dashboard.section.header`)
vim.api.nvim_set_hl(0, "DinoOrange", { fg = "#FAB387", bg = "NONE" })
dashboard.section.header.opts.hl = "DinoOrange"

-- Buttons (remove telescope & add more relevant actions)
dashboard.section.buttons.val = {
  dashboard.button("e", " New file", ":ene<CR>"),
  dashboard.button("c", "  Edit config", ":e ~/.config/nvim/init.lua<CR>"),
  dashboard.button("t", "󱏒 Toggle file tree", ":NvimTreeToggle<CR>"),
  dashboard.button("q", "  Quit", ":qa<CR>"),
}

-- dashboard.section.footer.val = "NeoVim is ready, trainer."


-- 🚀 SETUP ALPHA
alpha.setup(dashboard.config)

-- 📁 OPEN TREE ONLY IF FILE IS PASSED
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() > 0 then
      -- File or dir was passed, open tree and find the file
      require("nvim-tree.api").tree.find_file({ open = true })
    end
  end,
})
