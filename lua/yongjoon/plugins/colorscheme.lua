return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- load first than other plugins
    config = function()
        local catppuccin = require('catppuccin')
        catppuccin.setup({
            transparent_background = true
        })
        vim.cmd.colorscheme 'catppuccin-macchiato'
    end,
}
