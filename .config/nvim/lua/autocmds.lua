--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: autocmds.lua
-- Description: Autocommand functions
-- Author: Kien Nguyen-Tuan <kiennt2609@gmail.com>
-- Define autocommands with Lua APIs
-- See: h:api-autocmd, h:augroup
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- General settings

-- Highlight on yank
autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = "1000"
        })
    end
})

-- Remove whitespace on save
autocmd("BufWritePre", {
    pattern = "",
    command = ":%s/\\s\\+$//e"
})

-- Auto format on save using the attached (optionally filtered) language servere clients
-- https://neovim.io/doc/user/lsp.html#vim.lsp.buf.format()
-- autocmd("BufWritePre", {
--     pattern = "",
--     command = ":silent lua vim.lsp.buf.format()"
-- })
autocmd("BufWritePre", {
    callback = function(args)
        local ft = vim.bo[args.buf].filetype
        if ft == "cs" then
            vim.lsp.buf.format({
                bufnr = args.buf,
                filter = function(client) return client.name == "omnisharp" end,
                timeout_ms = 4000,
            })
            return
        end

        local clients = vim.lsp.get_clients({ bufnr = args.buf })
        local has_formatter = false

        for _, client in ipairs(clients) do
            if client.server_capabilities
                and client.server_capabilities.documentFormattingProvider
            then
                has_formatter = true
                break
            end
        end

        if not has_formatter then
            return
        end

        -- for everything else, keep your normal behavior (optional)
        vim.lsp.buf.format({ bufnr = args.buf, timeout_ms = 4000 })
    end,
})

-- Don't auto commenting new lines
autocmd("BufEnter", {
    pattern = "",
    command = "set fo-=c fo-=r fo-=o"
})

autocmd("Filetype", {
    pattern = { "xml", "html", "xhtml", "css", "scss", "javascript", "typescript", "lua" },
    command = "setlocal shiftwidth=4 tabstop=4"
})

autocmd("Filetype", {
    pattern = { "yml" },
    command = "setlocal shiftwidth=2 tabstop=2"
})

autocmd("Filetype", {
    pattern = { "gitcommit", "markdown", "text" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end
})

vim.api.nvim_create_user_command("TreeOnly", function()
    -- Open the tree (creates the split)
    require("nvim-tree.api").tree.open()

    -- Find all other windows and close them
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local name = vim.api.nvim_buf_get_name(buf)
        if not name:match("NvimTree_") then
            vim.api.nvim_win_close(win, true)
        end
    end

    -- Focus the tree window
    require("nvim-tree.api").tree.focus()
end, {})

-- Codeium setup
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.cmd("Codeium Enable")
    end,
})


-- TreeOnly command setup
vim.api.nvim_create_user_command("Wt", "w | TreeOnly", {})
vim.cmd("cnoreabbrev wt Wt")
