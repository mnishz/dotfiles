set shortmess+=S
setlocal noautoindent
setlocal nosmartindent
" nnoremap <buffer> gf $B<c-w>gF
nnoremap <buffer> gf $b"ayeF<bar>wvt:be"by0:new +<c-r>a <c-r>b<cr>
noremap  <buffer> / /\c\v
nnoremap <buffer> * yiw<bs>/\c\v<c-r>0<cr>
nnoremap <buffer> <space>* yiw<bs>/\c\v<<c-r>0><cr>
nnoremap <buffer> <space>/ /\c\vnishi<bar>do[ _]exe<bar>dr[ _]cmd<bar>dr[ _]invoke<bar>pipeline<bar>dlb[ _]entry<bar>nexttrack<bar>rw[ _]event<bar>continue[ _]rec<bar>pick[ _]cmd<cr>

nnoremap <Leader>/ :let @/ = @/ .. '\|' .. substitute(@/, '_', ' ', 'g')<cr>

IndentLinesDisable

command-buffer -nargs=1 EtlGrep :call s:grep(<f-args>)

let s:grep_job = 0
let s:grep_aborted = 0

function s:handler(ch, msg) abort
  if s:grep_aborted && ch_status(a:ch) == 'closed'
    let s:grep_aborted = 0
  else
    caddexpr a:msg .. ch_status(a:ch)
    cwindow
  endif
endfunction

function s:grep(text) abort
  if !empty(s:grep_job) && job_status(s:grep_job) == 'run'
    call job_stop(s:grep_job)
    let s:grep_aborted = 1
  endif
  call setqflist([])
  let s:grep_job = job_start(['grep', '-nHie', a:text, expand('%')], {'out_cb': function('s:handler')})
endfunction
