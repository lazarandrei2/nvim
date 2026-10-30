-- Colors are terminal ANSI slots so the statusline follows the terminal theme
-- (see configurations/colors.lua). Sections are transparent; the mode and
-- location pills use reverse video so their text takes the terminal background.
local mode_colors = {
	n = 4, -- blue
	i = 2, -- green
	v = 5, -- magenta
	V = 5,
	["\22"] = 5, -- visual block
	s = 5,
	S = 5,
	["\19"] = 5, -- select block
	R = 1, -- red
	c = 3, -- yellow
	t = 6, -- cyan
}

local function mode_color()
	return mode_colors[vim.fn.mode():sub(1, 1)] or mode_colors.n
end

local function pill_cap(glyph)
	return {
		function()
			return glyph
		end,
		padding = 0,
		color = function()
			return { fg = mode_color() }
		end,
	}
end

local function pill(component)
	return {
		component,
		color = function()
			return { fg = mode_color(), gui = "reverse,bold" }
		end,
	}
end

local transparent = { fg = "NONE", bg = "NONE" }
local dimmed = { fg = 8, bg = "NONE" }

local theme = {
	normal = { a = transparent, b = transparent, c = transparent },
	inactive = { a = dimmed, b = dimmed, c = dimmed },
}

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				theme = theme,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {},
			},
			sections = {
				lualine_a = { pill_cap("\u{e0b6}"), pill("mode"), pill_cap("\u{e0b4}") },
				lualine_b = {
					"branch",
					{
						"diff",
						diff_color = {
							added = { fg = 2 },
							modified = { fg = 3 },
							removed = { fg = 1 },
						},
					},
					{
						"diagnostics",
						diagnostics_color = {
							error = { fg = 1 },
							warn = { fg = 3 },
							info = { fg = 4 },
							hint = { fg = 6 },
						},
					},
				},
				lualine_c = { "filename" },
				-- devicons use fixed 256-color codes, so draw the icon in the section color
				lualine_x = { "encoding", "fileformat", { "filetype", colored = false } },
				lualine_y = { { "progress", color = dimmed } },
				lualine_z = { pill_cap("\u{e0b6}"), pill("location"), pill_cap("\u{e0b4}") },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = {},
		})
	end,
}
