setl tabstop=4
setl shiftwidth=3
setl softtabstop=3
setl expandtab

" move line to beginning of next/prev section
nmap <leader>md dd]]p
nmap <leader>mu dd[[p
xmap <leader>md d]]p
xmap <leader>mu d[[p

inoremap ``` ```<cr>```<up><Esc>A
inoremap $$<cr> $$<cr>$$<Esc>O
