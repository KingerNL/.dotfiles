-- ~/.config/nvim/lua/plugins/blink.lua
return {
	"saghen/blink.cmp",
	requires = { "rafamadriz/friendly-snippets" },
	tag = "v1.8.0",
	run = "cargo +nightly build --release",

	config = function()
		require("blink.cmp").setup({

			keymap = {
				preset = "default",
			},

			appearance = { nerd_font_variant = "mono" },
			completion = { documentation = { auto_show = false } },
			fuzzy = {
				implementation = "rust",
				prebuilt_binaries = { download = false },
			},
		})
	end,
}

