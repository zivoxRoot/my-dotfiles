return {
	"saghen/blink.cmp",
	version = "*",
	opts = {
		keymap = { preset = "default" },
		snippets = { preset = "default" }, -- native vim.snippet — this is already the default

		completion = {
			-- opens automatically as you type keywords (this is already the default,
			-- listed here so it's explicit)
			trigger = {
				show_on_keyword = true,
				show_on_trigger_character = true,
			},

			list = {
				selection = {
					preselect = false, -- <- nothing highlighted/selected on open
					auto_insert = true, -- <- and nothing gets inserted as you move through it
				},
			},

			menu = {
				auto_show = true,
				border = "rounded",
				draw = {
					columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
				},
			},

			documentation = {
				auto_show = true, -- keep the popup itself clean; press the doc keymap to see it
			},

			ghost_text = { enabled = true },
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
	},
}
