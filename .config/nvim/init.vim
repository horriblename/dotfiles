call user#mapping#setup()
call user#general#setup()

if !empty($NVIM)
	call mux#subshell#setup()
endif

try
    colorscheme badwolf
catch /^Vim\%((\a\+)\)\=:E185/
endtry

augroup ColorTweaks
	au!
	au  ColorScheme badwolf hi! Comment guifg=#aaa6a1
augroup END

function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction

call SourceIfExists("~/.config/nvim/machine-specific.vim")
