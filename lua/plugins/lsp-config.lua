local servers = {
	"lua_ls",
	"zls",
	"tailwindcss",
	"omnisharp",
	"angularls",
	"svelte",
	"vue_ls",
	"ts_ls",
	"denols",
	"elixirls",
	"kotlin_lsp",
	"basedpyright",
	"ruff",
}

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
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			-- Nearest Node/Vue package root (e.g. homely/apps/web when cwd is homely/)
			local function node_project_root(bufnr)
				return vim.fs.root(bufnr, { "package.json", "tsconfig.json", "jsconfig.json" })
			end

			-- apps/web has package.json + tsconfig; apps/api and packages/* are Deno-only
			local function is_node_ts_project(bufnr)
				local package_json = vim.fs.root(bufnr, { "package.json" })
				if not package_json then
					return false
				end
				local tsconfig = vim.fs.root(bufnr, { "tsconfig.json", "jsconfig.json" })
				return tsconfig ~= nil and tsconfig == package_json
			end

			local function node_ts_root(bufnr, on_dir)
				if not is_node_ts_project(bufnr) then
					return
				end
				on_dir(node_project_root(bufnr))
			end

			-- Deno workspace root (homely/): resolves @homely/core and other workspace imports
			local function deno_root(bufnr, on_dir)
				if is_node_ts_project(bufnr) then
					return
				end
				local lock_root = vim.fs.root(bufnr, { "deno.lock" })
				if lock_root then
					on_dir(lock_root)
					return
				end
				local deno_json = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
				if deno_json then
					on_dir(deno_json)
				end
			end

			local function angular_root(bufnr, on_dir)
				local root = vim.fs.root(bufnr, { "angular.json", "nx.json" })
				if root then
					on_dir(root)
				end
			end

			-- Vue 3 hybrid mode: vue_ls (template/style) + ts_ls (script/TS)
			-- https://github.com/vuejs/language-tools/wiki/Neovim
			local vue_language_server_path = vim.fs.joinpath(
				vim.fn.stdpath("data"),
				"mason/packages/vue-language-server/node_modules/@vue/language-server"
			)

			local tsserver_filetypes = {
				"typescript",
				"javascript",
				"javascriptreact",
				"typescriptreact",
				"vue",
			}

			local vue_plugin = {
				name = "@vue/typescript-plugin",
				location = vue_language_server_path,
				languages = { "vue" },
			}

			vim.lsp.config("denols", {
				cmd = { "deno", "lsp" },
				root_dir = deno_root,
			})

			vim.lsp.config("vue_ls", {
				root_dir = node_ts_root,
			})

			vim.lsp.config("ts_ls", {
				root_dir = node_ts_root,
				init_options = {
					plugins = { vue_plugin },
				},
				filetypes = tsserver_filetypes,
			})

			vim.lsp.config("angularls", {
				root_dir = angular_root,
			})

			vim.lsp.config("elixirls", {
				cmd = { "elixir-ls" },
				-- Per-buffer root (stock lspconfig handles umbrella apps)
				root_dir = function(bufnr, on_dir)
					local root = vim.fs.root(bufnr, { "mix.exs", ".git" })
					if root then
						on_dir(root)
					end
				end,
			})

			-- kotlin-lsp trial workaround: faketime freezes clock when available.
			local kotlin_cmd = { "intellij-server", "--stdio" }
			if vim.fn.executable("faketime") == 1 then
				kotlin_cmd = { "faketime", "2026-06-04", "intellij-server", "--stdio" }
			end
			vim.lsp.config("kotlin_lsp", {
				cmd = kotlin_cmd,
			})

			-- Python: basedpyright (types/completions) + ruff (lint/format)
			vim.lsp.config("basedpyright", {
				settings = {
					basedpyright = {
						analysis = {
							autoImportCompletions = true,
							autoSearchPaths = true,
							diagnosticMode = "openFilesOnly",
							typeCheckingMode = "standard",
							useLibraryCodeForTypes = true,
						},
					},
				},
			})

			vim.lsp.config("ruff", {
				init_options = {
					settings = {
						lint = {
							enable = true,
						},
					},
				},
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
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.name == "ruff" then
						client.server_capabilities.hoverProvider = false
					end

					local buf = args.buf
					local map = function(lhs, rhs, desc)
						vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
					end
					-- Prefer stock Neovim 0.12 gr* (gra/grn/grr); keep familiar gd/K
					map("gd", vim.lsp.buf.definition, "Go to definition")
					map("gD", vim.lsp.buf.declaration, "Go to declaration")
					map("K", vim.lsp.buf.hover, "Hover documentation")
					map("<leader>ca", vim.lsp.buf.code_action, "Code action")
				end,
			})

			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
			vim.keymap.set("n", "U", vim.diagnostic.open_float, { desc = "Diagnostic float" })
		end,
	},
}
