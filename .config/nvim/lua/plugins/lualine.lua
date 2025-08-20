local lualine_trunc_margin = 80

local function truncateCondition()
    return vim.o.columns >= lualine_trunc_margin
end

-- Used for shortening Mode in smaller terminals
local mode_map = {
    ["NORMAL"] = "N",
    ["INSERT"] = "I",
    ["VISUAL"] = "V",
    ["V-LINE"] = "VL",
    ["V-BLOCK"] = "VB",
    ["COMMAND"] = "C",
    ["TERMINAL"] = "T",
    ["REPLACE"] = "R",
}

local function formatMode(str)
    if vim.o.columns < lualine_trunc_margin then
        return mode_map[str] or str
    end
    return str
end

local function getColumnPosition()
    local col = "%v"
    local max_col = "%{virtcol('$')-1}"
    if not truncateCondition() then
        return string.format("%s", col)
    else
        return string.format("%s\u{23ae}%s", col, max_col)
    end
end

local function getRowPosition()
    local row = "%l"
    local max_row = "%L"
    if not truncateCondition() then
        return string.format("%s", row)
    else
        return string.format("%s\u{23ae}%s", row, max_row)
    end
end

local function getWindowNumber()
    return vim.api.nvim_win_get_number(0)
end

return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup({
            options = {
                section_separators = {
                    -- Full diagonal dividers bottom left to top right
                    left = "\u{e0bc}",
                    right = "\u{e0ba}",
                },
                component_separators = {
                    -- Hairline diagonal dividers bottom left to top right
                    left = "\u{e0bd}",
                    right = "\u{e0bb}",
                },
                globalstatus = true,
                icons_enabled = true,
            },
            sections = {
                lualine_a = {
                    {
                        "mode",
                        fmt = formatMode,
                    },
                },
                lualine_b = { "branch", "diff" },
                lualine_c = {
                    {
                        "diagnostics",
                        -- Override with "fat" symbols
                        symbols = {
                            error = " ",
                            hint = " ",
                            info = " ",
                            warn = " ",
                        },
                        cond = truncateCondition,
                        separator = "",
                    },
                    {
                        -- Center filename section
                        function()
                            return "%="
                        end,
                        separator = "",
                    },
                    {
                        "filetype",
                        icon_only = true,
                        separator = "",
                        padding = {
                            left = 1,
                            right = 0,
                        },
                    },
                    {
                        "filename",
                        file_status = true,
                        path = 1,
                        shorting_target = 40,
                        symbols = {
                            modified = "󰐖 ", -- Show when file is modified
                            readonly = " ", -- Show when file is readonly
                            unnamed = "[No Name]", -- Show when Buffer has no name
                            newfile = "[New]", -- Show when file hasn't been saved yet
                        },
                    },
                },
                lualine_x = {},
                lualine_y = {
                    {
                        "branch",
                        cond = truncateCondition,
                    },
                },
                lualine_z = {
                    getColumnPosition,
                    getRowPosition,
                },
            },
            inactive_sections = {
                lualine_a = {
                    {
                        getWindowNumber,
                        color = inactive_primary_color,
                        separator = {
                            -- The base configuration is ignored here for some reason I don't
                            -- know. However this fixes the right diagonal separator
                            right = "\u{e0bc}",
                        },
                    },
                },
                lualine_b = {},
                lualine_c = {
                    {
                        -- Center filename section
                        function()
                            return "%="
                        end,
                        separator = "",
                    },
                    {
                        "filename",
                        file_status = true,
                        path = 1,
                        shorting_target = 40,
                        symbols = {
                            modified = "󰐖 ", -- Show when file is modified
                            readonly = " ", -- Show when file is readonly
                            unnamed = "[No Name]", -- Show when Buffer has no name
                            newfile = "[New]", -- Show when file hasn't been saved yet
                        },
                        -- color = { fg = require("config.util").getColor("Grey", "fg") },
                    },
                },
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
            extensions = {
                "oil",
            },
        })
    end,
}
