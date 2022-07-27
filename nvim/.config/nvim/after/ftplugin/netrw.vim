" keybindings
" reference: https://vi.stackexchange.com/questions/22653/explicitly-call-netrw-function-in-binding
" source code: /usr/share/nvim/runtime/autoload/netrw.vim, line 6353 onwards
"
" Note that only <Plug>Functions are 'exported' and usable
" meanwhile variables and functions that start with 's:' are scripts variables
" untouchable from outside
"
" :help netrw-[hotkey] for more info
"
" TODO maybe move all these bindings to netrw_config.vim and use the
" TODO :e was used a few times in place of a proper refresh mechanism, replace them?
" g:Netrw_UserMaps (see :help netrw-usermaps),
" problem is, that method requires writing wrapper functions, which may not
" be any better than just mapping the key binds here

"nmap <buffer> <silent> <nowait> a	<Plug>NetrwHide_a
nmap <buffer> <silent> <nowait> h	<Plug>NetrwBrowseUpDir
"nmap <buffer> <silent> <nowait> <c-l>	<Plug>NetrwRefresh
nmap <buffer> <silent> <nowait> l	<Plug>NetrwLocalBrowseCheck
"nmap <buffer> <silent> <nowait> <c-r>	<Plug>NetrwServerEdit
"nmap <buffer> <silent> <nowait> d	<Plug>NetrwMakeDir
"nmap <buffer> <silent> <nowait> mb	<Plug>NetrwBookHistHandler_gb

"  Binding to functions without <Plug> bindings
nmap <buffer> <silent>  .   :<C-U>call netrw#Call("NetrwHidden", 1)<CR>
" TODO this only works if g:netrw_keepdir=0, replace getcwd with Netrw's own
" functions for safety
nmap <buffer> <silent> r :call netrw#Call("NetrwLocalRename", getcwd())<CR>
" nmap <buffer> <silent> r :call netrw#Call("NetrwLocalRename", netrw#Call('NetrwGetWord'))<CR>
nmap <buffer> <silent> R :<C-U>let g:netrw_sort_direction= (g:netrw_sort_direction =~# 'n')? 'r' : 'n'<bar>e<CR>


"  --------------- "
"  Statusline
"  -------------- "
function! NetrwNumOfMarked()
   let marked=netrw#Expose("netrwmarkfilelist")
   if type(marked) != type([]) || len(marked) == 0
      return ""
   endif

   return ' '.len(marked).' '
endfunction

" Note: an autocommand that triggers on buffer enter
setlocal statusline=%f\ %=
setlocal statusline+=%#netrwMarkFile#
setlocal statusline+=%{NetrwNumOfMarked()}
setlocal statusline+=%#StatusLine#
setlocal statusline+=\ \ %l/%L

"  --------------"
"  navigation
"  --------------"
nnoremap <buffer> <silent> <nowait> gh  <cmd>Explore ~/ <cr>
nnoremap <buffer> <silent> <nowait> gd  <cmd>Explore ~/Documents <cr>
nnoremap <buffer> <silent> <nowait> gD  <cmd>Explore ~/Downloads <cr>
nnoremap <buffer> <silent> <nowait> gp  <cmd>Explore ~/Pictures <cr>
nnoremap <buffer> <silent> <nowait> gm  <cmd>Explore ~/Music <cr>
nnoremap <buffer> <silent> <nowait> gs  <cmd>Explore ~/scripts <cr>
nnoremap <buffer> <silent> <nowait> gn  <cmd>Explore ~/Nextcloud <cr>
nnoremap <buffer> <silent> <nowait> gv  <cmd>exec 'e '.stdpath('config')<cr>

if has('unix')
   nnoremap <buffer> <silent> <nowait> gj  <cmd>Explore ~/jail <cr>
   nnoremap <buffer> <silent> <nowait> gr  <cmd>Explore ~/repo <cr>
   nnoremap <buffer> <silent> <nowait> gc  <cmd>Explore ~/.config <cr>
   nnoremap <buffer> <silent> <nowait> gl  <cmd>Explore ~/.local <cr>

   nnoremap <buffer> <silent> <nowait> g/  <cmd>Explore / <cr>
   nnoremap <buffer> <silent> <nowait> gE  <cmd>Explore /etc <cr>
   nnoremap <buffer> <silent> <nowait> gUU <cmd>Explore /usr <cr>
   nnoremap <buffer> <silent> <nowait> gUs <cmd>Explore /usr/share <cr>
   nnoremap <buffer> <silent> <nowait> gT  <cmd>Explore /tmp <cr>
   nnoremap <buffer> <silent> <nowait> gM  <cmd>Explore /mnt <cr>
   nnoremap <buffer> <silent> <nowait> gV  <cmd>Explore /var <cr>

   nnoremap <buffer> <silent> <nowait> gbb <cmd>Explore /mnt/BUP <cr>
   nnoremap <buffer> <silent> <nowait> gbd <cmd>Explore /mnt/BUP/Documents_ <cr>
   nnoremap <buffer> <silent> <nowait> gba <cmd>Explore /mnt/BUP/apps <cr>

   nnoremap <buffer> <silent> <nowait> gtt <cmd>Explore /mnt/ntdrive <cr>
   nnoremap <buffer> <silent> <nowait> gta <cmd>Explore /mnt/ntdrive/apps <cr>

   nnoremap <buffer> <silent> <nowait> gee <cmd>Explore /mnt/ext <cr>
elseif has('windows')
   nnoremap <buffer> <silent> <nowait> g/ :Explore C:/ <cr>
   nnoremap <buffer> <silent> <nowait> gj :Explore J:/ <cr>
endif
echo "netrw.vim run"
