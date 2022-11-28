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

	vnoremap <Tab>    >gv
	vnoremap <S-Tab>  <gv

	noremap! <C-BS> <C-w>

	tnoremap <M-C-N> <C-\><C-n>
	tnoremap <M-C-V> <cmd>put "<CR>

	noremap H ^
	noremap L g_
	noremap gL g$
	noremap gH g^

	inoremap <C-l> <Right>
	inoremap <C-j> <Down>
	inoremap <C-k> <Up>
	inoremap <C-h> <Left>

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
	xmap S <Nop>
	xnoremap S( "zs()<Esc>"zPgvlOlO<Esc>
	xnoremap S) "zs()<Esc>"zPgvlOlO<Esc>
	xnoremap Sb "zs()<Esc>"zPgvlOlO<Esc>
	xnoremap S[ "zs[]<Esc>"zPgvlOlO<Esc>
	xnoremap S] "zs[]<Esc>"zPgvlOlO<Esc>
	xnoremap S{ "zs{}<Esc>"zPgvlOlO<Esc>
	xnoremap S} "zs{}<Esc>"zPgvlOlO<Esc>
	xnoremap SB "zs{}<Esc>"zPgvlOlO<Esc>
	xnoremap S< "zs<><Esc>"zPgvlOlO<Esc>
	xnoremap S> "zs<><Esc>"zPgvlOlO<Esc>
	xnoremap S" "zs""<Esc>"zPgvlOlO<Esc>
	xnoremap S' "zs''<Esc>"zPgvlOlO<Esc>
	xnoremap S` "zs``<Esc>"zPgvlOlO<Esc>
	xnoremap S* "zs**<Esc>"zPgvlOlO<Esc>
	xnoremap S_ "zs__<Esc>"zPgvlOlO<Esc>
	xnoremap Se "zs****<Left><Esc>"zPgvllOllO<Esc>
	xnoremap SE "zs******<Left><Left><Esc>"zPgv3lO3lO<Esc>
	xnoremap S<space> "zs<space><space><Esc>"zPgvlOlO<Esc>
	" single line only, `gv` highlights whole thing including surrounding tag
	xnoremap Su "zy:let @z='<u>'..@z..'</u>'<cr>gv"zP

	" de-surround
	for char in '(){}[]<>bBt"`' . "'"
		exec 'nnoremap ds'.char ' di'.char.'va'.char.'pgv'
	endfor

	" keyboard layout switching
	nnoremap <leader>y :set langmap=yYzZ\\"§&/()=?`ü+öä#-Ü*ÖÄ'\\;:_;zZyY@#^&*()_+[]\\;'\\\\/{}:\\"\\|\\<\\>?<cr>
	nnoremap <leader>z :set langmap=<cr>

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
	nnoremap <leader>c :bwipeout<CR>
	nnoremap <leader>C :bwipeout!<CR>
	nnoremap <M-c> :bdelete<CR>
	inoremap <M-c> <Esc>:bdelete<CR>
	nnoremap <M-c> <C-\><C-N>:bdelete<CR>
	nnoremap <C-s> :w<CR>

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

	" Cmd Win binding
	augroup CmdWinMap
		au!
		au CmdwinEnter * nnoremap <buffer> <Esc> <cmd>:q<cr>
	augroup END

	" Plugins
	nnoremap <silent> <leader>u :UndotreeToggle <bar> UndotreeFocus<CR>
endfu

call user#mapping#resetup()
