local options = {
    formatters_by_ft = {
        lua = { "stylua" },
        c = { "clang_format" },
        css = { "prettier" },
        html = { "prettier" },
        -- cpp = { "clang-format" },
        -- go = { "gofumpt", "goimports-reviser", "golines" },
        -- haskell = { "fourmolu", "stylish-haskell" },
        python = { "isort", "black" },
    },

    formatters = {
        -- C & C++
        ["clang_format"] = {
            prepend_args = {
                "-style={ \
                         IndentWidth: 4, \
                         TabWidth: 4, \
                         UseTab: Never, \
                         AccessModifierOffset: 0, \
                         IndentAccessModifiers: true, \
                         PackConstructorInitializers: Never}",
            },
        },
        -- Lua
        stylua = {
            prepend_args = {
                "--column-width",
                "80",
                "--line-endings",
                "Unix",
                "--indent-type",
                "Spaces",
                "--indent-width",
                "4",
                "--quote-style",
                "AutoPreferDouble",
            },
        },
        -- Python
        black = {
            prepend_args = {
                "--fast",
                "--line-length",
                "80",
            },
        },
        isort = {
            prepend_args = {
                "--profile",
                "black",
            },
        },
    },

    format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
    },
}

require("conform").setup(options)
