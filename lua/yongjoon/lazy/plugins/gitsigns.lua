return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local gs = require("gitsigns")

        gs.setup({
            signs = {
                add = { text = "+" },
                change = { text = "+" },
                delete = { text = "+" },
                topdelete = { text = "+" },
                changedelete = { text = "+" },
                untracked = { text = "+" },
            },
            on_attach = function(bufnr)
                local opts = { buffer = bufnr, silent = true }

                -- Hunk navigation
                vim.keymap.set("n", "]h", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gs.nav_hunk("next")
                    end
                end, vim.tbl_extend("force", opts, { desc = "Next hunk" }))

                vim.keymap.set("n", "[h", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gs.nav_hunk("prev")
                    end
                end, vim.tbl_extend("force", opts, { desc = "Prev hunk" }))
                
                -- Staging
                vim.keymap.set("n", "<leader>hs", gs.stage_hunk, vim.tbl_extend("force", opts, { desc = "Stage hunk" }))
                vim.keymap.set("n", "<leader>hr", gs.reset_hunk, vim.tbl_extend("force", opts, { desc = "Reset hunk" }))

                vim.keymap.set("v", "<leader>hs", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, vim.tbl_extend("force", opts, { desc = "Stage hunk (visual)" }))
                vim.keymap.set("v", "<leader>hr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, vim.tbl_extend("force", opts, { desc = "Reset hunk (visual)" }))

                -- Preview
                vim.keymap.set("n", "<leader>hp", gs.preview_hunk, vim.tbl_extend("force", opts, { desc = "Preview hunk" }))
            end,
        })
    end,
}
