return {
	{
		"rmagatti/auto-session",
		dependencies = {
			"nvim-telescope/telescope.nvim", -- Only needed if you want to use sesssion lens
		},
		config = function()
			require("auto-session").setup({
				auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			})
			vim.keymap.set("n", "<C-s>c", require("auto-session.session-lens").search_session, {
				noremap = true,
				desc = "Change Session",
			})
			vim.keymap.set("n", "<C-s>s", ":SessionSave<CR>", { desc = "Save Session" })
			vim.keymap.set("n", "<C-s>d", ":SessionDelete<CR>", { desc = "Delete Session" })
		end,
	},
}
