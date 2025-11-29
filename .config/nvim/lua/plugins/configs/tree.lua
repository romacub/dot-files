--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/configs/tree.lua
-- Description: nvim-tree config
-- Author: Kien Nguyen-Tuan <kiennt2609@gmail.com>
local nvim_tree = require("nvim-tree")

nvim_tree.setup({
    filters = {
        dotfiles = false
    },
    disable_netrw = true,
    hijack_netrw = true,
    hijack_cursor = true,
    hijack_unnamed_buffer_when_opening = false,
    sync_root_with_cwd = true,
    update_focused_file = {
        enable = true,
        update_root = false
    },
    view = {
        side = "left",
        width = 30,
        preserve_window_proportions = false,
    },
    git = {
        enable = false,
        ignore = true
    },
    filesystem_watchers = {
        enable = true
    },
    actions = {
        open_file = {
            resize_window = true,
            quit_on_open = true,
            window_picker = {
                enable = false,
            },
        }
    },
    renderer = {
        root_folder_label = false,
        highlight_git = false,
        highlight_opened_files = "none",

        indent_markers = {
            enable = false
        },

        icons = {
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = false
            },

            glyphs = {
                default = "󰈚",
                symlink = "",
                folder = {
                    default = "",
                    empty = "",
                    empty_open = "",
                    open = "",
                    symlink = "",
                    symlink_open = "",
                    arrow_open = "",
                    arrow_closed = ""
                },
                git = {
                    unstaged = "✗",
                    staged = "✓",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "★",
                    deleted = "",
                    ignored = "◌"
                }
            }
        }
    }
})

-- 🔥 Ensure nvim-tree closes when opening a file
vim.api.nvim_create_autocmd("BufEnter", {
    nested = true,
    callback = function()
        local bufname = vim.api.nvim_buf_get_name(0)
        if not bufname:match("NvimTree_") then
            vim.cmd("NvimTreeClose")
        end
    end,
})
