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
	set tabstop=3
	set shiftwidth=0   " 0 = follow tabstop
	"set softtabstop=3

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
	set fillchars+=diff:╱

	augroup SetListChars
		au!
		au OptionSet expandtab if &expandtab | setl listchars=tab:\ \ →,trail:· | else | set listchars=tab:\ \ ,lead:·,trail:· | endif
		au BufNew * if &expandtab | setl listchars=tab:\ \ →,trail:· | else | set listchars=tab:\ \ ,lead:·,trail:· | endif
	augroup END

	set wildcharm=<Tab>
	set wildmode=longest:full
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
	if has('vim')
		command! Sudowrite write !sudo tee % <bar> edit!
	else " nvim
		command! Sudowrite call s:nvimSudoWrite
	endif
	" CDC = Change to Directory of Current file
	command! CDC cd %:p:h
	" delete augroup
	command! -nargs=1 AugroupDel call user#general#AugroupDel(<q-args>)
	command! -addr=lines ToggleLineComments call user#general#ToggleLineCommentOnRange(<line1>, <line2>)
	command! -nargs=1 -complete=file ShareVia0x0 
				\ call setreg(v:register, \system('curl --silent -F"file=@"'.expand(<q-args>).' https://0x0.st')) |
				\ echo getreg()

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
fu! s:nvimSudoWrite()
	local askpass = tempname()
	call assert_false(writefile([''], askpass, 's'), 'writefile (touch)')
	call assert_true(setfperm(askpass, 'rwx------'), 'setfperm')
	call assert_false(writefile(['#!/bin/bah', 'echo ' .. shellescape(password)], askpass, 's'))

	execute 'silent write !env SUDO_ASKPASS='..shellescape(askpass) 'sudo -A tee % > /dev/null'

	call assert_false(delete(askpass), 'delete')
endfu

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

fu! s:getIndentOfLength(length)
	if &expandtab
		return repeat(' ', a:length)
	endif

	let tabs = a:length / &tabstop
	return repeat("\t", tabs)
endfu

fu! user#general#ToggleLineComment(lnum, indent)
	let comm=&commentstring
	if comm->strpart(0, 2) == '%s' || empty(comm)
		echoerr "commentstring does not have preceding symbol or is empty"
	endif

	let exprs = comm->split("%s")

	let beg_str = exprs[0]
	let end_str = exprs->get(1, "") 
	let beg_re = '\(' . beg_str->trim() . ' \?\)\?'
	let end_re = '\(' . end_str->trim() . '\)\?'
	if a:indent < 0
		let a:indent = indent(a:lnum)
	endif

	let tabs = a:indent / &tabstop
	let indent_re = escape('^((\t| {'.&tabstop.'}){'.tabs.'})', '(){}|')

	let mlist = matchlist(getline(a:lnum), indent_re. beg_re . '\(.*\)' . end_re . '$')

	if len(mlist) == 0
		echo "error matching line " . a:lnum . "with indents " . a:indent
		return
	endif

	let extra_groups = len(mlist) - 10

	let [_, indents, _, cmatch_beg; rest] = mlist 
	let code = rest[0 + extra_groups]
	let trail = rest[2 + extra_groups]

	if !empty(cmatch_beg)
		call setline(a:lnum, indents . code . trail)
	else
		call setline(a:lnum, indents . beg_str . code . end_str . trail)
	endif
endfu

fu! user#general#ToggleLineCommentOnRange(line1, line2)
	let min_ind = indent(a:line1)
	for lnum in range(a:line1, a:line2)
		let min_ind = min([min_ind, indent(lnum)])
	endfor

	for lnum in range(a:line1, a:line2)
		call user#general#ToggleLineComment(lnum, min_ind)
	endfor
endfu

fu! user#general#AugroupDel(group)
	exec 'augroup '.a:group.' | au! | augroup END | augroup! '.a:group
endfu

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
