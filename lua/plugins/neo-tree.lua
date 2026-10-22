return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	cmd = "Neotree",
	keys = {
		{ "\\", ":Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
	},
	opts = {
		filesystem = {
			window = {
				mappings = {
					["\\"] = "close_window",
				},
			},
		},
		default_component_configs = {
			icon = {
				provider = function(icon, node, _state)
					if node.type == "file" or node.type == "terminal" then
						local ok, web_devicons = pcall(require, "nvim-web-devicons")
						if ok then
							local name = node.type == "terminal" and "terminal" or node.name
							icon.text = web_devicons.get_icon(name) or icon.text
						end
						icon.highlight = "NeoTreeFileIcon"
					end
					return icon
				end,
			},
		},
	},
}
