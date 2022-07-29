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
lvim.format_on_save = true
vim.opt.scrolloff = 8
vim.opt.timeoutlen = 0
vim.opt.foldmethod = "syntax"
vim.opt.foldenable = false
vim.opt.foldtext = "v:folddashes.' '.getline(v:foldstart).' ('.(v:foldend-v:foldstart).' lines)'"
vim.opt.guifont = "FiraCode Nerd Font:h12"

-- Set undo history file
lvim.undofile = true

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
-- override some keymaps
lvim.keys.normal_mode["<space>q"] = "<cmd>q<cr>"
lvim.keys.normal_mode["<space>e"] = "<cmd>NvimTreeToggle<cr>"

lvim.keys.normal_mode["<C-Tab>"] = ":BufferLineCycleNext<cr>"
lvim.keys.normal_mode["<C-S-Tab>"] = ":BufferLineCyclePrev<cr>"
lvim.keys.insert_mode["<C-Tab>"] = "<Esc>:BufferLineCycleNext<cr>"
lvim.keys.insert_mode["<C-S-Tab>"] = "<Esc>:BufferLineCyclePrev<cr>"
lvim.keys.normal_mode["<C-l>"] = ":BufferLineCycleNext<cr>"
lvim.keys.normal_mode["<C-h>"] = ":BufferLineCyclePrev<cr>"

lvim.keys.normal_mode["<C-j>"] = ":tabnext<cr>"
lvim.keys.normal_mode["<C-k>"] = ":tabprevious<cr>"

lvim.keys.normal_mode["L"] = "g_"
lvim.keys.normal_mode["H"] = "^"
lvim.keys.visual_mode["L"] = "g_"
lvim.keys.visual_mode["H"] = "^"

lvim.keys.normal_mode["<A-1>"] = ":BufferLineGoToBuffer 1<cr>"
lvim.keys.normal_mode["<A-2>"] = ":BufferLineGoToBuffer 2<cr>"
lvim.keys.normal_mode["<A-3>"] = ":BufferLineGoToBuffer 3<cr>"
lvim.keys.normal_mode["<A-4>"] = ":BufferLineGoToBuffer 4<cr>"
lvim.keys.normal_mode["<A-5>"] = ":BufferLineGoToBuffer 5<cr>"
lvim.keys.normal_mode["<A-6>"] = ":BufferLineGoToBuffer 6<cr>"
lvim.keys.normal_mode["<A-7>"] = ":BufferLineGoToBuffer 7<cr>"
lvim.keys.normal_mode["<A-8>"] = ":BufferLineGoToBuffer 8<cr>"
lvim.keys.normal_mode["<A-9>"] = ":BufferLineLast<cr>"

-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = false

lvim.builtin.which_key.opts.noremap = false
lvim.builtin.which_key.mappings['h'] = ":split<CR>"
lvim.builtin.which_key.mappings['L']['L'] = { ":lua lvim.", "More options..." }
lvim.builtin.which_key.mappings['f'] = { ":lua require('telescope.builtin').fd { follow = true }<cr>", "Find File" }
lvim.builtin.which_key.mappings['S'] = {
   name = "Session",
   c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
   l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
   Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
}
lvim.builtin.which_key.mappings['s']['p'] = { ":Telescope projects<CR>", "Recent Projects" }
lvim.builtin.which_key.mappings['P'] = { ":PasteImage<CR>", "Paste Image" }
vim.cmd 'nunmap <leader>v'
vim.cmd 'nunmap <leader>h'
lvim.builtin.which_key.mappings['v'] = { ':FocusSplitRight<CR>', "Split to Right" }
lvim.builtin.which_key.mappings['h'] = { ':FocusSplitDown<CR>', "Split to Below" }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.bufferline.highlights = vim.tbl_extend("force", lvim.builtin.bufferline.highlights, {
   indicator_selected = {
      guifg = { attribute = "bg", highlight = "PmenuSel" }
   },
   tab_selected = {
      guifg = { attribute = "fg", highlight = "Pmenu" }
   }
})
lvim.builtin.dap.active = true
lvim.builtin.lualine.active = true
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
vim.list_extend(lvim.builtin.project.patterns, { "=lvim", "index.*" })

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

require "user.extraplugins"

-- generic LSP settings

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheRest` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
vim.list_extend(lvim.lsp.override, { "pylsp" })

-- ---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
local opts = {} -- check the lspconfig documentation for a list of all possible options
require("lvim.lsp.manager").setup("pylsp", {
   cmd = 'podman run -it -p 8888:8888/tcp -p 8000:8000 -v "$HOME/repo/crypto-trading-comp":/srv --rm --name temppy3.7 localhost/py3.7:latest pylsp'
})

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
