vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true

local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'wuelnerdotexe/vim-astro'
Plug('williamboman/mason.nvim', { ['do'] = vim.fn['MasonUpdate'] })
Plug 'williamboman/mason-lspconfig.nvim'

Plug 'nvim-lua/plenary.nvim'
Plug 'tanvirtin/vgit.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

-- For vsnip users.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

Plug 'github/copilot.vim'

Plug('junegunn/fzf', { ['do'] = vim.fn['fzf#install()'] })
Plug 'junegunn/fzf.vim'

Plug 'numToStr/Comment.nvim'

Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'

Plug 'folke/trouble.nvim'

Plug('catppuccin/nvim', { ['as'] = 'catppuccin' })
Plug('folke/tokyonight.nvim', { ['branch'] = 'main' })
Plug 'sainnhe/sonokai'

Plug 'jose-elias-alvarez/null-ls.nvim'

Plug 'simrat39/symbols-outline.nvim'

Plug 'weilbith/nvim-code-action-menu'

vim.call('plug#end')

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

-- OR setup with some options
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

require 'comment'.setup {}
require 'mason'.setup {}
require 'mason-lspconfig'.setup {
	ensure_installed = { "astro", "clangd", "golangci_lint_ls", "lua_ls", "omnisharp", "tailwindcss", "taplo", "tsserver",
		"vimls", "yamlls" },
}
require 'lspconfig'.astro.setup {}
require 'lspconfig'.clangd.setup {}
require 'lspconfig'.golangci_lint_ls.setup {}
require 'lspconfig'.lua_ls.setup {}
require 'lspconfig'.taplo.setup {}
require 'lspconfig'.tsserver.setup {}
require 'lspconfig'.tailwindcss.setup {}
require 'lspconfig'.tsserver.setup {}
require 'lspconfig'.vimls.setup {}
require 'lspconfig'.yamlls.setup {}

local function filter_diagnostics(result)
	local fname = vim.uri_to_fname(result.uri)
	local patterns = { ".*[/\\][Oo]bj[/\\].*%.cs$", ".*[/\\]%.nuget[/\\].*$", ".*[/\\][Mm]igrations[/\\].*%.cs$" }
	for _, pattern in ipairs(patterns) do
		if string.match(fname, pattern) then
			return {}
		end
	end
	return result.diagnostics
end

local lsp_publish_diagnostics = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
})

local function custom_publish_diagnostics(err, result, ctx, config)
	if not err then
		result.diagnostics = filter_diagnostics(result)
	end
	lsp_publish_diagnostics(err, result, ctx, config)
end

require 'lspconfig'.omnisharp.setup {
	filetypes = { "cs" },
	handlers = {
		["textDocument/publishDiagnostics"] = custom_publish_diagnostics,
	},
}

-- Set up nvim-cmp.
local cmp = require 'cmp'

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' }, -- For vsnip users.
		-- { name = 'luasnip' }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
	}, {
		{ name = 'buffer' },
	})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = 'buffer' },
	})
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['tailwindcss'].setup {
	capabilities = capabilities
}

vim.o.updatetime = 300
vim.o.incsearch = false
vim.wo.signcolumn = 'yes'
require('vgit').setup({
	keymaps = {
		['n <C-k>'] = function() require('vgit').hunk_up() end,
		['n <C-j>'] = function() require('vgit').hunk_down() end,
		['n <leader>gs'] = function() require('vgit').buffer_hunk_stage() end,
		['n <leader>gr'] = function() require('vgit').buffer_hunk_reset() end,
		['n <leader>gp'] = function() require('vgit').buffer_hunk_preview() end,
		['n <leader>gb'] = function() require('vgit').buffer_blame_preview() end,
		['n <leader>gf'] = function() require('vgit').buffer_diff_preview() end,
		['n <leader>gh'] = function() require('vgit').buffer_history_preview() end,
		['n <leader>gu'] = function() require('vgit').buffer_reset() end,
		-- ['n <leader>gg'] = function() require('vgit').buffer_gutter_blame_preview() end,
		['n <leader>glu'] = function() require('vgit').buffer_hunks_preview() end,
		['n <leader>gls'] = function() require('vgit').project_hunks_staged_preview() end,
		['n <leader>gd'] = function() require('vgit').project_diff_preview() end,
		['n <leader>gq'] = function() require('vgit').project_hunks_qf() end,
		['n <leader>gx'] = function() require('vgit').toggle_diff_preference() end,

	},
	settings = {
		git = {
			cmd = 'git', -- optional setting, not really required
			fallback_cwd = vim.fn.expand("$HOME"),
			fallback_args = {
				"--git-dir",
				vim.fn.expand("$HOME/dots/yadm-repo"),
				"--work-tree",
				vim.fn.expand("$HOME"),
			},
		},
		hls = {
			GitBackground = 'Normal',
			GitHeader = 'NormalFloat',
			GitFooter = 'NormalFloat',
			GitBorder = 'LineNr',
			GitLineNr = 'LineNr',
			GitComment = 'Comment',
			GitSignsAdd = {
				gui = nil,
				fg = '#d7ffaf',
				bg = nil,
				sp = nil,
				override = false,
			},
			GitSignsChange = {
				gui = nil,
				fg = '#7AA6DA',
				bg = nil,
				sp = nil,
				override = false,
			},
			GitSignsDelete = {
				gui = nil,
				fg = '#e95678',
				bg = nil,
				sp = nil,
				override = false,
			},
			GitSignsAddLn = 'DiffAdd',
			GitSignsDeleteLn = 'DiffDelete',
			GitWordAdd = {
				gui = nil,
				fg = nil,
				bg = '#5d7a22',
				sp = nil,
				override = false,
			},
			GitWordDelete = {
				gui = nil,
				fg = nil,
				bg = '#960f3d',
				sp = nil,
				override = false,
			},
		},
		live_blame = {
			enabled = true,
			format = function(blame, git_config)
				local config_author = git_config['user.name']
				local author = blame.author
				if config_author == author then
					author = 'You'
				end
				local time = os.difftime(os.time(), blame.author_time)
						/ (60 * 60 * 24 * 30 * 12)
				local time_divisions = {
					{ 1,  'years' },
					{ 12, 'months' },
					{ 30, 'days' },
					{ 24, 'hours' },
					{ 60, 'minutes' },
					{ 60, 'seconds' },
				}
				local counter = 1
				local time_division = time_divisions[counter]
				local time_boundary = time_division[1]
				local time_postfix = time_division[2]
				while time < 1 and counter ~= #time_divisions do
					time_division = time_divisions[counter]
					time_boundary = time_division[1]
					time_postfix = time_division[2]
					time = time * time_boundary
					counter = counter + 1
				end
				local commit_message = blame.commit_message
				if not blame.committed then
					author = 'You'
					commit_message = 'Uncommitted changes'
					return string.format(' %s • %s', author, commit_message)
				end
				local max_commit_message_length = 255
				if #commit_message > max_commit_message_length then
					commit_message = commit_message:sub(1, max_commit_message_length) .. '...'
				end
				return string.format(
					' %s, %s • %s',
					author,
					string.format(
						'%s %s ago',
						time >= 0 and math.floor(time + 0.5) or math.ceil(time - 0.5),
						time_postfix
					),
					commit_message
				)
			end,
		},
		live_gutter = {
			enabled = true,
			edge_navigation = true, -- This allows users to navigate within a hunk
		},
		authorship_code_lens = {
			enabled = true,
		},
		scene = {
			diff_preference = 'unified', -- unified or split
			keymaps = {
				quit = 'q'
			}
		},
		diff_preview = {
			keymaps = {
				buffer_stage = 'S',
				buffer_unstage = 'U',
				buffer_hunk_stage = 's',
				buffer_hunk_unstage = 'u',
				toggle_view = 't',
			},
		},
		project_diff_preview = {
			keymaps = {
				buffer_stage = 's',
				buffer_unstage = 'u',
				buffer_hunk_stage = 'gs',
				buffer_hunk_unstage = 'gu',
				buffer_reset = 'r',
				stage_all = 'S',
				unstage_all = 'U',
				reset_all = 'R',
			},
		},
		project_commit_preview = {
			keymaps = {
				save = 'S',
			},
		},
		signs = {
			priority = 10,
			definitions = {
				GitSignsAddLn = {
					linehl = 'GitSignsAddLn',
					texthl = nil,
					numhl = nil,
					icon = nil,
					text = '',
				},
				GitSignsDeleteLn = {
					linehl = 'GitSignsDeleteLn',
					texthl = nil,
					numhl = nil,
					icon = nil,
					text = '',
				},
				GitSignsAdd = {
					texthl = 'GitSignsAdd',
					numhl = nil,
					icon = nil,
					linehl = nil,
					text = '┃',
				},
				GitSignsDelete = {
					texthl = 'GitSignsDelete',
					numhl = nil,
					icon = nil,
					linehl = nil,
					text = '┃',
				},
				GitSignsChange = {
					texthl = 'GitSignsChange',
					numhl = nil,
					icon = nil,
					linehl = nil,
					text = '┃',
				},
			},
			usage = {
				screen = {
					add = 'GitSignsAddLn',
					remove = 'GitSignsDeleteLn',
				},
				main = {
					add = 'GitSignsAdd',
					remove = 'GitSignsDelete',
					change = 'GitSignsChange',
				},
			},
		},
		symbols = {
			void = '⣿',
		},
	}
})

require 'trouble'.setup {
	-- your configuration comes here
	-- or leave it empty to use the default settings
	-- refer to the configuration section below
}

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

vim.keymap.set('n', '<Leader>xx', '<Cmd>TroubleToggle<CR>')
vim.keymap.set('n', '<leader>xw', '<Cmd>TroubleToggle workspace_diagnostics<CR>')
vim.keymap.set('n', '<leader>xd', '<Cmd>TroubleToggle document_diagnostics<CR>')
vim.keymap.set('n', '<leader>xq', '<Cmd>TroubleToggle quickfix<CR>')
vim.keymap.set('n', '<leader>xl', '<Cmd>TroubleToggle loclist<CR>')
vim.keymap.set('n', 'gR', '<Cmd>TroubleToggle lsp_references<CR>')

vim.keymap.set('n', '<C-s>', '<Cmd>NvimTreeClose<CR><Cmd>SymbolsOutline<CR>')
vim.keymap.set('n', '<C-S-s>', '<Cmd>SymbolsOutlineClose<CR>')

vim.keymap.set('n', '<C-b>', '<Cmd>NvimTreeFocus<CR>')
vim.keymap.set('n', '<C-S-b>', '<Cmd>NvimTreeToggle<CR>')
vim.keymap.set('n', '<C-p>', '<Cmd>Files<CR>')

vim.cmd [[
	let g:sonokai_style = 'shusia'
	let g:sonokai_better_performance = 1
	colorscheme sonokai
]]

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

require 'symbols-outline'.setup {
	highlight_hovered_item = true,
	show_guides = true,
	auto_preview = false,
	position = 'left',
	relative_width = true,
	width = 16,
	auto_close = false,
	show_numbers = false,
	show_relative_numbers = false,
	show_symbol_details = true,
	preview_bg_highlight = 'Pmenu',
	autofold_depth = nil,
	auto_unfold_hover = true,
	fold_markers = { '', '' },
	wrap = false,
	keymaps = {
		-- These keymaps can be a string or a table for multiple keys
		close = { "<Esc>", "q" },
		goto_location = "<Cr>",
		focus_location = "o",
		hover_symbol = "<C-space>",
		toggle_preview = "K",
		rename_symbol = "r",
		code_actions = "a",
		fold = "h",
		unfold = "l",
		fold_all = "W",
		unfold_all = "E",
		fold_reset = "R",
	},
	lsp_blacklist = {},
	symbol_blacklist = {},
	symbols = {
		File = { icon = "", hl = "@text.uri" },
		Module = { icon = "", hl = "@namespace" },
		Namespace = { icon = "", hl = "@namespace" },
		Package = { icon = "", hl = "@namespace" },
		Class = { icon = "𝓒", hl = "@type" },
		Method = { icon = "ƒ", hl = "@method" },
		Property = { icon = "", hl = "@method" },
		Field = { icon = "", hl = "@field" },
		Constructor = { icon = "", hl = "@constructor" },
		Enum = { icon = "ℰ", hl = "@type" },
		Interface = { icon = "ﰮ", hl = "@type" },
		Function = { icon = "", hl = "@function" },
		Variable = { icon = "", hl = "@constant" },
		Constant = { icon = "", hl = "@constant" },
		String = { icon = "𝓐", hl = "@string" },
		Number = { icon = "#", hl = "@number" },
		Boolean = { icon = "⊨", hl = "@boolean" },
		Array = { icon = "", hl = "@constant" },
		Object = { icon = "⦿", hl = "@type" },
		Key = { icon = "🔐", hl = "@type" },
		Null = { icon = "NULL", hl = "@type" },
		EnumMember = { icon = "", hl = "@field" },
		Struct = { icon = "𝓢", hl = "@type" },
		Event = { icon = "🗲", hl = "@type" },
		Operator = { icon = "+", hl = "@operator" },
		TypeParameter = { icon = "𝙏", hl = "@parameter" },
		Component = { icon = "", hl = "@function" },
		Fragment = { icon = "", hl = "@constant" },
	},
}

vim.keymap.set('n', 'ca', function() vim.lsp.buf.code_action() end)
vim.keymap.set('n', '<leader>.', '<cmd>CodecctionMenu<cr>')

vim.keymap.set('n', '//', '<Plug>(comment_toggle_linewise_current)')
vim.keymap.set('x', '//', '<Plug>(comment_toggle_linewise_visual)')
