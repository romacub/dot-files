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
-- vim.keymap.set('n', '<leader>t', call_netrw, { desc = 'open file explorer in current directory' })
-- vim.keymap.set('n', '<leader>е', call_netrw, { desc = 'open file explorer in current directory' })

vim.keymap.set('n', 'Y', [[y$]], { desc = 'yank from cursor to the end of the line to system clipboard' })
vim.keymap.set('v', '<leader>p', [["_d"+P]], { desc = 'paste from clipboard replacing selection without yanking' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]], { desc = 'delete without saving to any register' })
vim.keymap.set({ 'n', 'v' }, '<leader>D', [["_D]], { desc = 'delete from cursor to the end of the line without saving to any register' })
vim.keymap.set('v', 'p', visual_paste_from_plus_and_store_selection, { desc = 'swap visual selection with clipboard content' })

vim.keymap.set('n', 'Н', [[y$]], { desc = 'yank from cursor to the end of the line to system clipboard' })
vim.keymap.set('v', '<leader>з', [["_d"+P]], { desc = 'paste from clipboard replacing selection without yanking' })
vim.keymap.set({ 'n', 'v' }, '<leader>в', [["_d]], { desc = 'delete without saving to any register' })
vim.keymap.set({ 'n', 'v' }, '<leader>В', [["_D]], { desc = 'delete from cursor to the end of the line without saving to any register' })
vim.keymap.set('v', 'з', visual_paste_from_plus_and_store_selection, { desc = 'swap visual selection with clipboard content' })

vim.keymap.set('n', '<Esc>', function() vim.cmd("nohlsearch") end, { desc = 'clear search highlights until next time' })
vim.keymap.set('x', 'J', ":m '>+1<CR>gv-gv", { desc = 'move selected lines down', silent = true })
vim.keymap.set('x', 'K', ":m '<-2<CR>gv-gv", { desc = 'move selected lines up', silent = true })
vim.keymap.set('n', 'J', "mzJ`z", { desc = 'join lines while preserving cursor position' })
vim.keymap.set('n', '<C-u>', '20kzz', { desc = 'scroll up 20 lines and center screen' })
vim.keymap.set('n', '<C-d>', '20jzz', { desc = 'scroll down 20 lines and center screen' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'next search result with screen centered' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'previous search result with screen centered' })
vim.keymap.set('n', 'Q', '<nop>', { desc = 'disable ex mode' })
vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/cgI<Left><Left><Left><Left>]], { desc = 'search and replace word under cursor' })
vim.keymap.set('v', '<leader>s', [["zy:<C-U>%s/<C-r>z/<C-r>z/cgI<Left><Left><Left><Left>]], { desc = 'search and replace visual selection' })
vim.keymap.set('n', '<leader>=', function()
    local view = vim.fn.winsaveview()
    vim.cmd('normal! gg=G``')
    vim.fn.winrestview(view)
end, { desc = 'format current buffer with built-in formatter' })

vim.keymap.set('x', 'О', ":m '>+1<CR>gv-gv", { desc = 'move selected lines down', silent = true })
vim.keymap.set('x', 'Л', ":m '<-2<CR>gv-gv", { desc = 'move selected lines up', silent = true })
vim.keymap.set('n', 'О', "mzJ`z", { desc = 'join lines while preserving cursor position' })
vim.keymap.set('n', '<C-г>', '20kzz', { desc = 'scroll up 20 lines and center screen' })
vim.keymap.set('n', '<C-в>', '20jzz', { desc = 'scroll down 20 lines and center screen' })
vim.keymap.set('n', 'т', 'nzzzv', { desc = 'next search result with screen centered' })
vim.keymap.set('n', 'Т', 'Nzzzv', { desc = 'previous search result with screen centered' })
vim.keymap.set('n', '<leader>ы', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/cgI<Left><Left><Left><Left>]], { desc = 'search and replace word under cursor' })
vim.keymap.set('v', '<leader>ы', [["zy:<C-U>%s/<C-r>z/<C-r>z/cgI<Left><Left><Left><Left>]], { desc = 'search and replace visual selection' })

vim.keymap.set("n", "<leader>f", format_current_buffer, { desc = "Format current buffer" })
vim.keymap.set("n", "<leader>а", format_current_buffer, { desc = "Format current buffer" })

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP hover" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, { desc = "Code action" })

vim.keymap.set("n", "Л", vim.lsp.buf.hover, { desc = "LSP hover" })
vim.keymap.set("n", "пв", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "пВ", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "пш", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "пк", vim.lsp.buf.references, { desc = "References" })
vim.keymap.set("n", "<leader>кт", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set({ "n", "v" }, "<leader>ф", vim.lsp.buf.code_action, { desc = "Code action" })

vim.keymap.set("n", "<C-k>", function() show_a_diag_at_index(-1) end, { desc = "show previous diagnostic" })
vim.keymap.set("n", "<C-j>", function() show_a_diag_at_index(1) end, { desc = "show next diagnostic" })
vim.keymap.set("n", "<C-л>", function() show_a_diag_at_index(-1) end, { desc = "show previous diagnostic" })
vim.keymap.set("n", "<C-о>", function() show_a_diag_at_index(1) end, { desc = "show next diagnostic" })

vim.keymap.set("n", "<leader>ff", telescope_builtin("find_files"), { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", telescope_builtin("live_grep"), { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", telescope_builtin("buffers"), { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", telescope_builtin("help_tags"), { desc = "Help tags" })
vim.keymap.set("n", "<leader>fo", telescope_builtin("oldfiles"), { desc = "Recent files" })
vim.keymap.set("n", "<leader>fw", telescope_builtin("grep_string"), { desc = "Grep word under cursor" })
vim.keymap.set("n", "<leader>fd", telescope_builtin("diagnostics"), { desc = "Diagnostics" })

vim.keymap.set("n", "<leader>аа", telescope_builtin("find_files"), { desc = "Find files" })
vim.keymap.set("n", "<leader>ап", telescope_builtin("live_grep"), { desc = "Live grep" })
vim.keymap.set("n", "<leader>фи", telescope_builtin("buffers"), { desc = "Buffers" })
vim.keymap.set("n", "<leader>өр", telescope_builtin("help_tags"), { desc = "Help tags" })
vim.keymap.set("n", "<leader>щ", telescope_builtin("oldfiles"), { desc = "Recent files" })
vim.keymap.set("n", "<leader>ц", telescope_builtin("grep_string"), { desc = "Grep word under cursor" })
vim.keymap.set("n", "<leader>в", telescope_builtin("diagnostics"), { desc = "Diagnostics" })

vim.keymap.set("n", "<leader>do", "<cmd>DiffviewOpen<CR>", { desc = "Open diffview" })
vim.keymap.set("n", "<leader>dc", "<cmd>DiffviewClose<CR>", { desc = "Close diffview" })
vim.keymap.set("n", "<leader>dh", "<cmd>DiffviewFileHistory %<CR>", { desc = "File history" })

vim.keymap.set("n", "<leader>вщ", "<cmd>DiffviewOpen<CR>", { desc = "Open diffview" })
vim.keymap.set("n", "<leader>вс", "<cmd>DiffviewClose<CR>", { desc = "Close diffview" })
vim.keymap.set("n", "<leader>вр", "<cmd>DiffviewFileHistory %<CR>", { desc = "File history" })

vim.keymap.set("n", "]h", nav_and_preview("next"), { desc = "Next hunk + preview" })
vim.keymap.set("n", "[h", nav_and_preview("prev"), { desc = "Prev hunk + preview" })
vim.keymap.set("n", "<leader>b", "<cmd>Gitsigns blame_line<CR>", { desc = "blame line under cursor" })
vim.keymap.set("n", "<leader>h", "<cmd>Gitsigns preview_hunk<CR>", { desc = "preview hunk" })
vim.keymap.set("n", "<leader>st", "<cmd>Gitsigns stage_hunk<CR>", { desc = "stage / unstage hunk" })

vim.keymap.set("n", "<leader>mr", function()
    local ok = pcall(require, "render-markdown")
    if ok then
        vim.cmd("RenderMarkdown toggle")
    end
end, { desc = "Toggle rendered markdown" })

vim.keymap.set("n", "<leader>ьк", function()
    local ok = pcall(require, "render-markdown")
    if ok then
        vim.cmd("RenderMarkdown toggle")
    end
end, { desc = "Toggle rendered markdown" })
