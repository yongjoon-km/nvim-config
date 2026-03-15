return {
    "yongjoon-km/nvim-bookmark",
    branch="main",
    config = function()
        local nvim_bookmark = require('nvim-bookmark')
        local keymap = vim.keymap -- for conciseness

        keymap.set("n", "<leader>bl", function() nvim_bookmark.select_bookmark() end)
        keymap.set("n", "<leader>bb", function() nvim_bookmark.save_bookmark() end)
    end
}
