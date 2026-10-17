local map = vim.keymap.set

-- Common
map({ "n", "v" }, "<esc>", ":noh<CR>", { desc = "Clear highlighting after search" })
map({ "n", "v" }, "<leader>w", ":write<CR>", { desc = "Write file" })
map({ "n", "v" }, "<leader>q", ":wq<CR>", { desc = "Write & quit file" })
map({ "n", "v" }, "<leader>y", '"+y<CR>', { desc = "Copy to system clipboard" })

-- Search
map({ "n", "v" }, "<leader>ff", ":FzfLua files<CR>", { desc = "Search file in project" })
map({ "n", "v" }, "<leader>fg", ":FzfLua live_grep_native<CR>", { desc = "Grep in project" })
map({ "n", "v" }, "<leader>fw", ":FzfLua grep_cword<CR>", { desc = "Grep word under cursor" })

-- LSPs
map({ "n", "v" }, "gr", ":FzfLua lsp_references<CR>", { desc = "LSP references / backlinks" })
map({ "n", "v" }, "gi", ":FzfLua lsp_implementations<CR>", { desc = "LSP implementations" })
map({ "n", "v" }, "gd", ":FzfLua lsp_definitions<CR>", { desc = "LSP definitions" })
