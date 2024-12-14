local lint = require("lint")

lint.linters_by_ft = {
    lua = { "luacheck" },
}

lint.linters.luacheck.args = {
    unpack(lint.linters.luacheck.args),
    "--globals",
    "love",
    "vim",
}

lint.linters.cmakelint.args = {
    unpack(lint.linters.cmakelint.args),
    "--globals",
    "love",
    "vim",
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    callback = function()
        -- check file when event above is given
        lint.try_lint()
    end,
})
