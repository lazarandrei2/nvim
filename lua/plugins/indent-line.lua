return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	config = function()
		require("ibl").setup({
			indent = {
				char = "┊",
				highlight = "NonText",
			},
			scope = {
				enabled = false,
				char = "┊",
				show_start = false,
				show_end = false,
			},
		})
	end,
}
