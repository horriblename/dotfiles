"disable submode timeouts:
let g:submode_timeout = 0
" don't consume submode-leaving key
let g:submode_keep_leaving_key = 1

call submode#enter_with('grow/shrink', 'n', '', '<C-w>+', '<C-w>+')
call submode#enter_with('grow/shrink', 'n', '', '<C-w>-', '<C-w>-')
call submode#enter_with('grow/shrink', 'n', '', '<C-w><', '<C-w><')
call submode#enter_with('grow/shrink', 'n', '', '<C-w>>', '<C-w>>')
call submode#map('grow/shrink', 'n', '', '-', '<C-w>-')
call submode#map('grow/shrink', 'n', '', '+', '<C-w>+')
call submode#map('grow/shrink', 'n', '', '>', '<C-w><')
call submode#map('grow/shrink', 'n', '', '<', '<C-w>>')
" '=' acts as '+' in "grow/shrink" submode
call submode#map('grow/shrink', 'n', '', '=', '<C-w>+')

call submode#enter_with('tab-switch', 'n', '', '<C-w><C-h>', '<C-w>h')
call submode#enter_with('tab-switch', 'n', '', '<C-w><C-j>', '<C-w>j')
call submode#enter_with('tab-switch', 'n', '', '<C-w><C-k>', '<C-w>k')
call submode#enter_with('tab-switch', 'n', '', '<C-w><C-l>', '<C-w>l')
call submode#map('tab-switch', 'n', '', '<C-h>', '<C-w>h')
call submode#map('tab-switch', 'n', '', '<C-j>', '<C-w>j')
call submode#map('tab-switch', 'n', '', '<C-k>', '<C-w>k')
call submode#map('tab-switch', 'n', '', '<C-l>', '<C-w>l')
