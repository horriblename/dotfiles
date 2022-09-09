let s:mux_zsh="autoload/mux/.zshrc"

fu! mux#setup()
	if !empty(get(g:,'mux_ready',''))
		echom 'Multiplexer already running'
		return
	endif

	set laststatus=2 cmdheight=1
	hi normal guibg=000000

	map	<leader>q :close<CR>

	map	<C-S-T> :tabnew +Term<CR>
	map!	<C-S-T> <Esc>:tabnew +Term<CR>
	tmap	<C-S-T> <C-\><C-N>:tabnew +Term<CR>
	map	<C-S-W> :tabclose<CR>
	map!	<C-S-W> <Esc>:tabclose<CR>
	tmap	<C-S-W> <C-\><C-N>:tabclose<CR>

	map	<C-S-l> :+tabmove<CR>
	map!	<C-S-l> <Esc>:+tabmove<CR>
	tmap	<C-S-l> <C-\><C-N>:+tabmove<CR>
	map	<C-S-h> :-tabmove<CR>
	map!	<C-S-h> <Esc>:-tabmove<CR>
	tmap	<C-S-h> <C-\><C-N>:-tabmove<CR>

	map	<C-S-9> :vnew +Term<CR>
	map!	<C-S-9> <Esc>:vnew +Term<CR>
	tmap	<C-S-9> <C-\><C-N>:vnew +Term<CR>
	map	<C-S-0> :new +Term<CR>
	map!	<C-S-0> <Esc>:new +Term<CR>
	tmap	<C-S-0> <C-\><C-N>:new +Term<CR>

	tmap	<C-S-V> <C-\><C-N>pi
	xmap	<C-S-C> y

	"call setenv('EDITOR', 'nvim --server '.v:servername.' --remote')
	if match(&shell, 'zsh$') > -1
		let zshrc=nvim_get_runtime_file(s:mux_zsh, 0)[0]
		" wrapper to hook precmd in zsh to change vim ':file' name
		" and also maybe hook changing dir to notify vim
		"exec 'command! Term term export ORIG_ZDOTDIR="$ZDOTDIR" ZDOTDIR='.zshrc.'; exec zsh -i'
		command! Term term
	else
		command! Term term
	endif


	hi! TabLine ctermbg=000000 ctermfg=Grey guibg=000000 guifg=DarkGrey
	hi! link TabLineFill TabLine
	hi TabLineSel ctermfg=Yellow guifg=#fabd2f

	"augroup TerminalMux
	"	au!
	"	au TermOpen * setlocal nohidden
	"augroup END

	Term

	let g:mux_ready=1
	let g:mux_pending_close={}
endfu


fu! mux#serverOpen(files)
	if type(files) == type("")
		edit files
	elseif type(files) == type([]) && !empty(files)

	else
		echomsg "mux#serverOpen() received invalid argument"
	endif
endfu

fu! mux#remote()
	call s:remote(argv(-1))
endfu


fu! s:remote(files)
	let sock=getenv('NVIM_PARENT')
	if empty(sock)
		echoerr "No nested session detected!"
		return
	endif

	let chan=sockconnect('pipe', $NVIM_PARENT)

	"call rpcrequest(chan, 'mux#serverOpen', files)
	echo 'trying rpc..'
	echo rpcrequest(chan, 'luaeval', 'vim.notify("hihihi")')

	call chanclose(chan)
	quit!
endfu

fu! mux#setTitle(pid, cmd)
	echom a:pid
	echom a:cmd
	echom luaeval("require 'mux'.SetTermTitle(nil, _A[1], _A[2])", [a:pid, a:cmd])
endfu

