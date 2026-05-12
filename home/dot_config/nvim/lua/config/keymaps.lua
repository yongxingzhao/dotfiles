-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local del = vim.keymap.del

pcall(del, "i", "jk")
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("n", "do1", ":diffget 1<cr>", { desc = "diffget from tab1" })
map("n", "do2", ":diffget 2<cr>", { desc = "diffget from tab2" })
map("n", "do3", ":diffget 3<cr>", { desc = "diffget from tab3" })
map("n", "dp1", ":diffput 1<cr>", { desc = "diffput to tab1" })
map("n", "dp2", ":diffput 2<cr>", { desc = "diffput to tab2" })
map("n", "dp3", ":diffput 3<cr>", { desc = "diffput to tab3" })

map("i", "<Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true })
