--
-- LSP setup
--

-- Mason
require 'mason'.setup {}
require 'mason-lspconfig'.setup {
	ensure_installed = { "astro", "clangd", "golangci_lint_ls", "lua_ls", "omnisharp", "tailwindcss", "taplo", "tsserver",
		"vimls", "yamlls" },
}

-- LSPs
require 'lspconfig'.clangd.setup {}
require 'lspconfig'.golangci_lint_ls.setup {}

require 'lspconfig'.lua_ls.setup {
	settings = {
		Lua = {
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { 'vim' },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
		},
	},
}

require 'lspconfig'.taplo.setup {}
require 'lspconfig'.tsserver.setup {}
-- require 'lspconfig'.tailwindcss.setup {}
require 'lspconfig'.tsserver.setup {}
require 'lspconfig'.vimls.setup {}
require 'lspconfig'.yamlls.setup {}
require 'lspconfig'.astro.setup {}
require 'lspconfig'.prismals.setup {}
require 'lspconfig'.gopls.setup {}

--
-- C# Hack
--
-- This prevents "hidden" diagnostics from showing up
-- in the trouble window for auto-generated or module files
--
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
