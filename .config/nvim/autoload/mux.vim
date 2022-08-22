
fu! mux#setup()
	if !empty(get(g:,'mux_ready',''))
		echom 'Multiplexer already running'
		return
	endif

	set laststatus=0 cmdheight=1
	hi normal guibg=000000 

	map	<leader>q :close<CR>

	map	<C-S-T> :tabnew +term<CR> 
	map!	<C-S-T> <Esc>:tabnew +term<CR> 
	tmap	<C-S-T> <C-\><C-N>:tabnew +term<CR> 
	map	<C-S-W> :tabclose<CR> 
	map!	<C-S-W> <Esc>:tabclose<CR> 
	tmap	<C-S-W> <C-\><C-N>:tabclose<CR> 

	map	<C-S-l> :+tabmove<CR> 
	map!	<C-S-l> <Esc>:+tabmove<CR> 
	tmap	<C-S-l> <C-\><C-N>:+tabmove<CR> 
	map	<C-S-l> :-tabmove<CR> 
	map!	<C-S-l> <Esc>:-tabmove<CR> 
	tmap	<C-S-l> <C-\><C-N>:-tabmove<CR> 

	map	<C-S-9> :vnew +term<CR> 
	map!	<C-S-9> <Esc>:vnew +term<CR> 
	tmap	<C-S-9> <C-\><C-N>:vnew +term<CR> 
	map	<C-S-0> :new +term<CR> 
	map!	<C-S-0> <Esc>:new +term<CR> 
	tmap	<C-S-0> <C-\><C-N>:new +term<CR> 

	tmap	<C-S-V> <C-\><C-N>pi 
	xmap	<C-S-C> y 

	"call setenv('EDITOR', 'nvim --server '.v:servername.' --remote')
	call setenv('NVIM_PARENT', v:servername)

	hi! TabLine ctermbg=000000 ctermfg=Grey guibg=000000 guifg=DarkGrey
	hi! link TabLineFill TabLine
	hi TabLineSel ctermfg=Yellow guifg=#fabd2f

	"augroup TerminalMux
	"	au!
	"	au TermOpen * setlocal nohidden
	"augroup END

	term

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
