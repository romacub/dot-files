-- File for small helper functions shared across config modules.

local M = {}

function M.bind_bilang(mode, lhs_en, lhs_ru, rhs, opts)
    vim.keymap.set(mode, lhs_en, rhs, opts)
    vim.keymap.set(mode, lhs_ru, rhs, opts)
end

function M.make_lazy_bilang_keys(lhs_en, lhs_ru, rhs, desc)
    return {
        { lhs_en, rhs, desc = desc },
        { lhs_ru, rhs, desc = desc },
    }
end

function M.add_bilang_table_keymap(tbl, lhs_en, lhs_ru, rhs)
    tbl[lhs_en] = rhs
    tbl[lhs_ru] = rhs
end

return M
