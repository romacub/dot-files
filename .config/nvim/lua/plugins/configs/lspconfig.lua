------------------------------------------------------------------------------
-- lspconfig.lua (CORRECT SETUP)
------------------------------------------------------------------------------

local lspconfig = require('lspconfig')
local on_attach = require("utils").on_attach -- Your existing on_attach function

-- Configure capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.offsetEncoding = { "utf-8" } -- Fix encoding warnings

------------------------------------------------------------------------------
-- Configure Individual LSP Servers
------------------------------------------------------------------------------

-- C# or unity setup
lspconfig.omnisharp.setup({
    cmd = { "OmniSharp" },
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = function(fname)
        local util = require("lspconfig").util
        local root = util.root_pattern(".git", ".vscode", "src", "*.sln", "*.csproj")(fname)
        return root or vim.fn.getcwd()
    end,
})

-- Python - Pyright (Type checking + basic analysis)
lspconfig.pyright.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "basic",
            },
        },
    },
})

-- Ruff (Fast linting + formatting)
lspconfig.ruff_lsp.setup({
    on_attach = function(client, bufnr)
        -- Only attach formatting capabilities to Ruff
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.documentRangeFormattingProvider = true

        -- Your existing on_attach
        on_attach(client, bufnr)
    end,
    capabilities = capabilities,
    init_options = {
        settings = {
            args = {
                "--select=ALL", -- Enable all linting rules
            },
        },
    },
})


-- Lua - lua_ls
lspconfig.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})

-- Bash - bashls
lspconfig.bashls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

-- Java - jdtls
lspconfig.jdtls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = function(fname)
        local util = require("lspconfig").util
        local root = util.root_pattern("pom.xml", "build.gradle", ".project", ".git", ".vscode", "src")(fname)
        return root or vim.fn.getcwd()
    end,
})

-- C/C++ - clangd
lspconfig.clangd.setup({
    on_attach = function(client, bufnr)
        -- Disable formatting from clangd - let null-ls handle it
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        on_attach(client, bufnr)
    end,
    capabilities = capabilities,
    cmd = { "clangd", "--background-index", "--clang-tidy" },
    root_dir = function(fname)
        local util = require("lspconfig").util
        local root = util.root_pattern(".git", ".vscode", "src")(fname)
        return root or vim.fn.getcwd()
    end,
})

-- C# - csharp_ls (Note: server name is csharp_ls, not csharp-language-server)
lspconfig.csharp_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = function(fname)
        local util = require("lspconfig").util
        local root = util.root_pattern(".git", ".vscode", "src")(fname)
        return root or vim.fn.getcwd()
    end,
})

------------------------------------------------------------------------------
-- Additional Servers (Optional)
------------------------------------------------------------------------------

-- JSON
lspconfig.jsonls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

-- YAML
lspconfig.yamlls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

-- Docker
lspconfig.dockerls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

-- Go
lspconfig.gopls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

-- TypeScript
-- lspconfig.ts_ls.setup({ -- Note: server name is tsserver, not ts_ls
--     on_attach = on_attach,
--     capabilities = capabilities,
-- })

print("LSP servers configured successfully!")

--- ----------------------------------------------------------------------------------
--- -- lspconfig.lua (FIXED)
--- ------------------------------------------------------------------------------
---
--- local merge_tables = require("utils").merge_tables
--- local on_attach = require("utils").on_attach
---
--- local lspconfig = require("lspconfig")
---
--- local exist, custom = pcall(require, "custom")
--- local custom_formatting_servers = exist and type(custom) == "table" and custom.formatting_servers or {}
---
--- ------------------------------------------------------------------------------
--- -- 1. List of LSP servers you want configured
--- ------------------------------------------------------------------------------
--- local formatting_servers = {
---     -- Your existing server configurations remain the same
---     jsonls = {},
---     dockerls = {},
---     bashls = {},
---     gopls = {},
---     vimls = {},
---     yamlls = {},
---     ruff_lsp = {
---         on_attach = function(client, bufnr)
---             print("Ruff LSP attached to buffer", bufnr)
---         end,
---         init_options = {
---             settings = {
---                 args = {},
---             },
---         },
---     },
---     clangd = {
---         cmd = { "clangd", "--background-index", "--clang-tidy" },
---         on_attach = function(client, bufnr)
---             local opts = { noremap = true, silent = true, buffer = bufnr }
---             vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
---             vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
---             vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
---             vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
---             vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
---             print("Clangd attached to buffer", bufnr)
---         end,
---     },
---     jdtls = {
---         root_dir = function(fname)
---             local util = require("lspconfig").util
---             local root = util.root_pattern("pom.xml", "build.gradle", ".project", ".git", ".vscode", "src")(fname)
---             return root or vim.fn.getcwd()
---         end,
---     },
---     pyright = {
---         on_attach = function(client, bufnr)
---             print("Pyright attached to buffer", bufnr)
---         end,
---         settings = {
---             python = {
---                 analysis = {
---                     autoSearchPaths = true,
---                     useLibraryCodeForTypes = true,
---                     diagnosticMode = "workspace",
---                     typeCheckingMode = "basic",
---                 },
---             },
---         },
---     },
---     lua_ls = {
---         on_attach = function(client, bufnr)
---             print("lua_ls attached to buffer", bufnr)
---         end,
---         settings = {
---             Lua = {
---                 format = {
---                     enable = true,
---                     defaultConfig = {
---                         indent_style = "space",
---                         indent_size = "4",
---                     }
---                 },
---                 diagnostics = {
---                     globals = { "vim" },
---                 },
---             },
---         },
---     },
---     ts_ls = {
---         on_attach = function(client, bufnr)
---             print("ts_ls (TypeScript) attached to buffer", bufnr)
---         end,
---     },
--- }
---
--- -- Merge any "custom" servers if you have them in another file
--- merge_tables(formatting_servers, custom_formatting_servers)
---
--- ------------------------------------------------------------------------------
--- -- 2. Core LSP setup logic
--- ------------------------------------------------------------------------------
--- local servers = formatting_servers
--- local capabilities = require("cmp_nvim_lsp").default_capabilities(
---     vim.lsp.protocol.make_client_capabilities()
--- )
---
--- -- Add UTF-8 encoding to prevent position encoding warnings
--- capabilities.offsetEncoding = { "utf-8" }
---
--- local function setup(server)
---     -- Skip if server already configured
---     if lspconfig[server] and lspconfig[server].manager then
---         return
---     end
---
---     local server_opts = vim.tbl_deep_extend("force", {
---         capabilities = vim.deepcopy(capabilities),
---         on_attach = on_attach
---     }, servers[server] or {})
---
---     -- Setup the server directly
---     if lspconfig[server] and type(lspconfig[server].setup) == "function" then
---         lspconfig[server].setup(server_opts)
---     else
---         vim.notify("[LSP] setup() skipped for " .. server .. " (not available)", vim.log.levels.WARN)
---     end
--- end
---
--- ------------------------------------------------------------------------------
--- -- 3. Mason & Mason-LSPconfig Integration (SIMPLIFIED)
--- ------------------------------------------------------------------------------
--- vim.schedule(function()
---     local ok, mlsp = pcall(require, "mason-lspconfig")
---     if not ok then
---         vim.notify("[LSP] mason-lspconfig not available", vim.log.levels.WARN)
---         -- Setup all servers manually if mason-lspconfig not available
---         for server, _ in pairs(servers) do
---             setup(server)
---         end
---         return
---     end
---
---     -- Setup mason-lspconfig
---     mlsp.setup({
---         ensure_installed = {},          -- Let's handle installation manually to avoid conflicts
---         automatic_installation = false, -- Disable auto-install to have full control
---     })
---
---     -- Setup ALL servers manually to avoid duplicate LSP clients
---     -- This is the safest approach to prevent the duplication issue
---     for server, _ in pairs(servers) do
---         setup(server)
---     end
--- end)
