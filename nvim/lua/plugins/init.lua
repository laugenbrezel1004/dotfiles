return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufWritePre", "BufNewFile" },
        config = function()
            require("nvchad.configs.lspconfig").defaults()
            -- configs dir, lspconfig file (no need to write out the .lua extension)
            require("configs.lspconfig")
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lspconfig" },
        config = function()
            require("configs.mason-lspconfig")
        end,
    },

    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.lint")
        end,
    },
    {
        "rshkarin/mason-nvim-lint",
        event = "VeryLazy",
        dependencies = { "nvim-lint" },
        config = function()
            require("configs.mason-lint")
        end,
    },
    {
        "stevearc/conform.nvim",
        event = "BufWritePre", -- format on save
        config = function()
            require("configs.conform")
        end,
    },
    {
        "zapling/mason-conform.nvim",
        event = "VeryLazy",
        dependencies = { "conform.nvim" },
        config = function()
            require("configs.mason-conform")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        -- load treesitter one the event of opening a file or creating a file
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.treesitter")
        end,
    },
    -- {
    --     "folke/which-key.nvim",
    -- },
}
