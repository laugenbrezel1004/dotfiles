require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "bash" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
