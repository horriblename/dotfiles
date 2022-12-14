call user#mapping#setup()
call user#general#setup()
" may not exist
silent! call user#local#setup()

if !empty($NVIM)
	call mux#subshell#setup()
endif

augroup ColorTweaks
	au!
	au  ColorScheme badwolf hi Comment guifg=#aaa6a1
	au  ColorScheme gruvbox hi Comment guifg=#a5998d | hi Visual gui=NONE
augroup END

try
    colorscheme gruvbox
catch /^Vim\%((\a\+)\)\=:E185/
endtry
