vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.prettier.with({
			-- Optional: You can specify the location of the Prettier executable
			command = "/opthomebrew/bin/prettier",
		}),
		null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.completion.spell,
	},
})
vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end)

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	callback = function() vim.lsp.buf.format() end,
})
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
	pattern = { "*" },
	callback = function() vim.lsp.buf.format() end,
})
