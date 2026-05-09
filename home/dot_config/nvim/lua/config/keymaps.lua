-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local del = vim.keymap.del

pcall(del, "i", "jk")
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("n", "<leader>dl", ":diffget 1<cr>", { desc = "diffget from left" })
map("n", "<leader>dr", ":diffget 3<cr>", { desc = "diffget from right" })

map("i", "<Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true })
