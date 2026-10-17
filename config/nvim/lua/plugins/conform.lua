return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "black" },
			javascript = { "prettier" },
			typescript = { "prettier" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback", -- use LSP formatting only if no formatter matched
		},
	},
}
