" vim: foldmethod=marker
" Putting this in autoload to allow for more fine-grained control over execution sequence,
" This is especially useful for sourcing these configs before lunarvim
" To 'source' this config:
"   :call user#general#setup()

" Putting this in autoload has the side effect of avoiding overwriting lunarvim's configs
" on reload, since this file will only be sourced once

" dummy function
fu! user#general#setup()
endfu

" call this function directly to re-setup
fu! user#general#resetup()
	" General Options
	" {{{
	set mouse=a
	set mousemodel=extend
	syntax on
	set ignorecase
	set smartcase
	set incsearch
	set encoding=utf-8
	set autoindent
	set linebreak
	set spelllang=en,de

	" Tab Settings
	set noexpandtab
	set shiftwidth=3
	set softtabstop=3
	set tabstop=3

	" Appearance
	set number relativenumber
	set termguicolors
	set scrolloff=5
	set cursorline
	set lazyredraw
	set cmdheight=1
	set noshowmode
	set splitbelow splitright
	set matchpairs+=<:>,*:*,`:`
	set list listchars=tab:\ \ ,trail:·

	augroup SetListChars
		au!
		au OptionSet expandtab if &expandtab | setl listchars=tab:\ \ →,trail:· | else | set listchars=tab:\ \ ,lead:·,trail:· | endif
	augroup END

	set wildcharm=<Tab>
	set wildmode=longest,full
	set wildmenu

	set cmdwinheight=4

	set path-=/usr/include
	set path+=**
	" Use system clipboard, change to unnamed for vim
	if has('nvim')
		set clipboard=unnamedplus
	else
		set clipboard=unnamed
	endif
	" }}}

	command! -bar -nargs=1 -complete=customlist,ZluaComp Z call Zlua(<q-args>)

	" Save file as sudo when no sudo permissions
	command Sudowrite execute 'write ! sudo tee %' <bar> edit!
	" CDC = Change to Directory of Current file
	command CDC cd %:p:h

	if has('nvim') && (!has('lua') || luaeval('not lvim'))
		augroup TerminalTweaks
			au!
			au TermOpen * setlocal nolist nonumber norelativenumber statusline=%{b:term_title}
			au TermOpen * let b:term_title=substitute(b:term_title,'.*:','',1) | startinsert
			au BufEnter,BufWinEnter,WinEnter term://* if nvim_win_get_cursor(0)[0] > line('$') - nvim_win_get_height(0) | startinsert | endif
		augroup END

		au TextYankPost * silent! lua vim.highlight.on_yank()
		lua vim.unload_module = function (mod) package.loaded[mod] = nil end
	endif

	" auto load ft plugins (vim compatibility) 
	filetype plugin on

	let g:markdown_folding = 1
endfu

" function definitions {{{
" focus the first floating window found
fu! user#general#GotoFirstFloat() abort
  for w in range(1, winnr('$'))
	 let c = nvim_win_get_config(win_getid(w))
	 if c.focusable && !empty(c.relative)
		execute w . 'wincmd w'
	 endif
  endfor
endfu

fu! user#general#GotoNextFloat(reverse) abort
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
	if a:reverse
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

fu! Zlua(pattern)
	let zlua='z.lua'
	if ! empty($ZLUA_SCRIPT)
		let zlua=$ZLUA_SCRIPT
	endif
	let dir=system([zlua, '-e', a:pattern])
	if strlen(dir) == 0
		echoerr 'z.lua: directory not found'
		return
	endif
	if &ft == "netrw"
		execute "Explore ".dir
	else
		execute "cd ".dir
	endif
endfun

fu! ZluaComp(ArgLead, CmdLine, CursorPos)
	let zlua='z.lua'
	if ! empty($ZLUA_SCRIPT)
		let zlua=$ZLUA_SCRIPT
	endif

	return systemlist([zlua, '--complete', a:ArgLead])
endfun

if has('nvim')
	fu! user#general#ToggleTerm()
		let buf=bufnr('^term://*#toggleterm#')
		" buffer doesn't exist
		if buf == -1
			let h=min([&lines/2, 15])
			exec 'botright ' . h .'new'
			" this probably won't work with non posix-like shells
			exec 'e term://' . &shell . ';\#toggleterm\#'
			return
		endif

		let win=bufwinnr(buf)

		" window exists
		if win != -1
			exec 'close ' . win
			return
		endif

		" buf exists but window does not
		let h=min([&lines/2, 15])
		exec 'botright ' . h .'new'
		exec 'buf ' . buf
	endfu
else " TODO vim version
	fu! user#general#ToggleTerm()
		term
	endfu
endif
" }}}

call user#general#resetup()
