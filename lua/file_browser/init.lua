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

vim.keymap.set('n', '<C-b>', '<Cmd>NvimTreeFindFile<CR>')
vim.keymap.set('n', '<C-S-b>', '<Cmd>NvimTreeToggle<CR>')
vim.keymap.set('n', '<tab>', '<Cmd>NvimTreeFindFile<CR>')

--
-- fzf Fuzzy File Finder
--
vim.keymap.set('n', '<C-p>', '<Cmd>Files<CR>')
vim.keymap.set('n', '<C-S-p>', '<Cmd>Rg<CR>')
vim.keymap.set('n', '<S-tab>', '<Cmd>Files<CR>')
