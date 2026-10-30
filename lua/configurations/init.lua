-- Leader must be set before any <leader> keymaps are defined
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

require("configurations.set")
require("configurations.colors")
require("configurations.remap")
require("configurations.lazy")
