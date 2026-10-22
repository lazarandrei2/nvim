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
			python = { "ruff_organize_imports", "ruff_format" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			json = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			elixir = { "mix" },
			kotlin = { "lsp" },
		},
		formatters = {
			prettier = {
				prepend_args = { "--tab-width", "4", "--use-tabs", "false" },
			},
		},
	},
}
