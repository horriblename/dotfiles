let g:vimwiki_list = [{
         \'path': '~/Documents/',
         \'syntax': 'markdown', 'ext': '.md'
         \}]

" a bit unrelated, detects calcurse notes as markdown filetypes
autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
