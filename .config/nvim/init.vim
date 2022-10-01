call user#mapping#setup()
call user#general#setup()

try
    colorscheme badwolf
catch /^Vim\%((\a\+)\)\=:E185/
endtry

function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction

call SourceIfExists("~/.config/nvim/machine-specific.vim")
