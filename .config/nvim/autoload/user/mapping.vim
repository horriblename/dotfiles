fu! user#mapping#setup()
  " dummy function
endfu

let mapleader=" "

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
noremap gL g$
noremap gH g^

" surround with parenthesis. Using register "z to not interfere with clipboard
xmap S <Nop>
xnoremap S( "zs()<Esc>"zPgvlOlO<Esc>
xnoremap S) "zs()<Esc>"zPgvlOlO<Esc>
xnoremap S[ "zs[]<Esc>"zPgvlOlO<Esc>
xnoremap S] "zs[]<Esc>"zPgvlOlO<Esc>
xnoremap S{ "zs{}<Esc>"zPgvlOlO<Esc>
xnoremap S} "zs{}<Esc>"zPgvlOlO<Esc>
xnoremap S< "zs<><Esc>"zPgvlOlO<Esc>
xnoremap S> "zs<><Esc>"zPgvlOlO<Esc>
xnoremap S" "zs""<Esc>"zPgvlOlO<Esc>
xnoremap S' "zs''<Esc>"zPgvlOlO<Esc>
xnoremap S` "zs``<Esc>"zPgvlOlO<Esc>
xnoremap S* "zs**<Esc>"zPgvlOlO<Esc>
nnoremap daa "zd%:let @z=@z[1:-2]<cr>"zP

"noremap <F1> <Esc>
noremap! <C-j> <C-n>
noremap! <C-k> <C-p>

silent! nnoremap <leader>h :split<CR>
silent! nnoremap <leader>v :vsplit<CR>

silent! nnoremap <unique> <leader>e :25Lexplore<CR>
silent! nnoremap <unique> <leader>f :find 

nnoremap S :%s##gI<Left><Left><Left>

nnoremap <leader>q :q<CR>
nnoremap <leader>Q :q!
nnoremap <leader>c :bwipeout<CR>
nnoremap <M-c> :bdelete<CR>
inoremap <M-c> <Esc>:bdelete<CR>
nnoremap <M-c> <C-\><C-N>:bdelete<CR>
nnoremap <C-s> :w<CR>

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
nnoremap <M-,>		  :tabnext<CR>
nnoremap <M-.>      :tabprevious<CR>
nnoremap <C-Tab>    :tabnext<CR>
nnoremap <C-S-Tab>  :tabprevious<CR>
inoremap <C-Tab>    <Esc>:tabnext<CR>
inoremap <C-S-Tab>  <Esc>:tabprevious<CR>
inoremap <M-,>      <Esc>:tabnext<CR>
inoremap <M-.>      <Esc>:tabprevious<CR>
tnoremap <C-Tab>    <C-\><C-n>:tabnext<CR>
tnoremap <C-S-Tab>  <C-\><C-n>:tabprevious<CR>
tnoremap <M-,>      <C-\><C-n>:tabnext<CR>
tnoremap <M-.>      <C-\><C-n>:tabprevious<CR>


nnoremap <silent> <leader>u :UndotreeToggle <bar> UndotreeFocus<CR>
