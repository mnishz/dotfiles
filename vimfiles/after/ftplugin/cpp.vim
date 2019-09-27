nnoremap <silent> <buffer> [[ :let @a=@/<cr>?\v^[^ _#/].*(\w+::)*\w+\(<cr>:let @/=@a<cr>
nnoremap <silent> <buffer> ]] :let @a=@/<cr>/\v^[^ _#/].*(\w+::)*\w+\(<cr>:let @/=@a<cr>
nnoremap <silent> <buffer> <leader>tp o<cr>Tracepoint(foo_).<cr>TpEnd();<esc>k0f_a
nnoremap <silent> <buffer> <leader>tv oTpValue().<left><left>
nnoremap <silent> <buffer> <leader>tl ITpLabel("").<left><left><left>

QuickhlManualAdd Tracepoint
