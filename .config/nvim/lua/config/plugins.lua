-- File for plugin initialization via lazy and their settings and keymaps.
-- The config designed in a way that you can remove line that adds this file
-- from init.lua and have everything working without plugins.

local helpers = require("config.helpers")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "Press any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "neovim/nvim-lspconfig",
        lazy = false,
    },

    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                go = { "goimports", "gofumpt" },
                python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },
            },
        },
    },

    {
        "nvim-lua/plenary.nvim",
        lazy = false,
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        cmd = "Telescope",
        opts = function()
            local actions = require("telescope.actions")

            return {
                defaults = {
                    prompt_prefix = "   ",
                    selection_caret = "  ",
                    entry_prefix = " ",
                    sorting_strategy = "ascending",
                    layout_config = {
                        horizontal = {
                            prompt_position = "top",
                            preview_width = 0.55,
                        },
                        width = 0.87,
                        height = 0.80,
                    },
                    file_ignore_patterns = {
                        "node_modules",
                        "%.git/",
                        "vendor/",
                    },
                    mappings = {
                        n = {
                            ["q"] = actions.close,
                        },
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true,
                    },
                },
            }
        end,
    },

    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "│" },
                change = { text = "│" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "┆" },
            },
            current_line_blame = false,
        },
    },

    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    },

    {
        "nvim-mini/mini.surround",
        version = false,
        opts = {
            mappings = {
                add = "ga",
                delete = "gr",
                find = "gf",
                find_left = "gF",
                highlight = "gh",
                replace = "gR",
                suffix_last = "l",
                suffix_next = "n",
            },
        },
    },

    {
        "saghen/blink.cmp",
        opts = {
            fuzzy = {
                implementation = "lua",
            },
            keymap = {
                preset = "default",
                ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
                ["<CR>"] = { "accept", "fallback" },
                ["<Tab>"] = { "select_next", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
            },
            completion = {
                documentation = {
                    auto_show = false,
                },
            },
            sources = {
                default = { "lsp", "path", "buffer" },
            },
        },
    },


    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local ts = require("nvim-treesitter")

            ts.setup({
                install_dir = vim.fn.stdpath("data") .. "/site",
            })

            ts.install({
                "lua",
                "vim",
                "vimdoc",
                "query",
                "markdown",
                "markdown_inline",
                "html",
                "yaml",
                "json",
                "toml",
                "bash",
                "python",
                "go",
                "java",
                "javascript",
                "c_sharp",
                "clojure",
            }):wait(300000)

            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "lua",
                    "vim",
                    "markdown",
                    "html",
                    "yaml",
                    "json",
                    "toml",
                    "sh",
                    "python",
                    "go",
                    "java",
                    "javascript",
                    "cs",
                    "clojure",
                },
                callback = function()
                    vim.treesitter.start()
                end,
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "lua",
                    "vim",
                    "markdown",
                    "html",
                    "yaml",
                    "json",
                    "toml",
                    "sh",
                    "python",
                    "go",
                    "java",
                    "javascript",
                    "cs",
                    "clojure",
                },
                callback = function()
                    vim.wo.foldmethod = "expr"
                    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                end,
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "lua",
                    "python",
                    "go",
                    "sh",
                    "yaml",
                    "json",
                    "toml",
                    "html",
                    "java",
                    "javascript",
                    "cs",
                    "clojure",
                },
                callback = function()
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        event = { "BufReadPre", "BufNewFile" },
        ft = { "markdown" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            file_types = { "markdown" },
        },
    },

    {
        "stevearc/oil.nvim",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = (function()
            local keys = {}
            vim.list_extend(keys, helpers.make_lazy_bilang_keys("<leader>t", "<leader>е", "<cmd>Oil<CR>", "Open parent directory in Oil"))
            return keys
        end)(),
        opts = function()
            local keymaps = {
                ["<CR>"] = "actions.select",
            }

            helpers.add_bilang_table_keymap(keymaps, "<C-l>", "<C-д>", "actions.refresh")
            helpers.add_bilang_table_keymap(keymaps, "gx", "пч", "actions.open_external")
            helpers.add_bilang_table_keymap(keymaps, "<C-h>", "<C-р>", { "actions.toggle_hidden", mode = "n" })
            helpers.add_bilang_table_keymap(keymaps, "g?", "п?", { "actions.show_help", mode = "n" })

            return {
                default_file_explorer = true,
                columns = {
                    "icon",
                },
                buf_options = {
                    buflisted = false,
                    bufhidden = "hide",
                },
                win_options = {
                    spell = false,
                    list = false,
                    concealcursor = "nvic",
                },
                skip_confirm_for_simple_edits = true,
                prompt_save_on_select_new_entry = true,
                watch_for_changes = true,
                delete_to_trash = true,

                keymaps = keymaps,

                view_options = {
                    show_hidden = false,

                    is_hidden_file = function(name, _)
                        local hidden_patterns = {
                            "^%.git$",
                            "^%.idea$",
                            "^%.vscode$",
                            "^__pycache__$",
                            "%.pyc$",
                            "%.pyo$",
                        }

                        for _, pattern in ipairs(hidden_patterns) do
                            if name:match(pattern) then
                                return true
                            end
                        end

                        return name:match("^%.") ~= nil
                    end,

                    is_always_hidden = function(name, _)
                        return name == ".."
                    end,

                    natural_order = "fast",
                    sort = {
                        { "type", "asc" },
                        { "name", "asc" },
                    },
                },
            }
        end,
    },

    {
        "rose-pine/neovim",
        lazy = true,
        name = "rose-pine",
        opts = {
            styles = {
                transparency = true,
            },
        },
    },

    {
        "folke/tokyonight.nvim",
        lazy = true,
        opts = {
            transparent = true,
        },
    },
})

-- colorscheme settings
-- vim.cmd("colorscheme rose-pine")
vim.cmd("colorscheme tokyonight")

-- treesitter settings
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- lsp settings
pcall(require, "lspconfig")

vim.lsp.config("ruff", {
    cmd = { "ruff", "server" },
})

vim.lsp.enable("ruff")
vim.lsp.enable("gopls")
vim.lsp.enable("pyright")
vim.lsp.enable("csharp_ls")

-- Gitsigns settings
local gitsigns = require("gitsigns")

local function nav_and_preview_inline(direction)
    return function()
        if vim.wo.diff then
            if direction == "next" then
                vim.cmd.normal({ "]c", bang = true })
            else
                vim.cmd.normal({ "[c", bang = true })
            end
            return
        end

        gitsigns.nav_hunk(direction)

        vim.defer_fn(function()
            pcall(gitsigns.preview_hunk_inline)
        end, 50)
    end
end

helpers.bind_bilang("n", "<A-j>", "<A-о>", nav_and_preview_inline("next"), { desc = "Next hunk + inline preview" })
helpers.bind_bilang("n", "<A-k>", "<A-л>", nav_and_preview_inline("prev"), { desc = "Prev hunk + inline preview" })

helpers.bind_bilang("n", "<leader>b", "<leader>и", "<cmd>Gitsigns blame_line<CR>", { desc = "blame line under cursor" })
helpers.bind_bilang("n", "<leader>h", "<leader>р", "<cmd>Gitsigns preview_hunk<CR>", { desc = "preview hunk" })
helpers.bind_bilang("n", "<leader>st", "<leader>ые", "<cmd>Gitsigns stage_hunk<CR>", { desc = "stage / unstage hunk" })
