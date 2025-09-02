-- Keymaps são carregados no evento VeryLazy
-- Defaults do LazyVim: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- LuaLS: declare a global Snacks para evitar warning de undefined-global
---@class Snacks
---@field picker table
---@field explorer fun()
---@field layout table
Snacks = Snacks

-- ===== Arquivos / Gerenciadores =====
-- Oil (diretório pai em float)
map("n", "-", "<cmd>Oil --float<CR>", { desc = "Oil: Parent (float)" })

map("n", "<leader>ls", "<cmd>Lazy sync<CR>", { desc = "Lazy: Sync" })

-- Helper: abrir o Snacks Explorer no diretório do arquivo atual (ou no cwd)
local function snacks_explorer_here()
  local name = vim.api.nvim_buf_get_name(0) -- "" quando o buffer não tem arquivo
  local uv = vim.uv or vim.loop
  local dir = (name ~= "" and vim.fn.fnamemodify(name, ":p:h")) or uv.cwd()

  -- Monta opções SEM campos nil (evita LuaLS "string|nil")
  ---@type { cwd: string, focus?: boolean, reveal?: string }
  local opts = { cwd = dir, focus = true }
  if name ~= "" then
    opts.reveal = name
  end

  -- Se o plugin estiver presente, tenta as APIs possíveis
  if _G.Snacks and Snacks.explorer then
    if type(Snacks.explorer) == "table" then
      if type(Snacks.explorer.open) == "function" then
        pcall(Snacks.explorer.open, opts)
        return
      elseif type(Snacks.explorer.toggle) == "function" then
        pcall(Snacks.explorer.toggle, opts)
        return
      end
    elseif type(Snacks.explorer) == "function" then
      -- Alguns tipos marcam como 0 args; silenciamos o warning localmente
      local ok = pcall(function()
        ---@diagnostic disable-next-line: redundant-parameter
        Snacks.explorer(opts)
      end)
      if ok then
        return
      end
      if pcall(Snacks.explorer) then
        return
      end
    end
  end

  -- Fallback robusto: muda lcd da janela, abre, e restaura
  local prev = vim.fn.getcwd()
  vim.cmd(("lcd %s"):format(vim.fn.fnameescape(dir)))
  pcall(function()
    if _G.Snacks and Snacks.explorer then
      if type(Snacks.explorer) == "function" then
        Snacks.explorer()
      elseif type(Snacks.explorer) == "table" and type(Snacks.explorer.open) == "function" then
        Snacks.explorer.open({})
      end
    else
      vim.notify("Snacks.explorer não disponível", vim.log.levels.WARN)
    end
  end)
  vim.cmd(("lcd %s"):format(vim.fn.fnameescape(prev)))
end

-- (Opcional) Mapeamento
-- vim.keymap.set("n", "<leader>e", snacks_explorer_here, { desc = "Explorer aqui (Snacks)" })

-- Keymaps
vim.keymap.set("n", "<leader>e", snacks_explorer_here, { desc = "Explorer (buffer dir)" })
-- se quiser também no '-':
-- vim.keymap.set("n", "-", snacks_explorer_here, { desc = "Explorer (buffer dir)" })

-- Snacks Explorer (root)
map("n", "<leader>E", function()
  if _G.Snacks and Snacks.explorer then
    Snacks.explorer()
  end
end, { desc = "Explorer (Project root)" })

-- Salvar rápido com Ctrl + S
vim.keymap.set({ "n", "i", "v" }, "<C-s>", function()
  vim.cmd("write")
end, { desc = "Salvar arquivo" })

-- ===== Diagnóstico =====
map("n", "gl", function()
  vim.diagnostic.open_float()
end, { desc = "Diagnostics (float)" })

-- ===== Splits =====
-- 'sh' → vertical split (vsplit) | 'sv' → horizontal split (split)
map("n", "sh", ":vsplit<CR>", opts)
map("n", "sv", ":split<CR>", opts)

-- ===== Indentação visual =====
map("v", "<", "<gv", { desc = "Indent -" })
map("v", ">", ">gv", { desc = "Indent +" })

-- ===== Paste/Del “limpos” =====
map("v", "p", '"_dP', opts) -- cola sem sobrescrever registro
map("n", "x", '"_x', opts) -- deleta char sem ir p/ registro

-- ===== Salvar / Sair =====
map({ "n", "i" }, "<C-s>", function()
  vim.cmd("silent! write")
end, { desc = "Salvar arquivo" })
map("n", "<leader>qq", ":qa<CR>", { desc = "Sair do Neovim" })

-- ===== Navegação de janelas =====
map("n", "<C-h>", "<C-w>h", { desc = "Janela esquerda" })
map("n", "<C-j>", "<C-w>j", { desc = "Janela baixo" })
map("n", "<C-k>", "<C-w>k", { desc = "Janela cima" })
map("n", "<C-l>", "<C-w>l", { desc = "Janela direita" })

-- ===== Mover linhas =====
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Mover linha ↓" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Mover linha ↑" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Mover seleção ↓" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Mover seleção ↑" })

-- ===== Snacks Picker =====
-- *Com checagem segura para evitar erro se Snacks ainda não estiver pronto*
map("n", "<leader><space>", function()
  if Snacks and Snacks.picker then
    Snacks.picker.files()
  end
end, { desc = "Files (root)" })
map("n", "<leader>/", function()
  if Snacks and Snacks.picker then
    Snacks.picker.grep()
  end
end, { desc = "Grep (root)" })
map("n", "<leader>fb", function()
  if Snacks and Snacks.picker then
    Snacks.picker.buffers()
  end
end, { desc = "Buffers" })
map("n", "<leader>fr", function()
  if Snacks and Snacks.picker then
    Snacks.picker.recent()
  end
end, { desc = "Recent" })
map("n", "<leader>fp", function()
  if Snacks and Snacks.picker then
    Snacks.picker.projects()
  end
end, { desc = "Projects" })
map("n", "gd", function()
  if Snacks and Snacks.picker then
    Snacks.picker.lsp_definitions()
  end
end, { desc = "LSP Defs" })
map("n", "gr", function()
  if Snacks and Snacks.picker then
    Snacks.picker.lsp_references()
  end
end, { desc = "LSP Refs" })

-- ===== Trouble (diagnósticos) =====
-- LazyVim já integra bem; este toggle é útil:
map("n", "<leader>xx", function()
  require("trouble").toggle()
end, { desc = "Trouble" })

-- Mapeamento para compilar o Java
vim.api.nvim_set_keymap("n", "<leader>jc", ":!javac %<CR>", { noremap = true, silent = true })

-- Mapeamento para rodar o Java
vim.api.nvim_set_keymap("n", "<leader>jr", ":!java %:r<CR>", { noremap = true, silent = true })
