vim.g.mapleader = ' '

vim.opt.matchpairs = {
    '(:)', '{:}', '[:]',
    '<:>', '":"', "':'",
    '`:`', '«:»', '„:“'
}

local indent = 4
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.shiftround = true
vim.opt.shiftwidth = indent
vim.opt.softtabstop = indent
vim.opt.tabstop = indent

vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'
vim.opt.cmdheight = 0
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.lazyredraw = true
vim.opt.list = true
vim.opt.listchars = {
    leadmultispace = '▏   ',
    trail = '·',
    tab = '▏ ›',
}
vim.opt.scrolloff = 13
vim.opt.termguicolors = true
vim.opt.guicursor = ''
vim.opt.mouse = 'a'

vim.cmd('syntax enable')
vim.cmd('filetype plugin on')

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25

vim.opt.shortmess:append('I')
vim.opt.clipboard = 'unnamed,unnamedplus'

vim.opt.langmap = 'фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz,'
    .. 'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,'
    .. 'ё;`,Ё;~,э;\',Э;"'

vim.diagnostic.config({
    virtual_text = { prefix = "" },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})
