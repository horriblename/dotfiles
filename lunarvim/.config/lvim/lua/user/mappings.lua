-- override some keymaps
lvim.keys.insert_mode["<C-t>"] = false
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

lvim.keys.normal_mode["<A-n>"] = ":BufferLineCycleNext<cr>"
lvim.keys.normal_mode["<A-p>"] = ":BufferLineCyclePrev<cr>"
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

lvim.builtin.which_key.mappings['q'] = { ":q<CR>", "Close Window" }
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
-- vim.cmd 'nunmap <leader>v'
-- vim.cmd 'nunmap <leader>h'
lvim.builtin.which_key.mappings['v'] = { ':FocusSplitRight<CR>', "Split to Right" }
lvim.builtin.which_key.mappings['h'] = { ':FocusSplitDown<CR>', "Split to Below" }
