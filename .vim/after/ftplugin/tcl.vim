let b:comment_text = '#'
nnoremap <silent> <buffer> [[ :let @a=@/<cr>?proc <cr>:let @/=@a<cr>
