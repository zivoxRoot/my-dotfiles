return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			-- installs these binaries automatically via Mason
			ensure_installed = {
				"lua_ls",
				"pyright",
				"markdown_oxide",
				-- add whatever languages you use
			},
			automatic_enable = true, -- calls vim.lsp.enable() for you
		},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- global capabilities (completion etc.) get merged into every server
			local capabilities = vim.lsp.protocol.make_client_capabilities()

			-- extend/override individual servers with vim.lsp.config()
			-- BEFORE mason-lspconfig enables them (order in this file matters:
			-- this file loads, then mason-lspconfig's opts run automatic_enable)
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
					},
				},
			})

			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			-- keymaps that only apply once an LSP actually attaches to a buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local opts = { buffer = args.buf }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					-- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
					vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
				end,
			})

			-- in lua/plugins/lsp.lua, inside nvim-lspconfig's config function
			vim.lsp.config("markdown_oxide", {
				capabilities = vim.tbl_deep_extend("force", capabilities, {
					workspace = {
						didChangeWatchedFiles = { dynamicRegistration = true },
					},
				}),
			})
		end,
	},
}
