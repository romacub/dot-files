--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- file: plugins/configs/lualine.lua
-- description: pacman config for lualine
-- author: kien nguyen-tuan <kiennt2609@gmail.com>
-- credit: shadmansaleh & his evil theme: https://github.com/nvim-lualine/lualine.nvim/blob/master/examples/evil_lualine.lua
local lualine = require("lualine")
local lualine_require = require("lualine_require")

local function loadcolors()
    -- rose-pine palette
    local rosepine = require("rose-pine.palette")
    local colors = {
        bg = rosepine.base,
        fg = rosepine.text,
        yellow = rosepine.gold,
        cyan = rosepine.foam,
        black = rosepine.subtled,
        green = rosepine.pine,
        white = rosepine.text,
        magenta = rosepine.iris,
        blue = rosepine.rose,
        red = rosepine.love,
        foam = rosepine.foam
    }

    -- try to load pywal colors
    local modules = lualine_require.lazy_require {
        utils_notices = "lualine.utils.notices"
    }
    local sep = package.config:sub(1, 1)

    -- FIX: Use uppercase HOME and fallback to vim.fn.expand if needed
    local home_dir = os.getenv("HOME") or vim.fn.expand("~")
    local wal_colors_path = table.concat({ home_dir, ".cache", "wal", "colors.sh" }, sep)
    local wal_colors_file = io.open(wal_colors_path, "r")

    if wal_colors_file == nil then
        modules.utils_notices.add_notice("lualine.nvim: " .. wal_colors_path .. " not found")
        return colors
    end

    local ok, wal_colors_text = pcall(wal_colors_file.read, wal_colors_file, "*a")
    wal_colors_file:close()

    if not ok then
        modules.utils_notices.add_notice("lualine.nvim: " .. wal_colors_path .. " could not be read: " ..
            wal_colors_text)
        return colors
    end

    local wal = {}

    for line in vim.gsplit(wal_colors_text, "\n") do
        if line:match("^[a-z0-9]+='#[a-fa-f0-9]+'$") ~= nil then
            local i = line:find("=")
            local key = line:sub(0, i - 1)
            local value = line:sub(i + 2, #line - 1)
            wal[key] = value
        end
    end

    -- color table for highlights
    -- FIX: Check if wal colors were actually loaded before using them
    if next(wal) ~= nil then
        colors = {
            bg = wal.background,
            fg = wal.foreground,
            yellow = wal.color3,
            cyan = wal.color4,
            black = wal.color0,
            green = wal.color2,
            white = wal.color7,
            magenta = wal.color5,
            blue = wal.color6,
            red = wal.color1
        }
    end

    return colors
end

local colors = loadcolors()

local function loadmodes()
    local modes = {
        v = "--VISUAL--",
        n = "--NORMAL--",
        r = "--REPLAC--",
        i = "--INSERT--",
        s = "--SELECT--",
        e = "--EXECUT--",
        p = "--PROMPT--"
    }

    return modes
end

local modes = loadmodes()

-- FIXED: Add helper function to get mode background color
local function get_mode_bg_color()
    local mode = vim.fn.mode()
    local mode_bg = {
        n = colors.magenta,      -- normal mode
        i = colors.green,        -- insert mode
        v = colors.blue,         -- visual mode (character-wise)
        V = colors.blue,         -- visual mode (line-wise) - FIXED: was lowercase 'v'
        ["\22"] = colors.blue,   -- visual mode (block-wise)
        c = colors.magenta,      -- command-line mode
        no = colors.red,         -- operator-pending mode
        s = colors.yellow,       -- select mode (character-wise)
        S = colors.yellow,       -- select mode (line-wise) - FIXED: was lowercase 's'
        ["\19"] = colors.yellow, -- select mode (block-wise)
        ic = colors.yellow,      -- insert mode completion (ctrl-x)
        R = colors.white,        -- replace mode - FIXED: was lowercase 'r'
        Rv = colors.white,       -- virtual replace mode - FIXED: was lowercase 'rv'
        cv = colors.red,         -- vim ex mode
        ce = colors.red,         -- normal ex mode
        r = colors.cyan,         -- hit-enter prompt
        rm = colors.cyan,        -- more-prompt mode
        ["r?"] = colors.cyan,    -- confirm-prompt mode (e.g., ":confirm quit")
        ["!"] = colors.red,      -- shell or external command execution mode
        t = colors.red           -- terminal mode
    }
    return mode_bg[mode] or colors.white
end

local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand("%:p:h")
        local gitdir = vim.fn.finddir(".git", filepath .. ";")
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end
}

-- config
local config = {
    options = {
        -- disable sections and component separators
        component_separators = "",
        section_separators = "",
        disabled_filetypes = { "lazy", "nvimtree" },
        theme = {
            -- we are going to use lualine_c an lualine_x as left and
            -- right section. both are highlighted by c theme .  so we
            -- are just setting default looks o statusline
            normal = {
                c = {
                    fg = colors.fg,
                    bg = colors.bg
                }
            },
            inactive = {
                c = {
                    fg = colors.fg,
                    bg = colors.bg
                }
            }
        }
    },
    sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        -- these will be filled later
        lualine_c = {},
        lualine_x = {}
    },
    inactive_sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {}
    },
}

-- inserts a component in lualine_c at left section
local function ins_left(component)
    table.insert(config.sections.lualine_c, component)
end

-- inserts a component in lualine_x ot right section
local function ins_right(component)
    table.insert(config.sections.lualine_x, component)
end

-- FIXED: Mode component with proper background colors
ins_left {
    -- mode component
    function()
        local mode_text = {
            n = modes.n,       -- normal mode
            i = modes.i,       -- insert mode
            v = modes.v,       -- visual mode (character-wise) - FIXED: removed duplicate
            V = modes.v,       -- visual mode (line-wise) - FIXED: added uppercase V
            ["\22"] = modes.v, -- visual mode (block-wise)
            c = "command",     -- command-line mode
            no = "operator",   -- operator-pending mode
            s = modes.s,       -- select mode (character-wise) - FIXED: removed duplicate
            S = modes.s,       -- select mode (line-wise) - FIXED: added uppercase S
            ["\19"] = modes.s, -- select mode (block-wise)
            ic = modes.i,      -- insert mode completion (ctrl-x)
            R = modes.r,       -- replace mode - FIXED: uppercase R
            Rv = modes.r,      -- virtual replace mode - FIXED: uppercase Rv
            cv = modes.e,      -- vim ex mode
            ce = modes.e,      -- normal ex mode
            r = modes.p,       -- hit-enter prompt
            rm = modes.p,      -- more-prompt mode
            ["r?"] = modes.p,  -- confirm-prompt mode (e.g., ":confirm quit")
            ["!"] = "shell",   -- shell or external command execution mode
            t = "terminal"     -- terminal mode
        }
        return mode_text[vim.fn.mode()] or "unknown"
    end,
    color = function()
        -- FIXED: Use the helper function for consistent colors
        return {
            bg = get_mode_bg_color(),
            fg = colors.bg, -- text color = background color for contrast
            gui = "bold"
        }
    end,
    padding = 2
}


ins_left {
    "filename",
    cond = conditions.buffer_not_empty,
    color = {
        fg = colors.magenta,
    }
}

-- ins_left {
--     "branch",
--     icon = " ",
--     color = {
--         fg = colors.blue,
--         gui = "bold"
--     }
-- }

ins_left {
    "diff",
    -- is it me or the symbol for modified is really weird
    symbols = {
        added = " ",
        modified = " ",
        removed = " "
    },
    diff_color = {
        added = {
            fg = colors.green
        },
        modified = {
            fg = colors.yellow
        },
        removed = {
            fg = colors.red
        }
    },
    cond = conditions.hide_in_width
}

-- insert mid section. you can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left { function()
    return "%="
end }

-- ins_right {
--     -- lsp server name .
--     function()
--         local msg = "null"
--         local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
--         local clients = vim.lsp.get_active_clients()
--         if next(clients) == nil then
--             return msg
--         end
--         for _, client in ipairs(clients) do
--             local filetypes = client.config.filetypes
--             if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
--                 return client.name
--             end
--         end
--         return msg
--     end,
--     icon = "lsp:",
--     color = {
--         fg = colors.magenta,
--     }
-- }

ins_right {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = {
        error = "e-",
        warn = "w-",
        info = "i-",
        hint = "h-",
    },
    diagnostics_color = {
        color_error = { fg = colors.red },
        color_warn = { fg = colors.yellow },
        color_info = { fg = colors.cyan },
        color_hints = { fg = colors.magenta }
    },
    cond = function()
        local diag = vim.diagnostic.get(0)
        return #diag > 0
    end
}
-- ins_right {
--     "o:encoding", -- option component same as &encoding in viml
--     fmt = string.upper,
--     cond = conditions.hide_in_width,
--     color = {
--         fg = colors.green,
--         gui = "bold"
--     }
-- }

-- ins_right {
--     "fileformat",
--     fmt = string.upper,
--     icons_enabled = true,
--     color = {
--         fg = colors.green,
--         gui = "bold"
--     }
-- }

-- FIXED: Location component with proper mode handling
ins_right {
    "location",
    color = function()
        return {
            bg = get_mode_bg_color(),
            fg = colors.bg,
            gui = "bold"
        }
    end,
    padding = { left = 1, right = 1 }
}

-- FIXED: Progress component with proper mode handling
ins_right {
    "progress",
    color = function()
        return {
            bg = get_mode_bg_color(),
            fg = colors.bg,
            gui = "bold"
        }
    end,
    padding = { left = 1, right = 1 }
}

-- now don"t forget to initialize lualine
lualine.setup(config)
