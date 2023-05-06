require("toggleterm").setup({
	size = function(term)
		if term.direction == "horizontal" then
			return 15
		elseif term.direction == "vertical" then
			return 80
		end
	end,
})

local Terminal = require('toggleterm.terminal').Terminal
local right_term = Terminal:new({
	direction = 'vertical',
	highlights = {
		Terminal = {},
	},
	on_open = function()
		vim.cmd('startinsert!')
		local opts = { buffer = 0 }
		vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
		vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
		vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
		vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
		vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
		vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
		vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
	end
})

function RightTermToggle()
	right_term:toggle()
end

vim.keymap.set('n', '<leader><leader>t', [[<Cmd>lua RightTermToggle()<CR>]], { noremap = true, silent = true })
