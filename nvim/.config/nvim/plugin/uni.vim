command! -range UnicodeName
			\  let s:save = @a
			\| if <count> is# -1
			\|   let @a = strcharpart(strpart(getline('.'), col('.') - 1), 0, 1)
			\| else
			\|   exe 'normal! gv"ay'
			\| endif
			\| echo system('uni -c i', @a)[:-2]
			\| let @a = s:save
			\| unlet s:save

nmap <c-,> :UnicodeName<CR>
imap <c-,> <cmd>UnicodeName<CR>


" Simpler version which works on the current character only:
" command! UnicodeName echo
"         \ system('uni -c i', [strcharpart(strpart(getline('.'), col('.') - 1), 0, 1)])[:-2]

" Vim9Script version:
" command -range UnicodeName {
"     | var save = @a
"     | if <count> == -1  | @a = strcharpart(strpart(getline('.'), col('.') - 1), 0, 1)
"     | else              | exe 'normal! gv"ay' | endif
"     | echo system('uni -c i', @a)[: -2]
"     | @a = save
"     | }
