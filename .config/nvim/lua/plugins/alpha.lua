return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VimEnter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      [[          ██▓     ▓█████ ▒█████         ]],
      [[         ▓██▒     ▓█   ▀ ██▒  ██▒       ]],
      [[         ▒██░     ▒███   ██░  ██▒       ]],
      [[         ▒██░     ▒▓█  ▄ ██   ██░       ]],
      [[         ░██████▒░▒████▒░ ████▓▒░       ]],
      [[         ░ ▒░▓  ░░ ▒░ ░░ ▒░▒░▒░ ░       ]],
      [[         ░ ░ ▒  ░░ ░  ░░ ░ ▒ ▒░ ░       ]],
      [[           ░ ░     ░     ░ ░ ▒  ░       ]],
      [[             ░  ░  ░  ░    ░ ░          ]],
      [[🦊 Leonam — Terminal e Código com Estilo]],
    }

    dashboard.section.buttons.val = {
      dashboard.button("f", " Find file", ":Telescope find_files<CR>"),
      dashboard.button("n", " New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("r", " Recent files", ":Telescope oldfiles<CR>"),
      dashboard.button("g", " Find text", ":Telescope live_grep<CR>"),
      dashboard.button("c", " Config", ":e ~/.config/nvim<CR>"),
      dashboard.button("L", "Lazy Config", ":Lazy<CR>"),
      dashboard.button("q", " Quit", ":qa<CR>"),
    }

    dashboard.section.footer.val = "🦊 Feito por Leonam com ❤️ e Lazy.nvim"
    dashboard.opts.opts.noautocmd = true
    alpha.setup(dashboard.opts)
  end,
}
