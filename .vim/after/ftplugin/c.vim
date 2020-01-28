let b:comment_text = '//'
" inoremap <buffer> {<cr> {<cr>}<esc>ko

" check and set tabstop and expandtab from the file
function! SetTabRelated()
  let l:org_cursor_pos = getcurpos()
"   let l:indent_array = [0, 0, 0, 0, 0, 0, 0, 0] " min: 1, max: 8
  let l:indent_array = [0, 0, 0, 0] " min: 1, max: 4
  let l:expand_tab = [0, 0] " 0: disabled(tab), 1: enabled(spaces)
  let l:MAX_TABSTOP = len(l:indent_array)
  let l:MAX_SEARCH_LINE = 10000
  let l:ABORT_TABSTOP_COUNT = 4
  let l:curly_bracket_pos = 0
  let l:max_count = 0
  let l:aborted = v:false
  while v:true
    call cursor(l:curly_bracket_pos + 1, 1)
    let l:curly_bracket_pos = search('\v^(\{|[^ \t/].*\{)(\n|\s*\/)', 'c', l:MAX_SEARCH_LINE)
    if l:curly_bracket_pos == 0 | break | endif
    if getline(getcurpos()[1] + 1) =~? '^\t'
      let l:expand_tab[0] += 1
    elseif getline(getcurpos()[1] + 1) =~? '^ '
      let l:expand_tab[1] += 1
    endif
    let l:first_indent_pos = search('\v^ +[^ ]', 'ce', l:MAX_SEARCH_LINE)
    if l:first_indent_pos == 0 | break | endif
    if (l:curly_bracket_pos + 1) == l:first_indent_pos
      " tabstop should be col - 1
      let l:currTabstop = getcurpos()[2] - 1
      if (1 <= l:currTabstop) && (l:currTabstop <= l:MAX_TABSTOP)
        let l:indent_array[l:currTabstop-1] += 1
        let l:max_count = max([l:max_count, l:indent_array[l:currTabstop-1]])
        if l:max_count == l:ABORT_TABSTOP_COUNT
          execute "setlocal tabstop=" . l:currTabstop
          let l:aborted = v:true
          " for debug: echo "found, ts = " . &tabstop . ", line = " . getcurpos()[1]
          break
        endif
      endif
    endif
  endwhile
  if !l:aborted && (l:max_count != 0)
    if l:indent_array[3] == l:max_count
      let &tabstop = 4
    else
      for index in range(l:MAX_TABSTOP)
        if l:indent_array[index] == l:max_count
          execute "setlocal tabstop=" . (index + 1)
          " for debug: echo "not found, ts = " . &tabstop . ", count = " . l:max_count
          break
        endif
      endfor
    endif
  endif
  setlocal expandtab
  if l:expand_tab[0] > l:expand_tab[1] | setlocal noexpandtab | endif
  call setpos('.', l:org_cursor_pos)
endfunction

call SetTabRelated()
