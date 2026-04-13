vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*',
    callback = function()
        if vim.bo.buftype ~= '' then
            return
        end
        if not vim.bo.modifiable then
            return
        end
        if vim.api.nvim_buf_get_name(0):match("%.md$") then
            return
        end
        local view = vim.fn.winsaveview()
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.fn.winrestview(view)
    end,
    desc = 'remove trailing whitespace automatically before saving file'
})

vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 777
        })
    end,
    desc = 'briefly highlight yanked text for visual feedback'
})
