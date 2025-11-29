--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: mappings.lua
-- Description: Key mapping configs
-- Author: theprimeagen
vim = vim

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>t", vim.cmd.TreeOnly)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "20jzz")
vim.keymap.set("n", "<C-u>", "20kzz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
-- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action)
vim.keymap.set("v", "<leader>a", vim.lsp.buf.code_action)

-- telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope lsp_references<cr>")

vim.keymap.set("n", "<leader>s", [[:%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Diagnostic keymaps
vim.keymap.set("n", "<C-k>", function()
    vim.diagnostic.jump({
        count = -1,
        float = {
            border = "single",
            source = true,
            prefix = " ⚠ ",
        }
    })
end, { desc = "Previous diagnostic" })

vim.keymap.set("n", "<C-j>", function()
    vim.diagnostic.jump({
        count = 1,
        float = {
            border = "single",
            source = true,
            prefix = " ⚠ ",
        }
    })
end, { desc = "Next diagnostic" })
-- unmapping arrows
vim.keymap.set("n", "<Up>", "<nop>", { silent = true })
vim.keymap.set("n", "<Down>", "<nop>", { silent = true })
vim.keymap.set("n", "<Left>", "<nop>", { silent = true })
vim.keymap.set("n", "<Right>", "<nop>", { silent = true })

vim.keymap.set("v", "<Up>", "<nop>", { silent = true })
vim.keymap.set("v", "<Down>", "<nop>", { silent = true })
vim.keymap.set("v", "<Left>", "<nop>", { silent = true })
vim.keymap.set("v", "<Right>", "<nop>", { silent = true })

vim.keymap.set("i", "<Up>", "<nop>", { silent = true })
vim.keymap.set("i", "<Down>", "<nop>", { silent = true })
vim.keymap.set("i", "<Left>", "<nop>", { silent = true })
vim.keymap.set("i", "<Right>", "<nop>", { silent = true })

-- Codeium key mappings
vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
-- vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
-- vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
