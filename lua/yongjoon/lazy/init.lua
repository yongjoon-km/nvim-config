local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("yongjoon.lazy.plugins", {
  checker = {
    -- automatically check for plugin updates
    enabled = true,
    notify = false,
  },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = true,
    notify = false,
  },
})


vim.lsp.enable('rust_analyzer')
vim.lsp.enable('lua_ls')

-- c lsp
vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--background-index",
    },
    root_markers = { ".clangd", "compile_commands.json", "compile_flags.txt", ".git" },
})

vim.lsp.enable("clangd")

-- python lsp
vim.lsp.config("basepyright", {
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = {"python"},
    root_markers = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        ".git"
    },
    settings = {
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "basic",
            },
        },
    },
})

vim.lsp.enable("basedpyright")

vim.lsp.config("ruff", {
    cmd = {"ruff", "server"},
    root_markers = {
        "pyproject.toml",
        "ruff.toml"
    },
})

vim.lsp.enable("ruff")

-- vim diagnostic hover setup
vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
        vim.diagnostic.open_float(nil, { focusable = false })
    end,
})

vim.opt.updatetime = 500
