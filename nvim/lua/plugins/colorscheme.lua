return {
  -- Using Lazy
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("onedark").setup({
        style = "darker",
      })
      -- Enable theme
      require("onedark").load()
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "nightfox", -- Pode ser: Light theme: dayfox, dawnfox. Dark Theme: duskfox, nordfox, terafox, carbonfox ou nightfox.
    },
    config = function()
      vim.cmd.colorscheme("carbonfox") -- Ativa o flavour escolhido
    end,
  },
  {
    "Shatur/neovim-ayu",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "ayu-mirage", -- Pode ser ayu-mirage, ayu-dark ou ayu-light
    },
    config = function()
      vim.cmd.colorscheme("ayu-mirage")
    end,
  },
}
