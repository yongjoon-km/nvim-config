return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()

    -- disable netrw at the very start of your init.lua
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- set termguicolors to enable highlight groups
    vim.opt.termguicolors = true

    -- use default setting
    require("nvim-tree").setup()

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>nn", "<cmd>NvimTreeToggle<CR>", {})
    keymap.set("n", "<leader>nf", "<cmd>NvimTreeFindFileToggle<CR>", {})
    keymap.set("n", "<leader>nr", "<cmd>NvimTreeRefresh<CR>", {})
  end,
}
