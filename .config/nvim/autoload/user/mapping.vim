" vim: foldmethod=marker
fu! user#mapping#setup()
	" dummy function
endfu

let mapleader=" "

" call this function directly to re-setup
fu! user#mapping#resetup()
	" Editor mappings {{{
	xnoremap > >gv
	xnoremap < <gv

	noremap <leader>/ :ToggleLineComments<cr>

	vnoremap <Tab>    >gv
	vnoremap <S-Tab>  <gv

	noremap! <C-BS> <C-w>

	tnoremap <M-C-N> <C-\><C-n>
	tnoremap <M-C-V> <cmd>put "<CR>

	noremap gh ^
	noremap gl g_
	noremap gL g$
	noremap gH g^

	noremap! <C-h> <Left>
	noremap! <C-l> <Right>
	inoremap <C-k> <Up>
	inoremap <C-j> <Down>

	inoremap <C-r><C-k> <C-k>

	nnoremap gV ^v$
	xnoremap ga gg0oG$

	xnoremap X "_x
	vnoremap <C-n> :m '>+1<CR>gv-gv
	vnoremap <C-p> :m '<-2<CR>gv-gv

	" Autoclose
	inoremap <expr> " user#autoclose#InsertSymmetric('"')
	inoremap <expr> ' user#autoclose#InsertSymmetric("'")
	inoremap <expr> ` user#autoclose#InsertSymmetric('`')
	inoremap ( ()<left>
	inoremap [ []<left>
	inoremap { {}<left>
	inoremap {<CR> {<CR>}<ESC>O
	inoremap <expr> ) user#autoclose#CloseRight(")")
	inoremap <expr> ] user#autoclose#CloseRight("]")
	inoremap <expr> } user#autoclose#CloseRight("}")

	nnoremap S :%s##gI<Left><Left><Left>
	" surround with parenthesis. Using register "z to not interfere with clipboard
	xmap s <Nop>
	xnoremap s( "zs()<Esc>"zPgvlOlO<Esc>
	xnoremap s) "zs()<Esc>"zPgvlOlO<Esc>
	xnoremap sb "zs()<Esc>"zPgvlOlO<Esc>
	xnoremap s[ "zs[]<Esc>"zPgvlOlO<Esc>
	xnoremap s] "zs[]<Esc>"zPgvlOlO<Esc>
	xnoremap s{ "zs{}<Esc>"zPgvlOlO<Esc>
	xnoremap s} "zs{}<Esc>"zPgvlOlO<Esc>
	xnoremap sB "zs{}<Esc>"zPgvlOlO<Esc>
	xnoremap s< "zs<><Esc>"zPgvlOlO<Esc>
	xnoremap s> "zs<><Esc>"zPgvlOlO<Esc>
	xnoremap s" "zs""<Esc>"zPgvlOlO<Esc>
	xnoremap s' "zs''<Esc>"zPgvlOlO<Esc>
	xnoremap s` "zs``<Esc>"zPgvlOlO<Esc>
	xnoremap s* "zs**<Esc>"zPgvlOlO<Esc>
	xnoremap s_ "zs__<Esc>"zPgvlOlO<Esc>
	xnoremap se "zs****<Left><Esc>"zPgvllOllO<Esc>
	xnoremap sE "zs******<Left><Left><Esc>"zPgv3lO3lO<Esc>
	xnoremap s<space> "zs<space><space><Esc>"zPgvlOlO<Esc>
	" single line only, `gv` highlights whole thing including surrounding tag
	xnoremap su "zy:let @z='<u>'..@z..'</u>'<cr>gv"zP

	" de-surround
	for char in "(){}[]<>bBt"
		exec 'nnoremap ds'.char ' di'.char.'va'.char.'pgv'
	endfor

	" quotes are single-line only, so this can work
	" using a different keymap as `da'` could delete a whitespace
	for char in "\"`'"
		exec 'nnoremap' 'ds'.char ' di'.char.'vhpgv'
	endfor

	" keyboard layout switching
	nnoremap <leader>y :set langmap=yYzZ\\"§&/()=?`ü+öä#-Ü*ÖÄ'\\;:_;zZyY@#^&*()_+[]\\;'\\\\/{}:\\"\\|\\<\\>?<cr>
	nnoremap <leader>z :set langmap=<cr>

	" quick settings
	nnoremap <leader>zn :set number! relativenumber!<cr>
	nnoremap <leader>z<Tab> :set expandtab! <bar> set expandtab?<cr>
	nnoremap <leader>zw :set wrap! <bar> set wrap?<CR>
	" set transparency - I usually have an autocmd on ColorScheme events to set
	" transparent background, :noau ignores the autocmd (and any other aucmd)
	nnoremap <leader>zb :set bg=dark<CR>
	nnoremap <leader>zB :noau set bg=dark<CR>

	silent! nnoremap <unique> <leader>e :25Lexplore<CR>
	silent! nnoremap <unique> <leader>f :find 

	" quickfix
	nnoremap <C-'><C-n> :cnext<CR>
	nnoremap <C-'><C-p> :cprev<CR>
	nnoremap <C-'><C-'> :copen<CR>

	" toggleterm
	noremap <M-x> :call user#general#ToggleTerm()<cr>
	inoremap <M-x> <Esc>:call user#general#ToggleTerm()<cr>
	tnoremap <M-x> <Cmd>:call user#general#ToggleTerm()<cr>
	" }}}
	" Window Management {{{
	nnoremap <leader>q :q<CR>
	nnoremap <leader>Q :q!
	nnoremap <leader>c :bdelete<CR>
	nnoremap <leader>C :bdelete!<CR>
	nnoremap <M-c> :bdelete<CR>
	inoremap <M-c> <Esc>:bdelete<CR>
	nnoremap <M-c> <C-\><C-N>:bdelete<CR>
	nnoremap <C-s> :w<CR>
	nnoremap g<C-s> :noau w<CR>

	nnoremap <M-C-.>  <C-W>3>
	nnoremap <M-C-,>  <C-W>3<
	nnoremap <M-C-=>  <C-W>3+
	nnoremap <M-C-->  <C-W>3-
	inoremap <M-C-.>  <Esc><C-W>>3i
	inoremap <M-C-,>  <Esc><C-W><3i
	inoremap <M-C-=>  <Cmd>resize 3+<CR>
	inoremap <M-C-->  <Cmd>resize 3-<CR>
	tnoremap <M-C-.>  <C-\><C-n><C-W>3>
	tnoremap <M-C-,>  <C-\><C-n><C-W>3<
	tnoremap <M-C-=>  <C-\><C-n><C-W>3+
	tnoremap <M-C-->  <C-\><C-n><C-W>3-

	nnoremap <leader>r :n#<CR>

	nnoremap <C-/> :nohlsearch<cr>
	nnoremap <C-_> :nohlsearch<cr>

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

	nnoremap <M-n>      :bnext<CR>
	nnoremap <M-p>      :bNext<CR>
	inoremap <M-n>      <Esc>:bnext<CR>
	inoremap <M-p>      <Esc>:bNext<CR>
	tnoremap <M-n>      <C-\><C-n>:bnext<CR>
	tnoremap <M-p>      <C-\><C-n>:bNext<CR>

	nnoremap <leader>t  :tabnew<CR>
	nnoremap <M-.>		  :tabnext<CR>
	nnoremap <M-,>      :tabprevious<CR>
	nnoremap <C-Tab>    :tabnext<CR>
	nnoremap <C-S-Tab>  :tabprevious<CR>
	inoremap <C-Tab>    <Esc>:tabnext<CR>
	inoremap <C-S-Tab>  <Esc>:tabprevious<CR>
	inoremap <M-.>      <Esc>:tabnext<CR>
	inoremap <M-,>      <Esc>:tabprevious<CR>
	tnoremap <C-Tab>    <C-\><C-n>:tabnext<CR>
	tnoremap <C-S-Tab>  <C-\><C-n>:tabprevious<CR>
	tnoremap <M-.>      <C-\><C-n>:tabnext<CR>
	tnoremap <M-,>      <C-\><C-n>:tabprevious<CR>

	for i in range(1,8)
		exec 'noremap <M-' . i . '> :' . i . 'tabnext<CR>'
		exec 'inoremap <M-' . i . '> <Esc>:' . i . 'tabnext<CR>'
		exec 'tnoremap <M-' . i . '> <C-\><C-n>:' . i . 'tabnext<CR>'
	endfor
	noremap <M-9> :$tabnext<CR>

	noremap <M-i> :<c-u>call user#general#GotoNextFloat(1)<cr>
	noremap <M-o> :<c-u>call user#general#GotoNextFloat(0)<cr>

	" }}}

	" Abbreviations {{{
	noreab term_red    \x1b[31m
	noreab term_green  \x1b[32m
	noreab term_orange \x1b[33m
	noreab term_blue   \x1b[34m
	noreab term_mag    \x1b[35m
	noreab term_aqua   \x1b[26m
	noreab term_grey   \x1b[27m
	noreab term_reset  \x1b[0m
	" }}}

	" Plugins
	nnoremap <silent> <leader>u :UndotreeToggle <bar> UndotreeFocus<CR>
endfu

call user#mapping#resetup()
