--
-- nvim-tree
--
require 'nvim-tree'.setup {
	sort_by = "case_sensitive",
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = true,
	},
	diagnostics = {
		enable,
	},
	actions = {
		open_file = {
			quit_on_open = true,
		},
	},
	git = {
		enable = true,
	},
}

vim.keymap.set('n', '<C-b>', '<Cmd>NvimTreeFocus<CR>')
vim.keymap.set('n', '<C-S-b>', '<Cmd>NvimTreeToggle<CR>')

--
-- fzf Fuzzy File Finder
--
vim.keymap.set('n', '<C-p>', '<Cmd>Files<CR>')
