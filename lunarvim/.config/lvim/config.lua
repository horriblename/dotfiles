--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
-- general
vim.cmd('source ~/.config/nvim/init.vim')
lvim.log.level = "warn"
lvim.colorscheme = "tokyonight"
lvim.format_on_save = true
vim.opt.scrolloff = 8
vim.opt.timeoutlen = 0
vim.opt.foldmethod = "syntax"
vim.opt.foldenable = false
vim.opt.foldtext = "v:folddashes.' '.getline(v:foldstart).' ('.(v:foldend-v:foldstart).' lines)'"
vim.opt.guifont = "FiraCode Nerd Font:h12"
lvim.leader = "space"
lvim.undofile = true

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
-- lvim.builtin.bufferline.highlights = vim.tbl_extend("force", lvim.builtin.bufferline.highlights, {
-- 	indicator_selected = { guifg = { attribute = "bg", highlight = "PmenuSel" } },
-- 	tab_selected = { guifg = { attribute = "fg", highlight = "Pmenu" } }
-- })
lvim.builtin.bufferline.on_config_done = function()
	local groups = require 'bufferline.groups'
	groups = {
		items = {
			{
				name = 'Meta',
				matcher = function(buf)
					local keywords = {
						'go.mod', 'go.sum', 'requirements.txt', '%.git.*'
					}

					for _, v in ipairs(keywords) do
						if buf.filename:match(v) then return true end
					end
					return false
				end
			}
		}
	}
end
lvim.builtin.dap.active = true
lvim.builtin.lualine.active = true
lvim.builtin.lualine.options.theme = 'tokyonight'
lvim.builtin.notify.active = true
lvim.builtin.nvimtree.setup = {
	disable_netrw = false,
	hijack_netrw = false,
	open_on_tab = true,
	view = {
		side = "left",
		mappings = {
			list = {
				-- help page: nvim-tree-mappings
				{ key = { "<C-t>", "c" }, action = nil },
				{ key = "i", action = "toggle_file_info" },
				{ key = "y", action = "copy" },
				{ key = "cf", action = "copy_name" },
				{ key = "cl", action = "copy_absolute_path" },
				{ key = "gx", action = "system_open" },
				{ key = "l", action = "edit" },
				{ key = "d", action = "trash" },
				{ key = "D", action = "remove" },
			},
		},
	}
}

lvim.builtin.terminal.active = true
lvim.builtin.terminal.on_config_done = function()
	vim.cmd 'iunmap <C-T>'
end
lvim.builtin.cmp.mapping['<Tab>'] = nil
vim.list_extend(lvim.builtin.project.patterns, { "=lvim", "index.*", ".anchor" })

-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
	i = { -- input mode
		["<C-j>"] = actions.move_selection_next,
		["<C-k>"] = actions.move_selection_previous,
		["<C-n>"] = actions.cycle_history_next,
		["<C-p>"] = actions.cycle_history_prev,
	},
	n = { -- normal mode
		["<C-n>"] = actions.cycle_history_next,
		["<C-p>"] = actions.cycle_history_prev,
	},
}

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
	"bash",
	"c",
	"javascript",
	"json",
	"lua",
	"python",
	"typescript",
	"css",
	"rust",
	"java",
	"yaml",
	"go",
	"haskell",
}

lvim.builtin.treesitter.ignore_install = {}
--lvim.builtin.treesitter.highlight.enable = true
lvim.builtin.treesitter.rainbow = {
	enable = true,
	extended_mode = true,
}

lvim.builtin.which_key.active = true

require "user.extraplugins"
require "user.mappings"

-- random filetype related settings
vim.g.hs_highlight_delimiters = 1
vim.g.hs_highlight_boolean = 1

-- generic LSP settings

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheReset` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
-- vim.list_extend(lvim.lsp.override, { "pylsp" })

-- ---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
local opts = {} -- check the lspconfig documentation for a list of all possible options

-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end
-- you can overwrite the null_ls setup table (useful for setting the root_dir function)
-- lvim.lsp.null_ls.setup = {
--   root_dir = require("lspconfig").util.root_pattern("Makefile", ".git", "node_modules"),
-- }
-- or if you need something more advanced
-- lvim.lsp.null_ls.setup.root_dir = function(fname)
--   if vim.bo.filetype == "javascript" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "node_modules")(fname)
--       or require("lspconfig/util").path.dirname(fname)
--   elseif vim.bo.filetype == "php" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "composer.json")(fname) or vim.fn.getcwd()
--   else
--     return require("lspconfig/util").root_pattern("Makefile", ".git")(fname) or require("lspconfig/util").path.dirname(fname)
--   end
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { exe = "black", filetypes = { "python" } },
--   { exe = "isort", filetypes = { "python" } },
--   {
--     exe = "prettier",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     args = { "--print-with", "100" },
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { exe = "flake8", filetypes = { "python" } },
--   {
--     exe = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     args = { "--severity", "warning" },
--   },
--   {
--     exe = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }


-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
--   { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
-- }
lvim.autocommands.external_open = {
	{ "BufEnter", "*.png", "call jobstart('nsxiv -N nsxiv-float ' .. expand('%')) | bd" }
}
lvim.autocommands.color_tweaks = {
	{ "ColorScheme", "*", "hi markdownTSStrong cterm=bold ctermfg=yellow gui=bold guifg=yellow" },
	{ "ColorScheme", "*", "hi markdownTSEmphasis cterm=italic ctermfg=yellow gui=italic guifg=yellow" }
}
