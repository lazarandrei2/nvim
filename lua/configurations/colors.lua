-- Syntax colors from the terminal's ANSI palette (see 'termguicolors' in set.lua).
-- The default colorscheme leaves most syntax groups uncolored in cterm mode.
-- Treesitter (@type, @keyword, ...) and LSP semantic tokens link to these base
-- groups, so coloring them is enough. Uses the normal slots 1-6, which terminal
-- themes tune for contrast on both light and dark backgrounds.
local ansi = {
	red = 1,
	green = 2,
	yellow = 3,
	blue = 4,
	magenta = 5,
	cyan = 6,
	grey = 8,
}

local groups = {
	Comment = { ctermfg = ansi.grey, italic = true },
	Constant = { ctermfg = ansi.red }, -- numbers, booleans, enum cases
	String = { ctermfg = ansi.green },
	Type = { ctermfg = ansi.yellow },
	Special = { ctermfg = ansi.yellow }, -- builtin types, constructors
	Function = { ctermfg = ansi.blue },
	Statement = { ctermfg = ansi.magenta }, -- keywords
	PreProc = { ctermfg = ansi.magenta }, -- imports, attributes
	Identifier = { ctermfg = ansi.cyan }, -- properties
}

local function apply()
	for name, attrs in pairs(groups) do
		local current = vim.api.nvim_get_hl(0, { name = name, link = false })
		vim.api.nvim_set_hl(0, name, vim.tbl_extend("force", current, attrs))
	end
end

vim.api.nvim_create_autocmd("ColorScheme", { callback = apply })
apply()
