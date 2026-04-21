-- File for keymaps. For now it contains a little bit of plugins setttings like conform
-- but it is yet to be moved to plugins.lua.

local helpers = require("config.helpers")

local function visual_paste_from_plus_and_store_selection()
    local plus = vim.fn.getreg('+', 1, true)
    local plus_type = vim.fn.getregtype('+')
    vim.cmd('normal! "+y')
    vim.cmd('normal! gv"_d')
    vim.fn.setreg('z', plus, plus_type)
    vim.cmd('normal! "zP')
end

-- disable for Oil  trial period
-- local function call_netrw()
--     vim.cmd('only')
--     local current_dir = vim.fn.expand('%:p:h')
--     if current_dir == '' then
--         current_dir = vim.loop.cwd()
--     end
--     vim.cmd('Explore ' .. vim.fn.fnameescape(current_dir))
-- end

local function format_current_buffer()
    local ft = vim.bo.filetype

    if ft == "go" then
        local ok, conform = pcall(require, "conform")
        if ok then
            conform.format({
                async = true,
                lsp_fallback = false,
            })
            return
        end
    end

    if ft == "python" then
        local ok, conform = pcall(require, "conform")
        if ok then
            conform.format({
                async = true,
                lsp_fallback = false,
            })
            return
        end
    end

    if ft == "cs" then
        vim.lsp.buf.format({
            async = true,
            filter = function(client)
                return client.name == "csharp_ls"
            end,
        })
        return
    end

    vim.lsp.buf.format({ async = true })
end

local function show_a_diag_at_index(x)
    vim.diagnostic.jump({
        count = x,
        float = {
            border = "single",
            source = true,
            prefix = " ⚠ ",
        }
    })
end

local function telescope_builtin(name)
    return function()
        require("telescope.builtin")[name]()
    end
end

local gitsigns = require("gitsigns")

local function nav_and_preview(direction)
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
            pcall(vim.cmd, "pclose")
            pcall(gitsigns.preview_hunk)
        end, 50)
    end
end

-- disabled for Oil trial period
-- helpers.bind_bilang('n', 't', 'е', call_netrw, { desc = 'open file explorer in current directory' })

helpers.bind_bilang('n', 'Y', 'Н', [[y$]], { desc = 'yank from cursor to the end of the line to system clipboard' })
helpers.bind_bilang('v', '<leader>p', '<leader>з', [["_d"+P]], { desc = 'paste from clipboard replacing selection without yanking' })
helpers.bind_bilang({ 'n', 'v' }, '<leader>d', '<leader>в', [["_d]], { desc = 'delete without saving to any register' })
helpers.bind_bilang({ 'n', 'v' }, '<leader>D', '<leader>В', [["_D]], { desc = 'delete from cursor to the end of the line without saving to any register' })
helpers.bind_bilang('v', 'p', 'з', visual_paste_from_plus_and_store_selection, { desc = 'swap visual selection with clipboard content' })

vim.keymap.set('n', '<Esc>', function() vim.cmd("nohlsearch") end, { desc = 'clear search highlights until next time' })
helpers.bind_bilang('x', 'J', 'О', ":m '>+1<CR>gv-gv", { desc = 'move selected lines down', silent = true })
helpers.bind_bilang('x', 'K', 'Л', ":m '<-2<CR>gv-gv", { desc = 'move selected lines up', silent = true })
helpers.bind_bilang('n', 'J', 'О', "mzJ`z", { desc = 'join lines while preserving cursor position' })
helpers.bind_bilang('n', '<C-u>', '<C-г>', '20kzz', { desc = 'scroll up 20 lines and center screen' })
helpers.bind_bilang('n', '<C-d>', '<C-в>', '20jzz', { desc = 'scroll down 20 lines and center screen' })
helpers.bind_bilang('n', 'n', 'т', 'nzzzv', { desc = 'next search result with screen centered' })
helpers.bind_bilang('n', 'N', 'Т', 'Nzzzv', { desc = 'previous search result with screen centered' })
vim.keymap.set('n', 'Q', '<nop>', { desc = 'disable ex mode' })
helpers.bind_bilang('n', '<leader>s', '<leader>ы', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/cgI<Left><Left><Left><Left>]], { desc = 'search and replace word under cursor' })
helpers.bind_bilang('v', '<leader>s', '<leader>ы', [["zy:<C-U>%s/<C-r>z/<C-r>z/cgI<Left><Left><Left><Left>]], { desc = 'search and replace visual selection' })
vim.keymap.set('n', '<leader>=', function()
    local view = vim.fn.winsaveview()
    vim.cmd('normal! gg=G``')
    vim.fn.winrestview(view)
end, { desc = 'format current buffer with built-in formatter' })

helpers.bind_bilang("n", "<leader>f", "<leader>а", format_current_buffer, { desc = "Format current buffer" })

helpers.bind_bilang("n", "K", "Л", vim.lsp.buf.hover, { desc = "LSP hover" })
helpers.bind_bilang("n", "gd", "пв", vim.lsp.buf.definition, { desc = "Go to definition" })
helpers.bind_bilang("n", "gD", "пВ", vim.lsp.buf.declaration, { desc = "Go to declaration" })
helpers.bind_bilang("n", "gi", "пш", vim.lsp.buf.implementation, { desc = "Go to implementation" })
helpers.bind_bilang("n", "gr", "пк", vim.lsp.buf.references, { desc = "References" })
helpers.bind_bilang("n", "<leader>rn", "<leader>кт", vim.lsp.buf.rename, { desc = "Rename" })
helpers.bind_bilang({ "n", "v" }, "<leader>a", "<leader>ф", vim.lsp.buf.code_action, { desc = "Code action" })

helpers.bind_bilang("n", "<C-k>", "<C-л>", function() show_a_diag_at_index(-1) end, { desc = "show previous diagnostic" })
helpers.bind_bilang("n", "<C-j>", "<C-о>", function() show_a_diag_at_index(1) end, { desc = "show next diagnostic" })

helpers.bind_bilang("n", "<leader>ff", "<leader>аа", telescope_builtin("find_files"), { desc = "Find files" })
helpers.bind_bilang("n", "<leader>fg", "<leader>ап", telescope_builtin("live_grep"), { desc = "Live grep" })
helpers.bind_bilang("n", "<leader>fb", "<leader>фи", telescope_builtin("buffers"), { desc = "Buffers" })
helpers.bind_bilang("n", "<leader>fh", "<leader>өр", telescope_builtin("help_tags"), { desc = "Help tags" })
helpers.bind_bilang("n", "<leader>fo", "<leader>щ", telescope_builtin("oldfiles"), { desc = "Recent files" })
helpers.bind_bilang("n", "<leader>fw", "<leader>ц", telescope_builtin("grep_string"), { desc = "Grep word under cursor" })
helpers.bind_bilang("n", "<leader>fd", "<leader>в", telescope_builtin("diagnostics"), { desc = "Diagnostics" })

helpers.bind_bilang("n", "<leader>do", "<leader>вщ", "<cmd>DiffviewOpen<CR>", { desc = "Open diffview" })
helpers.bind_bilang("n", "<leader>dc", "<leader>вс", "<cmd>DiffviewClose<CR>", { desc = "Close diffview" })
helpers.bind_bilang("n", "<leader>dh", "<leader>вр", "<cmd>DiffviewFileHistory %<CR>", { desc = "File history" })

vim.keymap.set("n", "]h", nav_and_preview("next"), { desc = "Next hunk + preview" })
vim.keymap.set("n", "[h", nav_and_preview("prev"), { desc = "Prev hunk + preview" })
vim.keymap.set("n", "<leader>b", "<cmd>Gitsigns blame_line<CR>", { desc = "blame line under cursor" })
vim.keymap.set("n", "<leader>h", "<cmd>Gitsigns preview_hunk<CR>", { desc = "preview hunk" })
vim.keymap.set("n", "<leader>st", "<cmd>Gitsigns stage_hunk<CR>", { desc = "stage / unstage hunk" })
