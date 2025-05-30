-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Telescope File browser
vim.keymap.set("n", "<space>se", ":Telescope file_browser<CR>")

-- open file_browser with the path of the current buffer
vim.keymap.set("n", "<space>sE", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")
