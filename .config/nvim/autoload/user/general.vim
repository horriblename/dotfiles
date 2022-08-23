" Putting this in autoload to allow for more fine-grained control over execution sequence,
" This is especially useful for sourcing these configs before lunarvim
" To 'source' this config:
"   :call user#general#setup()

" Putting this in autoload has the side effect of avoiding overwriting lunarvim's configs
" on reload, since this file will only be sourced once

" dummy function
fu! user#general#setup()
endfu

set path-=/usr/include
set path+=**
" Use system clipboard, change to unnamed for vim
if has('nvim')
   set clipboard=unnamedplus
else
   set clipboard=unnamed
endif

" Remove trailing whitespace on save
"autocmd BufWritePre * %s/\s\+$//e

fu! SmartNewWin()
	let l:whratio=4
	let l:wininfo=getwininfo(win_getid())[0]
	let l:h=get(l:wininfo,"height",0)
	let l:w=get(l:wininfo,"width",0)
	echo l:w l:h
	if l:w >= l:whratio * l:h
		vnew
	else
		new
	endif
endfu

silent! nnoremap <leader>n :call SmartNewWin()<CR>

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

" Save file as sudo when no sudo permissions
command Sudowrite execute 'write ! sudo tee %' <bar> edit!
" CDC = Change to Directory of Current file
command CDC cd %:p:h

if has('nvim')
	augroup TerminalTweaks
		au!
		au TermOpen * setlocal listchars= nonumber norelativenumber statusline=%{b:term_title}
		au TermOpen * let b:term_title=substitute(b:term_title,'.*/','',1) | startinsert
		au BufEnter,BufWinEnter,WinEnter term://* startinsert
	augroup END
endif

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
set noexpandtab
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

set lazyredraw
set cmdheight=2
set noshowmode
set matchpairs+=<:>,*:*,`:`
set list listchars=tab:\ \ ,trail:·

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
