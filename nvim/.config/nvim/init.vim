let mapleader=" "

set path-=/usr/include
set path+=**
" Use system clipboard, change to unnamed for vim
if has('nvim')
   set clipboard=unnamedplus
else
   set clipboard=unnamed
endif

fu! s:mapIfEmpty(prefix, lhs, rhs)
   if maparg(a:lhs, a:prefix)
      return
   endif
   execute a:prefix.'map '.a:lhs.' '.a:rhs
endfu

" Remove trailing whitespace on save
"autocmd BufWritePre * %s/\s\+$//e

" Tip: use ctrl-v in command mode followed by key combination to see its
" combination

" Fixing unintuitive keybind behaviour
vnoremap > >gv
vnoremap < <gv

nmap <C-W>>  <C-W>><C-W>
nmap <C-W><  <C-W><<C-W>
nmap <C-W>+  <C-W>+<C-W>
nmap <C-W>-  <C-W>-<C-W>

vnoremap <Tab>    >gv
vnoremap <S-Tab>  <gv

noremap! <C-h> <C-w>
noremap! <C-backspace> <C-w>

tnoremap <M-C-N> <C-\><C-n>
tnoremap <M-C-V> <cmd>put "<CR>

noremap H ^
noremap L g_

" surround with parenthesis. Using register "z to not interfere with clipboard
xmap S <Nop>
xnoremap S( "zs(<c-r>z)<Esc>
xnoremap S) "zs(<c-r>z)<Esc>
xnoremap S[ "zs[<c-r>z]<Esc>
xnoremap S] "zs[<c-r>z]<Esc>
xnoremap S{ "zs{<c-r>z}<Esc>
xnoremap S} "zs{<c-r>z}<Esc>
xnoremap S" "zs"<c-r>z"<Esc>
xnoremap S' "zs'<c-r>z'<Esc>
xnoremap S` "zs`<c-r>z`<Esc>

" neovide/gui frontend fixes and enhancements
nnoremap <M-,>    :tabnext<CR>
nnoremap <M-.>    :tabprevious<CR>
nnoremap <C-Tab>    :tabnext<CR>
nnoremap <C-S-Tab>  :tabprevious<CR>
inoremap <C-Tab>    <Esc>:tabnext<CR>
inoremap <C-S-Tab>  <Esc>:tabprevious<CR>
tnoremap <C-Tab>    <C-\><C-n>:tabnext<CR>
tnoremap <C-S-Tab>  <C-\><C-n>:tabprevious<CR>

noremap <F1> <Esc>
noremap! <C-j> <C-n>

" Shortcutting split opening
call s:mapIfEmpty('nnore', '<leader>h', ':split<CR>')
call s:mapIfEmpty('nnore', '<leader>v', ':vsplit<CR>')

" netrw (explore command)
nnoremap <leader>e :25Lexplore<CR>
call s:mapIfEmpty('nnore', '<silent> <leader>e', ':25Lexplore<CR>')

" file finder
call s:mapIfEmpty('nnore', '<leader>f', ':find ')


"Alias replace all to S
nnoremap S :%s##gI<Left><Left><Left>

nnoremap <leader>q :q<CR>
nnoremap <leader>Q :q!
nnoremap <leader>c :bdelete<CR>
"nnoremap <leader>w :w<CR>
nnoremap <C-s> :w<CR>

" Tab control
nnoremap <c-w>t         :tabnext<CR>
nnoremap <c-w>T         :tabprevious<CR>
nnoremap <c-w><tab>     :tabnext<cr>
nnoremap <c-w><s-tab>   :tabprevious<CR>
nnoremap <leader>t      :tabnew<CR>

" reopen closed file
nnoremap <leader>r :n#<CR>

nnoremap <silent><expr> <leader>n :tabnext<CR>
nnoremap <C-/> :nohlsearch<cr>
nnoremap <C-_> :nohlsearch<cr>

" Buffer navigation
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

nnoremap <silent> <leader>u :UndotreeToggle <bar> UndotreeFocus<CR>

" autocomplete
function! Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction

" inoremap <silent> <Tab>  <C-R>=Tab_Or_Complete()<CR>
" inoremap <silent> <CR>   <C-R>=pumvisible()? "\<lt>C-Y>" : "\<lt>CR>"<CR>

" focus the first floating window found
function! s:GotoFirstFloat() abort
  for w in range(1, winnr('$'))
    let c = nvim_win_get_config(win_getid(w))
    if c.focusable && !empty(c.relative)
      execute w . 'wincmd w'
    endif
  endfor
endfunction

function! s:GotoNextFloat(reverse) abort
   if !has("nvim")
      return
   endif
   let loop_from = 1
   let curr_c = nvim_win_get_config(0)
   if !empty(curr_c.relative)
      let loop_from = winnr() + 1
   endif

   let loop = range(loop_from, winnr('$'))
   if loop_from != 1
      let loop += range(1, loop_from-2)
   endif
   if a:reverse == 1
      let loop = reverse(loop)
   endif

   for w in loop
      let c = nvim_win_get_config(win_getid(w))
      if c.focusable && !empty(c.relative)
         execute w . 'wincmd w'
         execute 'echo w'
         break
      endif
   endfor
endfunction
noremap <a-i> :<c-u>call <sid>GotoNextFloat(1)<cr>
noremap <a-o> :<c-u>call <sid>GotoNextFloat(0)<cr>

function! Zlua(pattern)
   let zlua='~/scripts/z.lua'
   if ! empty($ZLUA_SCRIPT)
      let zlua=$ZLUA_SCRIPT
   endif
   let zlua=expand(zlua)
   if !filereadable(zlua)
      echoerr '~/scripts/z.lua not found'
      return
   endif
   let dir=system(zlua.' -e '.a:pattern)
   if strlen(dir) == 0
      echo 'directory not found'
      return
   endif
   if &ft == "netrw"
      execute "Explore" dir
   elseif &ft == "NvimTree"
      execute "cd" dir
   else
      return dir
   endif
endfun

function! ZluaComp(ArgLead, CmdLine, CursorPos)
   let zlua='~/scripts/z.lua'
   if ! empty($ZLUA_SCRIPT)
      let zlua=$ZLUA_SCRIPT
   endif
   let zlua=expand(zlua)
   if !filereadable(zlua)
      echoerr 'z.lua script not found'
      return
   endif

   return systemlist(zlua.' --complete '.a:ArgLead)
   let l=reverse(systemlist(zlua.' --complete '.a:ArgLead))
   return map(l, {_, val -> substitute(val, "^[^/]*", "", "")})
endfun

command! -bar -nargs=1 -complete=customlist,ZluaComp Z call Zlua(<q-args>)

command! -nargs=1 -complete=command -bar -range L botright new | term <args>
" Save file as sudo when no sudo permissions
command Sudowrite execute 'write ! sudo tee %' <bar> edit!
" CDC = Change to Directory of Current file
command CDC cd %:p:h

augroup term 
   au!
   au BufEnter * if &buftype == 'terminal' | startinsert | endif
augroup END

" Basic settings
set mouse=a
syntax on
set ignorecase
set smartcase
set incsearch
set encoding=utf-8
set autoindent
set linebreak

" Tab Settings
set expandtab
set shiftwidth=3
set softtabstop=3
set tabstop=3

" Appearance
set number relativenumber
set termguicolors
" apply some color changes in case colorscheme is not found (place before
" colorscheme  command)
highlight VertSplit guifg=#c2bfa5 gui=none cterm=reverse
set scrolloff=5
set cursorline
try
    colorscheme monokai
catch /^Vim\%((\a\+)\)\=:E185/
endtry

set laststatus=2 " 2 lines of status bar(bottom) 
set noshowmode

" Autocompletion
"set wildmode=longest,list,full
set wildmode=longest,full
set wildmenu

" keyboard layout switching
nnoremap <leader>y :set langmap=yYzZ\\"§&/()=?`ü+öä#-Ü*ÖÄ'\\;:_;zZyY@#^&*()_+[]\\;'\\\\/{}:\\"\\|\\<\\>?<cr>
nnoremap <leader>z :set langmap=<cr>

" Fix splitting
set splitbelow splitright

" auto load ft plugins (vim compatibility) 
filetype plugin on

let g:markdown_folding = 1

function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction

call SourceIfExists("~/.config/nvim/machine-specific.vim")
