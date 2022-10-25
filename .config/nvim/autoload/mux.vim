let s:mux_zsh="autoload/mux/.zshrc"

fu! mux#setup()
	set laststatus=2 cmdheight=1

	command! Term term
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

	set tabline=%!v:lua.require'mux.tabline'.tabline()

	Term
endfu
