-- Default formatting options
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Clipboard
vim.api.nvim_set_option("clipboard", "unnamed") -- use system clipboard

--
-- Plugins via Plug
--

local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

-- LSPs
Plug 'neovim/nvim-lspconfig'                                        -- Common LSP Configs
Plug('williamboman/mason.nvim', { ['do'] = vim.fn['MasonUpdate'] }) -- Manages LSPs	
Plug 'williamboman/mason-lspconfig.nvim'                            -- Connects Mason to nvim-lspconfig
Plug 'jose-elias-alvarez/null-ls.nvim'                              -- LSP for linting, formatting, etc

-- Astro (web dev)
Plug 'wuelnerdotexe/vim-astro'

-- Utilities
Plug 'nvim-lua/plenary.nvim' -- Common nvim lua functions

-- Git integration
Plug 'tanvirtin/vgit.nvim'

-- Autocomplete
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

-- AI Assistants
Plug 'github/copilot.vim'

-- Fuzzy File Finder
Plug('junegunn/fzf', { ['do'] = vim.fn['fzf#install()'] })
Plug 'junegunn/fzf.vim'

-- Commenting things out
Plug 'numToStr/Comment.nvim'

-- File Browser
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'

-- Trouble (Diagnostics) Window
Plug 'folke/trouble.nvim'

-- Themes
Plug('catppuccin/nvim', { ['as'] = 'catppuccin' })
Plug('folke/tokyonight.nvim', { ['branch'] = 'main' })
Plug 'jdotw/sonokai'

-- Symbols Window
Plug 'simrat39/symbols-outline.nvim'

-- Code Actions
Plug 'weilbith/nvim-code-action-menu'

-- Tree Sitter
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })

--
-- End of Plugins
--
vim.call('plug#end')

-- TODO: Not sure who uses this
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--
-- Our Modules
--
require 'file_browser'
require 'lsp'
require 'completion'
require 'commentout'
require 'git'
require 'diagnostic'
require 'colorscheme'
require 'symbol'
require 'formatting'
require 'highlighting'

-- Remaps
vim.keymap.set('n', '<C-h>', '<Cmd>History<CR>')
