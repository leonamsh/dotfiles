return {
    { -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        main = "nvim-treesitter.configs", -- Sets main module to use for opts
        -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
        opts = {
            ensure_installed = {
                "astro",
                "bash",
                "blade",
                "c",
                "caddy",
                "css",
                "diff",
                "dockerfile",
                "editorconfig",
                "gitignore",
                "go",
                "gomod",
                "gosum",
                "html",
                "javascript",
                "json",
                "lua",
                "luadoc",
                "nginx",
                "php",
                "php_only",
                "python",
                "sql",
                "typescript",
                "vim",
                "vimdoc",
                "ninja",
                "rst",
                "org",
            },
            -- Autoinstall languages that are not installed
            auto_install = true,
            highlight = {
                enable = true,
                -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
                --  If you are experiencing weird indenting issues, add the language to
                --  the list of additional_vim_regex_highlighting and disabled languages for indent.
                additional_vim_regex_highlighting = { "ruby" },
            },
            indent = { enable = true, disable = { "ruby" } },

            parser_install_info = {
                org = {
                    url = "https://github.com/milisims/tree-sitter-org", -- O repositório da gramática org
                    revision = "main", -- Ou uma revisão/tag específica para estabilidade
                    files = { "src/parser.c", "src/scanner.cc" },
                    -- filetype = "org", -- Pode ser necessário se o Neovim não detectar automaticamente
                },
            },
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<Enter>", -- set to `false` to disable one of the mappings
                node_incremental = "<Enter>",
                scope_incremental = false,
                node_decremental = "<Backspace>",
            },
        },
        -- There are additional nvim-treesitter modules that you can use to interact
        -- with nvim-treesitter. You should go explore a few and see what interests you:
        --
        --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
        --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
        --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    },
}
-- vim: ts=2 sts=2 sw=2 et
