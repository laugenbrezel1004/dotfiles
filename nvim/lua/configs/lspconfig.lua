local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")

-- list of all servers configured.
-- lua is set under the hood internally in nvchad
lspconfig.servers = {
    "clangd",
    "lua_ls",
}
-- local servers = { "clangd" }
-- -- list of servers configured with default config.
local default_servers = {}
<<<<<<< HEAD

-- lsps with default config
-- loud all server
-- for _, lsp in ipairs(default_servers) do
=======
--
-- -- lsps with default config
-- for _, lsp in ipairs(servers) do
>>>>>>> 731ca6cd6858945a594ebfa507bd88dc068378a7
--     lspconfig[lsp].setup({
--         on_attach = on_attach,
--         on_init = on_init,
--         capabilities = capabilities,
--     })
-- end
<<<<<<< HEAD
--
=======

>>>>>>> 731ca6cd6858945a594ebfa507bd88dc068378a7
lspconfig.clangd.setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        on_attach(client, bufnr)
    end,
    on_init = on_init,
    capabilities = capabilities,
})
lspconfig.lua_ls.setup({
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,

    settings = {
        Lua = {
            diagnostics = {
                enable = false, -- Disable all diagnostics from lua_ls
                -- globals = { "vim" },
            },
            workspace = {
                library = {
                    vim.fn.expand("$VIMRUNTIME/lua"),
                    vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                    vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
                    vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                    "${3rd}/love2d/library",
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
        },
    },
})
