nnoremap <silent> <buffer> [[ :let @a=@/<cr>?\v^[^ _#/].*(\w+::)*\w+\(<cr>:let @/=@a<cr>
nnoremap <silent> <buffer> ]] :let @a=@/<cr>/\v^[^ _#/].*(\w+::)*\w+\(<cr>:let @/=@a<cr>

QuickhlManualAdd Tracepoint
