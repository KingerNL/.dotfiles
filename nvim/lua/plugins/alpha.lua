local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Header
dashboard.section.header.val = {
  " ______  ______   __  __   ______   __    __   ______   __   __   ",
  "/\\  == \\/\\  __ \\ /\\ \\/ /  /\\  ___\\ /\\ \"-./  \\ /\\  __ \\ /\\ \"-.\\ \\  ",
  "\\ \\  _-/\\ \\ \\/\\ \\\\ \\  _\"-.\\ \\  __\\ \\ \\ \\-./\\ \\\\ \\ \\/\\ \\\\ \\ \\-.  \\ ",
  " \\ \\_\\   \\ \\_____\\\\ \\_\\ \\_\\\\ \\_____\\\\ \\_\\ \\ \\_\\\\ \\_____\\\\ \\_\\\"\\_\\",
  "  \\/_/    \\/_____/ \\/_/\\/_/ \\/_____/ \\/_/  \\/_/ \\/_____/ \\/_/ \\/_/",
}


-- Buttons
dashboard.section.buttons.val = {
  dashboard.button("f", "󰈞  Find file", ":Telescope find_files<CR>"),
  dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
  dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
  dashboard.button("q", "  Quit", ":qa<CR>"),
}

-- Footer
dashboard.section.footer.val = "NeoVim is ready, trainer."

-- Load dashboard
alpha.setup(dashboard.config)

-- Set tree at startup
vim.api.nvim_create_autocmd("User", {
  pattern = "AlphaReady",
  callback = function()
    require("nvim-tree.api").tree.open()
  end,
})

