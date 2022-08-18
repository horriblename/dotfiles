let mapleader=" "

" Use system clipboard
set clipboard=unnamedplus

" Enable and disable auto comment
map <leader>c :setlocal formatoptions-=cro<CR>
map <leader>C :setlocal formatoptions=cro<CR>

" Enable spell checking, s for spell check
map <leader>s :setlocal spell! spelllang=en_us<CR>

" Enable Disable Auto Indent
map <leader>i :setlocal autoindent<CR>
map <leader>I :setlocal noautoindent<CR>

" Shell Check
map <leader>p :!clear && shellcheck %<CR>

" Compile and open output
map <leader>G :w! \| !comp <c-r>%<CR><CR>
map <leader>o :!opout <c-r>%<CR><CR>

" Shortcutting split opening
nnoremap <leader>h :split<Space>
nnoremap <leader>v :vsplit<Space>

" Left folder bar
nnoremap <leader>f :20Lexplore<CR>

"Alias replace all to S
nnoremap S :%s//gI<Left><Left><Left>

" Alias write and quit to Q
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :q!
nnoremap <leader>w :w<CR>

" Save file as sudo when no sudo permissions
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

"Basic settings
set mouse=a
syntax on
set ignorecase
set smartcase
set incsearch
set encoding=utf-8
set number relativenumber
set termguicolors
colorscheme codedark

" Tab Settings
set expandtab
set shiftwidth=3
set softtabstop=3
set tabstop=3

set cursorline

" Autocompletion
set wildmode=longest,list,full

" Fix splitting
set splitbelow splitright

" auto load ft plugins
" normally not needed, but sometimes this is disabled by default
filetype plugin on

source ~/.config/nvim/netrw_config.vim
source ~/.config/nvim/resize.vim
