-- a list of filetypes that I usually want to exclude from plugins
local HUD = {
	"dashboard",
	"alpha",
	"NvimTree",
	"netrw",
	"lspinfo",
	"lsp-installer",
	"packer",
	"checkhealth",
	"help",
	"man",
	""
}

-- command bindings related to extra plugins
vim.cmd('command! PasteImage :call mdip#MarkdownClipboardImage()<CR>')

lvim.autocommands.user_settings = {
	{ 'BufWritePost', 'extraplugins.lua', 'lua require("lvim.config"):reload()' },
}

-- Additional Plugins
lvim.plugins = {
	{
		"folke/tokyonight.nvim",
	},
	{
		"jpalardy/vim-slime",
		ft = "python"
	},
	{
		"hanschen/vim-ipython-cell",
		ft = "python"
	},
	{ "p00f/nvim-ts-rainbow" },
	{
		"kevinhwang91/nvim-hlslens",
		disable = true,
		config = function()
			require("hlslens").setup()
		end
	},
	{
		"petertriho/nvim-scrollbar",
		disable = true,
		config = function()
			require("scrollbar").setup({
				handle = {
					text = " ",
					color = nil,
					cterm = nil,
					highlight = "Cursor",
					hide_if_all_visible = true, -- Hides handle if all lines are visible
				},
			})
		end
	},
	{ "tpope/vim-vinegar" },
	{
		"norcalli/nvim-colorizer.lua",
		event = "BufRead",
		config = function()
			require("colorizer").setup({ "*" }, {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
			})
		end,
	},
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		module = "persistence",
		config = function()
			require("persistence").setup {
				dir = vim.fn.expand(vim.fn.stdpath("data") .. "/session/", false, false),
				options = { "buffers", "curdir", "tabpages", "winsize" },
			}
		end
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufRead",
		-- cmd = "IndentBlanklineEnable",
		config = function()
			-- vim.highlight.create("IndentBlanklineContextChar", { guifg = 'yellow', gui = 'nocombine' })
			require("indent_blankline").setup {
				char = "▏",
				context_char = "▏",
				filetype_exclude = HUD,
				buftype_exclude = { "terminal" },
				show_trailing_blankline_indent = false,
				show_first_indent_level = false,
				show_current_context = true,
				show_current_context_start = true,
			}
		end
	},
	{
		"joom/latex-unicoder.vim",
		ft = { "markdown", "vimwiki" },
		keys = {
			{ "i", "<C-l>" }
		},
		setup = function()
			vim.g.unicoder_cancel_normal = 1
		end

	},
	{
		"romgrk/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup {

				enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
				throttle = true, -- Throttles plugin updates (may improve performance)
				max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
				patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
					-- For all filetypes
					-- Note that setting an entry here replaces all other patterns for this entry.
					-- By setting the 'default' entry below, you can control which nodes you want to
					-- appear in the context window.
					go = {
						'for',
						'if',
						'switch',
						'case',
						'func',
						'interface',
						'struct',
					},
					markdown = {
						'heading_content',
						-- 'list_item'
					}
				},
			}
		end
	},
	{
		'jakewvincent/mkdnflow.nvim',
		ft = "markdown",
		rocks = 'luautf8',
		config = function()
			require('mkdnflow').setup {
				-- Config goes here; leave blank for defaults
				links = { conceal = true },
				perspective = { root_tell = 'index.md' },
				mappings = {
					MkdnEnter = { { 'i', 'n', 'v' }, '<CR>' },
					MkdnNextLink = false,
					MkdnPrevLink = false,
					MkdnFollowLink = { { 'n', 'v' }, '<A-CR>' },
					MkdnDestroyLink = { 'n', 'K' },

					MkdnTableNextRow = false,
					MkdnTablePrevRow = { 'i', '<M-CR>' },
					MkdnTableNewRowBelow = { 'n', '<leader>ir' },
					MkdnTableNewRowAbove = { 'n', '<leader>iR' },
					MkdnTableNewColAfter = { 'n', '<leader>ic' },
					MkdnTableNewColBefore = { 'n', '<leader>iC' },
				}
			}
		end
	},
	{
		'ferrine/md-img-paste.vim',
		ft = "markdown",
		fn = 'mdip#MarkdownClipboardImage',
		setup = function()
			vim.g.mdip_imgdir = 'attachments'
			vim.g.PasteImageFunction = 'g:WikiPasteImage'
			vim.cmd [=[
function! g:WikiPasteImage(relpath)
	call append('.','![['.a:relpath.']]')
endfunction
]=]
		end,
	},
	{
		'beauwilliams/focus.nvim',
		cmd = 'Focus*',
		module = 'focus',
		config = function()
			require('focus').setup()
		end
	},
	{
		'nvim-treesitter/playground',
		cmd = "TSPlaygroundToggle",
		config = function()
			require('nvim-treesitter.configs').setup {}
		end
	},
}
