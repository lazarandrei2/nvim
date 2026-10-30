return {
	"stevearc/conform.nvim",
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>gf",
			function()
				require("conform").format({ async = true })
			end,
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			go = { "gofumpt" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			json = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
		},
		formatters = {
			prettier = {
				prepend_args = { "--tab-width", "4", "--use-tabs", "false" },
			},
		},
	},
}
