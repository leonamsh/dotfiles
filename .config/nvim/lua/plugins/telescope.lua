return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = function()
            local actions = require("telescope.actions")
            local action_layout = require("telescope.actions.layout")
            local builtin = require("telescope.builtin")

            -- mapeamentos comuns a todos os pickers (insert e normal)
            local common_i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                ["<C-s>"] = actions.select_horizontal, -- split
                ["<C-v>"] = actions.select_vertical, -- vsplit
                ["<C-t>"] = actions.select_tab, -- tab
                ["<F4>"] = action_layout.toggle_preview,
                ["<C-h>"] = "which_key",
                ["<C-u>"] = false, -- deixa <C-u> livre (não apaga input)
            }
            local common_n = {
                ["q"] = actions.close,
                ["s"] = actions.select_horizontal,
                ["v"] = actions.select_vertical,
                ["t"] = actions.select_tab,
                ["<F4>"] = action_layout.toggle_preview,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            }

            return {
                defaults = {
                    sorting_strategy = "ascending",
                    layout_strategy = "flex",
                    layout_config = {
                        horizontal = { prompt_position = "top", preview_width = 0.6 },
                        vertical = { prompt_position = "top", preview_height = 0.45 },
                        height = 0.85,
                        width = 0.80,
                    },
                    border = true,
                    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                    dynamic_preview_title = true,
                    path_display = { "truncate" },
                    file_ignore_patterns = { ".git/" },
                    mappings = { i = common_i, n = common_n },
                },

                pickers = {
                    find_files = { hidden = true, follow = true },
                    live_grep = {
                        additional_args = function()
                            return { "--hidden" }
                        end,
                    },
                    oldfiles = { only_cwd = false },
                    buffers = { sort_mru = true, ignore_current_buffer = true },
                    diagnostics = { bufnr = 0 }, -- “document diagnostics” como no seu fzf-lua
                },

                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                    file_browser = {
                        path = vim.loop.cwd(),
                        cwd = vim.loop.cwd(),
                        grouped = false,
                        files = true,
                        add_dirs = true,
                        depth = 1,
                        hidden = { file_browser = false, folder_browser = false },
                        respect_gitignore = vim.fn.executable("fd") == 1,
                        no_ignore = false,
                        follow_symlinks = false,
                        display_stat = { date = true, size = true, mode = true },
                        hijack_netrw = false,
                        git_status = true,
                        mappings = {
                            ["i"] = {
                                ["<A-c>"] = require("telescope._extensions.file_browser.actions").create,
                                ["<S-CR>"] = require("telescope._extensions.file_browser.actions").create_from_prompt,
                                ["<A-r>"] = require("telescope._extensions.file_browser.actions").rename,
                                ["<A-m>"] = require("telescope._extensions.file_browser.actions").move,
                                ["<A-y>"] = require("telescope._extensions.file_browser.actions").copy,
                                ["<A-d>"] = require("telescope._extensions.file_browser.actions").remove,
                                ["<C-o>"] = require("telescope._extensions.file_browser.actions").open,
                                ["<C-g>"] = require("telescope._extensions.file_browser.actions").goto_parent_dir,
                                ["<C-e>"] = require("telescope._extensions.file_browser.actions").goto_home_dir,
                                ["<C-w>"] = require("telescope._extensions.file_browser.actions").goto_cwd,
                                ["<C-t>"] = require("telescope._extensions.file_browser.actions").change_cwd,
                                ["<C-f>"] = require("telescope._extensions.file_browser.actions").toggle_browser,
                                ["<C-h>"] = require("telescope._extensions.file_browser.actions").toggle_hidden,
                                ["<C-s>"] = require("telescope._extensions.file_browser.actions").toggle_all,
                                ["<bs>"] = require("telescope._extensions.file_browser.actions").backspace,
                            },
                            ["n"] = {
                                ["c"] = require("telescope._extensions.file_browser.actions").create,
                                ["r"] = require("telescope._extensions.file_browser.actions").rename,
                                ["m"] = require("telescope._extensions.file_browser.actions").move,
                                ["y"] = require("telescope._extensions.file_browser.actions").copy,
                                ["d"] = require("telescope._extensions.file_browser.actions").remove,
                                ["o"] = require("telescope._extensions.file_browser.actions").open,
                                ["g"] = require("telescope._extensions.file_browser.actions").goto_parent_dir,
                                ["e"] = require("telescope._extensions.file_browser.actions").goto_home_dir,
                                ["w"] = require("telescope._extensions.file_browser.actions").goto_cwd,
                                ["t"] = require("telescope._extensions.file_browser.actions").change_cwd,
                                ["f"] = require("telescope._extensions.file_browser.actions").toggle_browser,
                                ["h"] = require("telescope._extensions.file_browser.actions").toggle_hidden,
                                ["s"] = require("telescope._extensions.file_browser.actions").toggle_all,
                            },
                        },
                    },
                },
            }
        end,
        config = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)
            -- carregar extensões aqui (se instaladas)
            pcall(telescope.load_extension, "fzf")
            pcall(telescope.load_extension, "file_browser")

            local builtin = require("telescope.builtin")

            -- ======= atalhos espelhando seu fzf-lua =======
            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files (project)" })
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Grep in project" })
            vim.keymap.set("n", "<leader>fc", function()
                builtin.find_files({ cwd = vim.fn.stdpath("config") })
            end, { desc = "Find in Neovim config" })
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
            vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
            vim.keymap.set("n", "<leader>fb", builtin.builtin, { desc = "[F]ind [B]uiltin pickers" })
            vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Grep current cword" })
            vim.keymap.set("n", "<leader>fW", function()
                builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
            end, { desc = "Grep current cWORD" })
            vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Find diagnostics (buffer)" })
            vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
            vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Buffers" })
            vim.keymap.set(
                "n",
                "<leader>/",
                builtin.current_buffer_fuzzy_find,
                { desc = "Fuzzy find in current buffer" }
            )

            -- atalhos extras úteis
            vim.keymap.set("n", "<leader>fe", function()
                telescope.extensions.file_browser.file_browser({ path = "%:p:h", select_buffer = true })
            end, { desc = "File Browser (cwd)" })

            vim.keymap.set("n", "<leader>fE", function()
                telescope.extensions.file_browser.file_browser({ path = vim.fn.stdpath("config") })
            end, { desc = "File Browser (nvim config)" })
        end,
    },
}
