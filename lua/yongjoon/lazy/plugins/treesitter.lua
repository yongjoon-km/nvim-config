return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
        local configs = require("nvim-treesitter")
        configs.setup({
            ensure_installed = {
                "java",
                "lua",
                "vim",
                "html",
                "javascript",
                "typescript",
                "rust",
                "query",
                "markdown",
            },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
            playground = { enable = true },
            auto_install = true,
        })
    end,
}
