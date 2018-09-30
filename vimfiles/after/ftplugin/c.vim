let b:comment_text = '//'
inoremap <buffer> {<cr> {<cr>}<esc>ko

" check and set tabstop from the file
function! SetTabstop()
  let l:org_cursor_pos = getcurpos()
  let l:indent_array = [0, 0, 0, 0, 0, 0, 0, 0] " min: 1, max: 8
  let l:MAX_TABSTOP = len(l:indent_array)
  let l:MAX_SEARCH_LINE = 10000
  let l:FINISH_TABSTOP_COUNT = 4
  let l:curly_bracket_pos = 0
  let l:max_count = 0
  while v:true
    call cursor(l:curly_bracket_pos + 1, 1)
    let l:curly_bracket_pos = search('\v(^\{\n|^\{\s*\/)', 'c', l:MAX_SEARCH_LINE)
    if l:curly_bracket_pos == 0 | break | endif
    let l:first_indent_pos = search('\v^ +[^ ]', 'ce', l:MAX_SEARCH_LINE)
    if l:first_indent_pos == 0 | break | endif
    if (l:curly_bracket_pos + 1) == l:first_indent_pos
      " tabstop should be col - 1
      let l:currTabstop = getcurpos()[2] - 1
      if (1 <= l:currTabstop) && (l:currTabstop <= l:MAX_TABSTOP)
        let l:indent_array[l:currTabstop-1] += 1
        let l:max_count = max([l:max_count, l:indent_array[l:currTabstop-1]])
        if l:max_count == l:FINISH_TABSTOP_COUNT
          let &tabstop = l:currTabstop
          break
        endif
      endif
    endif
  endwhile
  call setpos('.', l:org_cursor_pos)
endfunction

call SetTabstop()
