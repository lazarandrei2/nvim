return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "modern",
		spec = {
			{ "<leader>v", desc = "Vertical split" },
			{ "<leader>s", desc = "Horizontal split" },
			{ "<leader>h", desc = "Window left" },
			{ "<leader>j", desc = "Window down" },
			{ "<leader>k", desc = "Window up" },
			{ "<leader>l", desc = "Window right" },
		},
	},
}
