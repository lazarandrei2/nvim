return {
	{
		"nvim-telescope/telescope.nvim",
		version = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			require("telescope").setup({
				defaults = {
					layout_strategy = "vertical",
					layout_config = {
						vertical = { width = 0.8 },
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
					fzf = {},
				},
			})

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Find files" })
			vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Git files" })
			vim.keymap.set("n", "<leader>pg", builtin.git_files, { desc = "Git files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
			vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "Recent files" })
			vim.keymap.set("n", "<leader>ps", function()
				builtin.grep_string({ search = vim.fn.input("Grep > ") })
			end, { desc = "Grep string" })
		end,
	},
}
