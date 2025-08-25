return {
  "akinsho/bufferline.nvim",
  dependencies = { "catppuccin/nvim" },
  opts = function(_, opts)
    opts = opts or {}
    local ok, catpp = pcall(require, "catppuccin.groups.integrations.bufferline")
    if ok and catpp then
      if type(catpp.get_theme) == "function" then
        opts.highlights = catpp.get_theme({})
      elseif type(catpp.get) == "function" then
        opts.highlights = catpp.get({})
      elseif type(catpp.get_highlights) == "function" then
        opts.highlights = catpp.get_highlights({})
      else
        opts.highlights = opts.highlights or {}
      end
    end

    -- suas opções extras (mantém as que você já pôs)
    opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
      diagnostics = "nvim_lsp",
      show_close_icon = false,
      separator_style = "slant",
    })
    return opts
  end,
}
