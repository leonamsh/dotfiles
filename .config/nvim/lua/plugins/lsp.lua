return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "williamboman/mason.nvim", opts = {} },
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
        -- cria um "picker" que decide entre fzf-lua e telescope
        local picker = (function()
            local ok, fzf = pcall(require, "fzf-lua")
            if ok then
                return {
                    defs = fzf.lsp_definitions,
                    refs = fzf.lsp_references,
                    imps = fzf.lsp_implementations,
                    tdefs = fzf.lsp_typedefs,
                    doc_symbols = fzf.lsp_document_symbols,
                    ws_symbols = fzf.lsp_live_workspace_symbols,
                }
            else
                local tb = require("telescope.builtin")
                return {
                    defs = tb.lsp_definitions,
                    refs = function()
                        tb.lsp_references({ include_current_line = false })
                    end,
                    imps = tb.lsp_implementations,
                    tdefs = tb.lsp_type_definitions,
                    doc_symbols = tb.lsp_document_symbols,
                    ws_symbols = tb.lsp_workspace_symbols,
                }
            end
        end)()

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc, mode)
                    mode = mode or "n"
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                -- atalhos LSP
                map("gd", picker.defs, "[G]oto [D]efinition")
                map("gr", picker.refs, "[G]oto [R]eferences")
                map("gI", picker.imps, "[G]oto [I]mplementation")
                map("<leader>D", picker.tdefs, "Type [D]efinition")
                map("<leader>ds", picker.doc_symbols, "[D]ocument [S]ymbols")
                map("<leader>ws", picker.ws_symbols, "[W]orkspace [S]ymbols")

                map("<leader>cr", vim.lsp.buf.rename, "[R]e[n]ame")
                map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
                map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                -- resto do seu highlight/inlay hints/dignostics ficou igual…
                -- (não mexi no bloco abaixo do client_supports_method)
                ----------------------------------------------------------------
                local function client_supports_method(client, method, bufnr)
                    if vim.fn.has("nvim-0.11") == 1 then
                        return client:supports_method(method, bufnr)
                    else
                        return client.supports_method(method, { bufnr = bufnr })
                    end
                end

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if
                    client
                    and client_supports_method(
                        client,
                        vim.lsp.protocol.Methods.textDocument_documentHighlight,
                        event.buf
                    )
                then
                    local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })
                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })
                    vim.api.nvim_create_autocmd("LspDetach", {
                        group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                        callback = function(ev2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = ev2.buf })
                        end,
                    })
                end

                if
                    client
                    and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
                then
                    map("<leader>th", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                    end, "[T]oggle Inlay [H]ints")
                end
            end,
        })

        -- config de diagnostics e mason/lspconfig ficou igual ao seu original…
        --------------------------------------------------------------------
        vim.diagnostic.config({
            severity_sort = true,
            float = { border = "rounded", source = "if_many" },
            underline = { severity = vim.diagnostic.severity.ERROR },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "󰅚 ",
                    [vim.diagnostic.severity.WARN] = "󰀪 ",
                    [vim.diagnostic.severity.INFO] = "󰋽 ",
                    [vim.diagnostic.severity.HINT] = "󰌶 ",
                },
            },
            virtual_text = {
                source = "if_many",
                spacing = 2,
                format = function(d)
                    return d.message
                end,
            },
        })

        local original_capabilities = vim.lsp.protocol.make_client_capabilities()
        local capabilities = require("blink.cmp").get_lsp_capabilities(original_capabilities)

        local servers = { bashls = {}, marksman = {}, lua_ls = {} }
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            "astro-language-server",
            "biome",
            "css-lsp",
            "debugpy",
            "delve",
            "docker-compose-language-service",
            "dockerfile-language-server",
            "eslint-lsp",
            "hadolint",
            "intelephense",
            "js-debug-adapter",
            "lua-language-server",
            "neocmakelsp",
            "php-debug-adapter",
            "phpstan",
            "prettier",
            "prettierd",
            "pyright",
            "ruff",
            "stylua",
        })
        require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

        require("mason-lspconfig").setup({
            ensure_installed = {},
            automatic_installation = false,
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                    require("lspconfig")[server_name].setup(server)
                end,
            },
        })
    end,
}
