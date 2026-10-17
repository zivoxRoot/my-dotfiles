return {
	"lewis6991/gitsigns.nvim",
	events = { "BufReadPre", "BufNewFile" },
	config = function()
		require("gitsigns").setup()
	end,
}
