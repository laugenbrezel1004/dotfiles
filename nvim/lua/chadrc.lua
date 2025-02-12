-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
    theme = "catppuccin",
    user = function()
        vim.opt.textwidth = 140
        vim.opt.colorcolumn = "120"
    end,
    -- hl_override = {
    --
    -- 	Comment = { italic = true },
    -- 	["@comment"] = { italic = true },
    -- },
}

return M
