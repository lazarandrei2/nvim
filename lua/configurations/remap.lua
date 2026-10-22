vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>c", vim.cmd.bd)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- split screen and navigation
vim.keymap.set("n", "<leader>v", "<C-w>v", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>s", "<C-w>s", { desc = "Horizontal split" })
vim.keymap.set("n", "<leader>h", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<leader>l", "<C-w>l", { desc = "Window right" })
vim.keymap.set("n", "<leader>j", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<leader>k", "<C-w>k", { desc = "Window up" })

vim.keymap.set("i", "jk", "<ESC>")

