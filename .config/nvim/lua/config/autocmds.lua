-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "Open Parent Directory in Oil Float Mode" })

vim.keymap.set("n", "gl", function()
  vim.diagnostic.open_float()
end, { desc = "Open Diagnostic in Float" })

vim.keymap.set("n", "<leader>cf", function()
  require("conform").format({ lsp_format = "fallback" })
end, { desc = "Format current file" })
