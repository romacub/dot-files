-- File for plugin initialization via lazy and their settings and keymaps.
-- The config designed in a way that you can remove line that adds this file
-- from init.lua and have everything working without plugins.

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
        keys = {
            { "<leader>t", "<cmd>Oil<CR>", desc = "Open parent directory in Oil" },
            { "<leader>е", "<cmd>Oil<CR>", desc = "Open parent directory in Oil" },
        },
        opts = {
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

            keymaps = {
                ["<CR>"] = "actions.select",
                ["<C-l>"] = "actions.refresh",
                ["gx"] = "actions.open_external",
                ["<C-h>"] = { "actions.toggle_hidden", mode = "n" },
                ["g?"] = { "actions.show_help", mode = "n" },

                ["<C-д>"] = "actions.refresh",
                ["пч"] = "actions.open_external",
                ["<C-р>"] = { "actions.toggle_hidden", mode = "n" },
                ["п?"] = { "actions.show_help", mode = "n" },
            },

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
        },
    },

    {
        "rose-pine/neovim",
        name = "rose-pine",
    },

    {
        "folke/tokyonight.nvim",
    },
})

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
