return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    opts = {
      dimInactive = false,
      terminalColors = true,
      transparent = true, -- Fundo transparente
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd.colorscheme("kanagawa-wave") -- Variante específica
    end,
  },
  {
    "embark-theme/vim",
    name = "embark", -- Nome do tema
    priority = 1000, -- Garante carregamento antecipado
    init = function()
      -- Configurações pré-carregamento (opcional)
      vim.g.embark_terminal_italics = 1 -- Habilita itálicos
    end,
    config = function()
      -- Aplica o tema após carregamento
      vim.cmd.colorscheme("embark")
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000, -- Carrega antes da UI
    lazy = false, -- Carrega imediatamente
    config = function()
      -- Configuração do tema
      require("rose-pine").setup({
        variant = "main", -- Escolha: "main" (dark), "moon" (darker), "dawn" (light)
        styles = {
          bold = true,
          italic = true,
          transparency = false, -- Fundo transparente
        },
        highlight_groups = {
          -- Personalizações opcionais
          TelescopeBorder = { fg = "highlight_high", bg = "none" },
          FloatBorder = { bg = "none" },
        },
      })

      -- Aplica o tema
      vim.cmd.colorscheme("rose-pine")
    end,
  },
  -- Using Lazy
  {
    "navarasu/onedark.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("onedark").setup({
        style = "darker",
      })
      -- Enable theme
      require("onedark").load()
    end,
  },
}
