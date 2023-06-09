-- TODO: Not sure if these are needed or specific to git
vim.o.updatetime  = 300
vim.o.incsearch   = false
vim.wo.signcolumn = 'yes'

local Terminal    = require('toggleterm.terminal').Terminal

local lazygit     = Terminal:new({
	cmd = "lazygit",
	dir = "git_dir",
	direction = "float",
	highlights = {
		NormalFloat = {},
	},
	float_opts = {
		border = "curved",
	},
	-- function to run on opening the terminal
	on_open = function(term)
		vim.cmd("startinsert!")
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
	end,
	-- function to run on closing the terminal
	on_close = function(term)
		vim.cmd("startinsert!")
	end,
})

function LazyGitToggle()
	lazygit:toggle()
end

vim.api.nvim_set_keymap("n", "<leader><leader>g", "<cmd>lua LazyGitToggle()<CR>", { noremap = true, silent = true })
