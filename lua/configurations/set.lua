vim.opt.nu = true
vim.opt.relativenumber = true

-- vim.opt.laststatus = 0 -- hides the filename line at the bottom
vim.opt.cmdheight = 0 -- unifies command line with status line

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
local undodir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(undodir, "p")
vim.opt.undodir = undodir
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Use the terminal's ANSI palette (cterm colors) instead of 24-bit colors,
-- so Neovim follows the terminal theme live when it changes.
vim.opt.termguicolors = false

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.cursorline = true

vim.opt.clipboard = "unnamedplus"

vim.opt.fillchars = { eob = " " }

vim.opt.smoothscroll = true
vim.opt.splitkeep = "screen"
vim.opt.winborder = "rounded"

vim.diagnostic.config({
	-- Use virtual_lines OR virtual_text, not both (same message appears twice)
	virtual_text = false,
	virtual_lines = { current_line = true },
	signs = true,
	severity_sort = true,
	underline = true,
})
