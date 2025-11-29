local M = {}

M.merge_tables = function(t1, t2)
    if type(t1) ~= "table" or type(t2) ~= "table" then
        return
    end
    for k, v in pairs(t2) do
        t1[k] = v
    end
end

M.on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    local keymap = vim.keymap.set

    -- Basic LSP navigation
    keymap("n", "gd", vim.lsp.buf.definition, opts)
    keymap("n", "gD", vim.lsp.buf.declaration, opts)
    keymap("n", "gr", vim.lsp.buf.references, opts)
    keymap("n", "gi", vim.lsp.buf.implementation, opts)
    keymap("n", "K", vim.lsp.buf.hover, opts)
    keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
    keymap("n", "<leader>a", vim.lsp.buf.code_action, opts)
    keymap("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
    end, opts)
end


return M
