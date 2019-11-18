set shortmess+=S
setlocal noautoindent
setlocal nosmartindent
" nnoremap <buffer> gf $B<c-w>gF
nnoremap <buffer> gf $b"ayeF<bar>wvt:be"by0:new +<c-r>a <c-r>b<cr>
noremap  <buffer> / /\c\v
nnoremap * yiw<bs>/\c\v<c-r>0<cr>
nnoremap <space>* yiw<bs>/\c\v<<c-r>0><cr>
nnoremap <buffer> <space>/ /\c\vnishi<bar>do[ _]exe<bar>dr[ _]cmd<bar>dr[ _]invoke<bar>pipeline<bar>dlb[ _]entry<bar>nexttrack<bar>rw[ _]event<bar>continue[ _]rec<bar>pick[ _]cmd<cr>

nnoremap <Leader>/ :let @/ = @/ .. '\|' .. substitute(@/, '_', ' ', 'g')<cr>

IndentLinesDisable
