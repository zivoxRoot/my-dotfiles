return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	lazy = false,
	config = function()
		require("nvim-treesitter").install({
			"lua",
			"python",
			"javascript",
			"typescript",
			"vim",
			"vimdoc",
			"bash",
			"markdown",
			"latex",
		})

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local lang = vim.treesitter.language.get_lang(args.match)
				if not lang then
					return
				end

				local ok = pcall(vim.treesitter.start, args.buf, lang)
				if not ok then
					return
				end

				-- optional: treesitter-based folding and indent
				vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
