-- =============================
-- lua/plugins/format.lua
-- (ajustes extras para prettier/biome e eslint coexistirem bem)
-- =============================
return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts = opts or {}
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      -- Use o que o extra escolher; garantimos ordem quando coexistirem
      opts.formatters_by_ft.javascript = { "biome", "prettier" }
      opts.formatters_by_ft.typescript = { "biome", "prettier" }
      opts.formatters_by_ft.javascriptreact = { "biome", "prettier" }
      opts.formatters_by_ft.typescriptreact = { "biome", "prettier" }
      return opts
    end,
  },
}
