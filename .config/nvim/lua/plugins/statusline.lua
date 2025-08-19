return {
  "echasnovski/mini.statusline",
  version = false,
  event = "VeryLazy",
  dependencies = {
    -- Opcional porém recomendado para branch e diff count
    "lewis6991/gitsigns.nvim",
  },
  opts = function()
    local s = require("mini.statusline")

    -- LSP: lista nomes dos clientes ativos no buffer
    local function lsp()
      local names = {}
      for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        if client.name and client.name ~= "" then
          table.insert(names, client.name)
        end
      end
      return (#names > 0) and (" " .. table.concat(names, ",")) or ""
    end

    -- Search count quando hlsearch está ativo
    local function search()
      if vim.v.hlsearch == 0 then return "" end
      local sc = vim.fn.searchcount({ maxcount = 0 })
      if not sc or sc.total == 0 then return "" end
      return (" %d/%d"):format(sc.current, sc.total)
    end

    -- Flags úteis (paste/spell)
    local function toggles()
      local t = {}
      if vim.o.paste then table.insert(t, "PASTE") end
      if vim.wo.spell then table.insert(t, "SPELL") end
      return next(t) and ("[" .. table.concat(t, ",") .. "]") or ""
    end

    -- Indicador de gravação de macro (q)
    local function recording()
      local reg = vim.fn.reg_recording()
      return (reg == "" and "") or (" @" .. reg)
    end

    s.setup({
      use_icons = true,
      set_vim_settings = true, -- ajusta 'laststatus', etc.
      content = {
        active = function()
          return s.combine_groups({
            -- Modo (com highlight dinâmico do mini)
            { hl = s.hl_mode(), strings = { s.section_mode({ trunc_width = 120 }) } },

            -- Info de dev: Git / Diagnostics / LSP
            { hl = "MiniStatuslineDevinfo", strings = {
              s.section_git({ trunc_width = 75 }),
              s.section_diagnostics({ trunc_width = 75 }),
              lsp(),
            }},

            "%<", -- ponto de truncamento para a esquerda

            -- Nome do arquivo (mostra [+] modificado, [-] readonly, ícone se tiver devicons)
            { hl = "MiniStatuslineFilename", strings = {
              s.section_filename({ trunc_width = 140 }),
            }},

            "%=", -- alinha à direita

            -- Info do arquivo + toggles + busca
            { hl = "MiniStatuslineFileinfo", strings = {
              -- fileinfo mostra ft/encoding/fileformat e tamanho (quando aplicável)
              s.section_fileinfo({ trunc_width = 120 }),
              toggles(),
              search(),
            }},

            -- Coluna/Linha + gravação de macro
            { hl = s.hl_mode(), strings = {
              s.section_location(),
              recording(),
            }},
          })
        end,

        inactive = function()
          return s.combine_groups({
            { hl = "MiniStatuslineInactive", strings = { s.section_filename() } },
            "%=",
            { hl = "MiniStatuslineInactive", strings = { s.section_location() } },
          })
        end,
      },
    })
  end,
}

