call user#mapping#setup()
call user#general#setup()

try
    colorscheme monokai
catch /^Vim\%((\a\+)\)\=:E185/
endtry

call SourceIfExists("~/.config/nvim/machine-specific.vim")
