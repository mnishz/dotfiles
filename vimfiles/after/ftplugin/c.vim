let b:comment_text = '//'
inoremap <buffer> {<cr> {<cr>}<esc>ko

" check and set tabstop from the file
  let s:save_org_cursor = getcurpos()
  let s:curly_bracket_pos = 0
  let s:first_indent_pos = 0
  let s:found = v:false
  while v:true
    call cursor(s:curly_bracket_pos + 1, 1)
    " limit to 10000 lines
    let s:curly_bracket_pos = search('\v(^\{\n|^\{\s*\/|^[^=]+\{\n)', 'c', 10000)
    if s:curly_bracket_pos == 0 | break | endif
    let s:first_indent_pos = search('\v^ +[^ /]', 'ce', 10000)
    if s:first_indent_pos == 0 | break | endif
    if (s:curly_bracket_pos + 1) == s:first_indent_pos
      let s:found = v:true
      break
    endif
  endwhile
  if s:found
    " tabstop should be col - 1
    let &tabstop = getcurpos()[2] - 1
  endif
  call setpos('.', s:save_org_cursor)
