vim.diagnostic.config({
	underline = {
		severity = { max = vim.diagnostic.severity.INFO }
	},
	virtual_text = {
		severity = { min = vim.diagnostic.severity.INFO }
	},
	signs = {
		severity = { min = vim.diagnostic.severity.INFO }
	}
})

--
-- Trouble Window
--
require 'trouble'.setup {
	-- your configuration comes here
	-- or leave it empty to use the default settings
	-- refer to the configuration section below
}
vim.keymap.set('n', '<leader><leader>x', '<Cmd>TroubleToggle document_diagnostics<CR>')
vim.keymap.set('n', '<Leader>xx', '<Cmd>TroubleToggle<CR>')
vim.keymap.set('n', '<leader>xw', '<Cmd>TroubleToggle workspace_diagnostics<CR>')
vim.keymap.set('n', '<leader>xd', '<Cmd>TroubleToggle document_diagnostics<CR>')
vim.keymap.set('n', '<leader>xq', '<Cmd>TroubleToggle quickfix<CR>')
vim.keymap.set('n', '<leader>xl', '<Cmd>TroubleToggle loclist<CR>')
vim.keymap.set('n', 'gR', '<Cmd>TroubleToggle lsp_references<CR>')

--
-- Code Action
--
vim.keymap.set('n', 'ca', function() vim.lsp.buf.code_action() end)
vim.keymap.set('n', '<leader>.', '<cmd>CodeActionMenu<cr>')
