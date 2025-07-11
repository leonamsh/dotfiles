return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  -- dependencies = { "nvim-tree/nvim-web-devicons" },
  -- or if using mini.icons/mini.nvim
  dependencies = { "echasnovski/mini.icons" },
  opts = {},
  keys = {
    {
      "<leader>fb",
      function()
        require("fzf-lua").builtin()
      end,
      desc = "[F]zfLua [B]uildint commands",
    },
    {
      "<leader>fc",
      function()
        require("fzf-lua-enchanted-files").files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "[F]ind in nvim [C]onfiguration",
    },
    {
      "<leader>fd",
      function()
        require("fzf-lua").diagnostics_document()
      end,
      desc = "[F]ind [D]iagnostics",
    },
    {
      "<leader>ff",
      function()
        require("fzf-lua-enchanted-files").files()
      end,
      desc = "[F]ind [F]iles in project directory",
    },
    {
      "<leader>fg",
      function()
        require("fzf-lua").live_grep()
      end,
      desc = "[F]ind by [G]repping project directory",
    },
    {
      "<leader>fh",
      function()
        require("fzf-lua").helptags()
      end,
      desc = "[F]ind [H]elp",
    },
    {
      "<leader>fk",
      function()
        require("fzf-lua").keymaps()
      end,
      desc = "[F]ind [K]eymaps",
    },
    {
      "<leader>fw",
      function()
        require("fzf-lua").grep_cword()
      end,
      desc = "[F]ind current [W]ord",
    },
    {
      "<leader>fW",
      function()
        require("fzf-lua").grep_cWORD()
      end,
      desc = "[F]ind current [W]ORD",
    },
    {
      "<leader>fR",
      function()
        require("fzf-lua").resume()
      end,
      desc = "[F]ind [R]esume",
    },
    {
      "<leader>fo",
      function()
        require("fzf-lua").oldfiles()
      end,
      desc = "[F]ind [O]ld files",
    },
    {
      "<leader><leader>",
      function()
        require("fzf-lua").buffers()
      end,
      desc = "[F]ind [B]uffers",
    },
    {
      "<leader>/",
      function()
        require("fzf-lua").lgrep_curbuf()
      end,
      desc = "[/] Live grep the current buffer",
    },
    {
      "<leader>ldm",
      function()
        require("fzf-lua-enchanted-files").files({ cwd = "/run/media/lm/dev/maisPraTi/" })
      end,
      desc = "Open fzf in [L]Leo [D]directory [M]aisPraTi",
    },
    {
      "<leader>lds",
      function()
        require("fzf-lua-enchanted-files").files({ cwd = "/run/media/lm/dev/scripts/" })
      end,
      desc = "Open fzf in [L]Leo [D]directory [S]cripts",
    },
    {
      "<leader>ldc",
      function()
        require("fzf-lua-enchanted-files").files({ cwd = "/run/media/lm/dev/clones/" })
      end,
      desc = "Open fzf in [L]Leo [D]directory [C]lones",
    },
  },
}
