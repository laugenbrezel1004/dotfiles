local options = {
    ensure_installed = {
        "bash",
        "markdown",
        "vim",
        "c",
        "cmake",
        "make",
        "luadoc",
        "printf",
        "yaml",
    },

    highlight = {
        enable = true,
        use_languagetree = true,
    },

    indent = { enable = true },
}

require("nvim-treesitter.configs").setup(options)
