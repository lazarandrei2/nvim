-- Leader must be set before any <leader> keymaps are defined
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

require("configurations.set")
require("configurations.colors")
require("configurations.remap")
require("configurations.lazy")

local ft_indent = {
	elixir = { expandtab = true, shiftwidth = 4, tabstop = 4 },
	kotlin = { expandtab = true, shiftwidth = 4, tabstop = 4 },
	python = { expandtab = true, shiftwidth = 4, tabstop = 4, softtabstop = 4 },
}

vim.api.nvim_create_autocmd("FileType", {
	pattern = vim.tbl_keys(ft_indent),
	callback = function(args)
		local opts = ft_indent[args.match]
		if not opts then
			return
		end
		for option, value in pairs(opts) do
			vim.bo[option] = value
		end
	end,
})
