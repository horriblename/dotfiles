
fu! mux#setup()
	if !empty(get(g:,'mux_ready',''))
		echom 'Multiplexer already running'
		return
	endif

	set laststatus=0
	set cmdheight=1
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

	call setenv('EDITOR', 'nvim --server '.v:servername.' --remote')

	hi! TabLine ctermbg=000000 ctermfg=Grey guibg=000000 guifg=DarkGrey
	hi! link TabLineFill TabLine
	hi TabLineSel ctermfg=Yellow guifg=#fabd2f

	"augroup TerminalMux
	"	au!
	"	au TermOpen * setlocal nohidden
	"augroup END

	term

	let g:mux_ready=1
endfu
