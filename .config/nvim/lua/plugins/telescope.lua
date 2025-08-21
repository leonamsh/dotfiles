return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- fzf-native junto no mesmo arquivo
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = table.concat({
                    "cmake -S. -Bbuild",
                    "-DCMAKE_BUILD_TYPE=Release",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", -- 👈 força políticas >= 3.5
                    "&& cmake --build build --config Release",
                }, " "),
            },
            -- file-browser junto no mesmo arquivo
            "nvim-telescope/telescope-file-browser.nvim",
        },

        opts = function()
            local actions = require("telescope.actions")
            local action_layout = require("telescope.actions.layout")
            local themes = require("telescope.themes")

            -- mapeamentos comuns
            local common_i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                ["<C-s>"] = actions.select_horizontal,
                ["<C-v>"] = actions.select_vertical,
                ["<C-t>"] = actions.select_tab,
                ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
                ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
                ["<F4>"] = action_layout.toggle_preview,
                ["<C-h>"] = "which_key",
                ["<C-u>"] = false,
            }
            local common_n = {
                ["q"] = actions.close,
                ["s"] = actions.select_horizontal,
                ["v"] = actions.select_vertical,
                ["t"] = actions.select_tab,
                ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
                ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                ["<F4>"] = action_layout.toggle_preview,
            }

            -- estilo global
            local defaults = {
                sorting_strategy = "ascending",
                layout_strategy = "flex",
                layout_config = {
                    horizontal = { prompt_position = "top", preview_width = 0.55 },
                    vertical = { prompt_position = "top", preview_height = 0.45 },
                    width = 0.88,
                    height = 0.85,
                },
                prompt_prefix = "   ",
                selection_caret = " ",
                entry_prefix = "  ",
                multi_icon = " ",
                results_title = false,
                color_devicons = true,
                border = true,
                borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                winblend = 8,
                dynamic_preview_title = true,
                path_display = { "truncate" }, -- seguro em qualquer versão
                file_ignore_patterns = { ".git/" },
                mappings = { i = common_i, n = common_n },
            }

            -- pickers com temas diferentes
            local pickers = {
                find_files = themes.get_dropdown({
                    previewer = false,
                    hidden = true,
                    follow = true,
                    layout_config = { width = 0.5, height = 0.6 },
                }),

                buffers = themes.get_dropdown({
                    previewer = false,
                    sort_mru = true,
                    ignore_current_buffer = true,
                    layout_config = { width = 0.6, height = 0.6 },
                    attach_mappings = function(_, map)
                        map("i", "<C-d>", actions.delete_buffer)
                        map("n", "d", actions.delete_buffer)
                        return true
                    end,
                }),

                live_grep = themes.get_ivy({
                    additional_args = function()
                        return { "--hidden" }
                    end,
                    layout_config = { height = 0.5 },
                }),

                current_buffer_fuzzy_find = themes.get_ivy({
                    layout_config = { height = 0.4 },
                }),

                diagnostics = themes.get_cursor({ previewer = true }),

                oldfiles = themes.get_dropdown({
                    previewer = false,
                    only_cwd = false,
                    layout_config = { width = 0.6, height = 0.6 },
                }),

                help_tags = themes.get_dropdown({ previewer = false }),
                keymaps = themes.get_dropdown({ previewer = false }),
            }

            -- opções básicas de extensões (mapeamentos do file-browser entram depois)
            local extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
                file_browser = themes.get_ivy({
                    hijack_netrw = false,
                    grouped = false,
                    files = true,
                    add_dirs = true,
                    depth = 1,
                    respect_gitignore = true,
                    hidden = { file_browser = false, folder_browser = false },
                    display_stat = { date = true, size = true, mode = true },
                }),
            }

            return { defaults = defaults, pickers = pickers, extensions = extensions }
        end,

        config = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)

            -- carregar extensões após o setup
            pcall(telescope.load_extension, "fzf")
            pcall(telescope.load_extension, "file_browser")

            -- só agora é seguro requerer as actions do file_browser e “injetar” os mappings
            local ok, fb_actions = pcall(require, "telescope._extensions.file_browser.actions")
            if ok then
                telescope.setup({
                    extensions = {
                        file_browser = {
                            mappings = {
                                i = {
                                    ["<A-c>"] = fb_actions.create,
                                    ["<S-CR>"] = fb_actions.create_from_prompt,
                                    ["<A-r>"] = fb_actions.rename,
                                    ["<A-m>"] = fb_actions.move,
                                    ["<A-y>"] = fb_actions.copy,
                                    ["<A-d>"] = fb_actions.remove,
                                    ["<C-g>"] = fb_actions.goto_parent_dir,
                                    ["<C-e>"] = fb_actions.goto_home_dir,
                                    ["<C-w>"] = fb_actions.goto_cwd,
                                    ["<C-t>"] = fb_actions.change_cwd,
                                    ["<C-h>"] = fb_actions.toggle_hidden,
                                    ["<bs>"] = fb_actions.backspace,
                                },
                                n = {
                                    ["c"] = fb_actions.create,
                                    ["r"] = fb_actions.rename,
                                    ["m"] = fb_actions.move,
                                    ["y"] = fb_actions.copy,
                                    ["d"] = fb_actions.remove,
                                    ["g"] = fb_actions.goto_parent_dir,
                                    ["e"] = fb_actions.goto_home_dir,
                                    ["w"] = fb_actions.goto_cwd,
                                    ["t"] = fb_actions.change_cwd,
                                    ["h"] = fb_actions.toggle_hidden,
                                },
                            },
                        },
                    },
                })
            end

            -- keymaps
            local builtin = require("telescope.builtin")

            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Files (dropdown)" })
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Grep (ivy)" })
            vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent (dropdown)" })
            vim.keymap.set("n", "<leader>fc", ":e ~/.config/nvim<CR>", { desc = "Config (nvim)" })
            vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Buffers (dropdown)" })
            vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Fuzzy in buffer (ivy)" })
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help (dropdown)" })
            vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Keymaps (dropdown)" })
            vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Word under cursor" })
            vim.keymap.set("n", "<leader>fW", function()
                builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
            end, { desc = "WORD under cursor" })
            vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics (cursor)" })

            -- atalhos para o file browser
            vim.keymap.set("n", "<leader>fe", function()
                telescope.extensions.file_browser.file_browser({ path = "%:p:h", select_buffer = true })
            end, { desc = "File Browser (cwd)" })
            vim.keymap.set("n", "<leader>fE", function()
                telescope.extensions.file_browser.file_browser({ path = vim.fn.stdpath("config") })
            end, { desc = "File Browser (nvim config)" })
        end,
    },
}
