-- Servers managed by Mason and auto-enabled on matching buffers.
-- Keep this list as the single source of truth: it drives both
-- `ensure_installed` and `automatic_enable`.
local servers = {
	"lua_ls",
	"zls",
	"tailwindcss",
	"angularls",
	"svelte",
	"ts_ls",
}

-- Root of the nearest Node package (e.g. homely/apps/web when cwd is homely/).
-- ts_ls anchors here so tsserver resolves the package's own node_modules and
-- path aliases instead of the monorepo root.
local function node_root(bufnr, on_dir)
	local root = vim.fs.root(bufnr, { "package.json" })
	if root then
		on_dir(root)
	end
end

local function angular_root(bufnr, on_dir)
	local root = vim.fs.root(bufnr, { "angular.json", "nx.json" })
	if root then
		on_dir(root)
	end
end

return {
	{
		"williamboman/mason.nvim",
		version = "^2.0.0",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		version = "^2.0.0",
		lazy = false,
		opts = {
			ensure_installed = servers,
			-- Whitelist only intended servers so leftover Mason packages
			-- (e.g. vtsls, stylua) are not auto-enabled.
			automatic_enable = servers,
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		config = function()
			vim.lsp.config("*", {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})

			vim.lsp.config("ts_ls", {
				root_dir = node_root,
			})

			vim.lsp.config("angularls", {
				root_dir = angular_root,
			})

			-- Apple toolchain SourceKit (not Mason). Limit to Swift so it
			-- does not attach to C/ObjC and fight other servers.
			vim.lsp.config("sourcekit", {
				cmd = { "xcrun", "sourcekit-lsp" },
				filetypes = { "swift" },
				root_markers = {
					"Package.swift",
					"buildServer.json",
					"compile_commands.json",
					"*.xcodeproj",
					"*.xcworkspace",
					".git",
				},
			})
			vim.lsp.enable("sourcekit")

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("user_lsp", { clear = true }),
				callback = function(args)
					-- Prefer stock Neovim 0.12 gr* (gra/grn/grr) and [d/]d;
					-- 0.12 has no default gd/gD/K, so map those per buffer.
					local maps = {
						{ "gd", vim.lsp.buf.definition, "Go to definition" },
						{ "gD", vim.lsp.buf.declaration, "Go to declaration" },
						{ "K", vim.lsp.buf.hover, "Hover documentation" },
						{ "<leader>ca", vim.lsp.buf.code_action, "Code action" },
					}
					for _, map in ipairs(maps) do
						vim.keymap.set("n", map[1], map[2], { buffer = args.buf, desc = map[3] })
					end
				end,
			})

			-- Diagnostics: [d/]d are Neovim 0.12 defaults.
			vim.keymap.set("n", "U", vim.diagnostic.open_float, { desc = "Diagnostic float" })
		end,
	},
}
