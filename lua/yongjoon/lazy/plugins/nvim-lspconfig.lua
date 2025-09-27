return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},

	config = function()
		local on_attach = function(_, bufnr)
			-- key mapping
			local keymap = vim.keymap
			local opts = { noremap = true, silent = true }
			opts.buffer = bufnr

			keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)
			keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
			keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			keymap.set("n", "gI", "<cmd>Telescope lsp_implementations<cr>", opts)
			keymap.set("n", "gy", "<cmd>Telescope lsp_type_definitions<cr>", opts)
			keymap.set("n", "<leader>d", "<cmd>Telescope diagnostics<cr>", opts)
			keymap.set("n", "K", vim.lsp.buf.hover, opts)
			keymap.set("n", "gK", vim.lsp.buf.signature_help, opts)
			keymap.set("i", "<c-k>", vim.lsp.buf.signature_help, opts)
			keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
			keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
			keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
			keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		end

		local lspconfig = require("lspconfig")

		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = cmp_nvim_lsp.default_capabilities()

		local mason = require("mason")
		mason.setup({})

		local mason_lspconfig = require("mason-lspconfig")
		mason_lspconfig.setup({
			ensure_installed = {
				"lua_ls",
			},
		})
	end,
}
