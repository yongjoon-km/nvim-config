return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-context",
        "nvim-treesitter/playground"
    },
    config = function()
        local configs = require("nvim-treesitter.configs")
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
