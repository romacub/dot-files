--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/configs/null-ls.lua
-- Description: null-ls configuration

local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

-- Configure clang-format to use project .clang-format when available,
-- otherwise use standard C formatting with 4 spaces
local sources = {
    formatting.clang_format.with({
        -- This tells clang-format to look for .clang-format file first
        -- If not found, it will use the fallback style
        extra_args = {
            "--style=file",           -- Use .clang-format if exists in project
            "--fallback-style=Google" -- Fallback to google
        }
    })
}

-- Load custom configurations
local exist, custom = pcall(require, "custom")
if exist and type(custom) == "table" and custom.setup_sources then
    local custom_sources = custom.setup_sources(null_ls.builtins)
    if custom_sources then
        for _, source in ipairs(custom_sources) do
            table.insert(sources, source)
        end
    end
end

null_ls.setup({
    debug = false,
    sources = sources
}) -- Author: Kien Nguyen-Tuan <kiennt2609@gmail.com>
