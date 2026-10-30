local parsers = {
	"lua",
	"vim",
	"vimdoc",
	"bash",
	"go",
	"rust",
	"toml",
	"typescript",
	"tsx",
	"html",
	"css",
	"swift",
	"json",
	"markdown",
}

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		if vim.fn.executable("tree-sitter") ~= 1 then
			vim.notify(
				"tree-sitter CLI not found. Install with: brew install tree-sitter-cli",
				vim.log.levels.ERROR
			)
			return
		end

		-- Async install — do not block startup with :wait
		require("nvim-treesitter").install(parsers)

		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
