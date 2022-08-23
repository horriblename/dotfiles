call user#mapping#setup()
call user#general#setup()

call SourceIfExists("~/.config/nvim/machine-specific.vim")
