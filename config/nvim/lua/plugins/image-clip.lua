return {
	"HakonHarnes/img-clip.nvim",
	ft = "markdown",
	opts = {
		default = {
			dir_path = "../assets", -- saves next to the .md file, in an "assets" subfolder
			relative_to_current_file = true,
			use_absolute_path = false,
			extension = "png",
		},
	},
	keys = {
		{ "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
	},
}
