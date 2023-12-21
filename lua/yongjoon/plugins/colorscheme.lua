return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- load first than other plugins
    config = function()
        vim.cmd.colorscheme 'catppuccin'
    end,
}
