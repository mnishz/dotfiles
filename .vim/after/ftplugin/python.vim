let b:comment_text = '#'
nnoremap <silent> <buffer> [[ :let @a=@/<cr>?\v(^\|\W)def <cr>:let @/=@a<cr>
