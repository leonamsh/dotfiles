return {
    "3rd/image.nvim",
    build = false, -- evita compilar o rock
    -- Carrega apenas quando há UI e terminal compatível
    cond = function()
        -- não carregar em headless/sem UI
        if #vim.api.nvim_list_uis() == 0 then
            return false
        end
        -- não carregar em GUIs (Neovide) ou VSCode
        if vim.g.neovide or vim.g.vscode then
            return false
        end
        -- detectar Kitty ou WezTerm (que implementam o protocolo do Kitty)
        local term = os.getenv("TERM") or ""
        local term_prog = os.getenv("TERM_PROGRAM") or ""
        return term:match("kitty") or term_prog:match("WezTerm")
    end,

    opts = {
        -- use o CLI do ImageMagick
        processor = "magick_cli",
        -- defina backend apenas quando o cond permitir (Kitty/WezTerm)
        backend = "kitty",
        integrations = {
            markdown = {
                enabled = true,
                clear_in_insert_mode = false,
                download_remote_images = true,
                only_render_image_at_cursor = false,
                only_render_image_at_cursor_mode = "popup",
                floating_windows = false,
                filetypes = { "markdown", "vimwiki" },
            },
            neorg = { enabled = true, filetypes = { "norg" } },
            typst = { enabled = true, filetypes = { "typst" } },
            html = { enabled = false },
            css = { enabled = false },
        },
        max_width = nil,
        max_height = nil,
        max_width_window_percentage = nil,
        max_height_window_percentage = 50,
        window_overlap_clear_enabled = false,
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
        editor_only_render_when_focused = false,
        tmux_show_only_in_active_window = false,
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
    },

    config = function(_, opts)
        -- Inicializa somente depois que a UI estiver anexada
        vim.api.nvim_create_autocmd("UIEnter", {
            once = true,
            callback = function()
                -- proteção extra: se por algum motivo não houver UI, não cai
                if #vim.api.nvim_list_uis() == 0 then
                    return
                end
                require("image").setup(opts)
            end,
        })
    end,
}
