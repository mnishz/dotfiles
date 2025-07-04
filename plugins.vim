scriptencoding utf-8

" TODO
" * update function -> done
" * disable function -> done
" * have a list of plugins -> needed?

if has('win32')
  const s:plugins_path = expand("~/vimfiles/pack/plugins/start/")
else
  const s:plugins_path = expand("~/.vim/pack/plugins/start/")
endif
if !isdirectory(s:plugins_path) | call mkdir(s:plugins_path, "p") | endif

function s:Install(path, condition = v:true, branch = '') abort
  if !a:condition | return | endif
  const l:dir = expand(s:plugins_path .. substitute(a:path, '/', '_', 'g'))
  if !isdirectory(l:dir)
    echo 'installing ' .. a:path
    if empty(a:branch)
      call system('git clone --depth 1 https://github.com/' .. a:path .. ' ' .. l:dir)
    else
      call system('git clone --depth 1 -b ' .. a:branch .. ' --single-branch https://github.com/' .. a:path .. ' ' .. l:dir)
    endif
  endif
  if isdirectory(l:dir .. '/doc') | execute 'helptag' l:dir .. '/doc' | endif
endfunction

call s:Install('airblade/vim-gitgutter')
  let g:gitgutter_max_signs = 500
call s:Install('vim-jp/vimdoc-ja')

call s:Install('mattn/vim-lexiv')
  inoremap <expr> <c-h> lexiv#paren_delete()

call s:Install('mnishz/notes.vim')
call s:Install('mnishz/devotion.vim')
call s:Install('mnishz/colorscheme-preview.vim')

" call s:Install('mnishz/rainfall.vim', executable('curl'), 'tenki_jp')
"   let g:rainfall#url = 'https://tenki.jp/amedas/3/17/46141.html'

call s:Install('vim-airline/vim-airline')
  let g:airline#extensions#searchcount#enabled = 0
call s:Install('mnishz/current-func-info.vim')
  " Python で遅いのでとりあえず disable にしておく
  let g:loaded_cfi_ftplugin_python = v:true
  augroup current-func-info.vim
    autocmd!
    autocmd VimEnter * let g:airline_section_c = airline#section#create(['[%n] %<', 'file', " / %{cfi#format('%s','')} / %{coc#status()}", 'readonly'])
  augroup END

call s:Install('nightsense/office')
  set termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  augroup colorscheme
    autocmd!
    " Colorscheme イベントの発生が抑制されないよう nested を付ける
    autocmd VimEnter * nested colorscheme office-dark
    " 日本語表示でカーソルを赤くする
    autocmd ColorScheme * highlight CursorIM guibg=Red
    " 微調整
    autocmd ColorScheme * highlight Comment guifg=#676760
    autocmd ColorScheme * highlight SpecialKey guifg=#684f76
    autocmd ColorScheme * highlight DiffText guifg=#557b9e
    autocmd ColorScheme * highlight CursorLine guibg=#404040
  augroup END

call s:Install('Yggdroot/indentLine')
  let g:indentLine_char = '┊'
  let g:indentLine_fileType = ['c', 'cpp', 'ipp', 'hpp', 'hh', 'python', 'tcl']

call s:Install('ctrlpvim/ctrlp.vim')
  let g:ctrlp_clear_cache_on_exit = 0
  let g:ctrlp_lazy_update = 1
  let g:ctrlp_root_markers = ['gtags']
  let g:ctrlp_match_window = 'max:30'
  let g:ctrlp_custom_ignore = #{dir: '\v(library[\/][^\/]+[\/][^\/]+|generated)$'}
  let g:ctrlp_max_files = 30000
  let g:ctrlp_switch_buffer = 'E'
  let g:ctrlp_regexp = 1
  " <c-m>は使えません！！！enterの挙動も変わってしまう
  nnoremap mru :CtrlPMRUFiles<cr>

call s:Install('scrooloose/nerdtree')
  nnoremap <silent> <c-e> :execute 'NERDTreeToggle ' .. g:GetGitRootPath().path<cr>
  let g:NERDTreeHijackNetrw = 0
  let g:NERDTreeShowBookmarks = 1
call s:Install('mattn/vim-molder')
call s:Install('mattn/vim-molder-operations')

call s:Install('t9md/vim-quickhl')
  nmap <Space>m <Plug>(quickhl-manual-this)
  xmap <Space>m <Plug>(quickhl-manual-this)
  nmap <Space>w <Plug>(quickhl-manual-this-whole-word)
  nmap <Space>M <Plug>(quickhl-manual-reset)
  xmap <Space>M <Plug>(quickhl-manual-reset)
  nmap <Space>L :QuickhlManualList<cr>

call s:Install('rhysd/clever-f.vim')
  let g:clever_f_mark_cursor = 0

call s:Install('previm/previm')
  if has('win32')
    let g:previm_open_cmd = 'C:\\Program\ Files\\Mozilla\ Firefox\\firefox.exe'
  endif
  let g:previm_enable_realtime = 1
  let g:previm_custom_css_path = '~/dotfiles/previm_my.css'

" LSP として別途 ccls を入れる必要がある
call s:Install('m-pilia/vim-ccls')
  let g:ccls_orientation = 'horizontal'
  let g:ccls_size = 10
" coc.nvim には Node.js が必要
if executable('node')
  call s:Install('neoclide/coc.nvim')
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr :call CocAction('jumpReferences')<cr>:sleep 10m<cr><c-w>J<c-w>p:cc<cr>
  nmap <silent> gc :call CocAction('showIncomingCalls')<cr>
  let g:coc_disable_transparent_cursor = 1
endif

call s:Install('vim-python/python-syntax')
  let g:python_highlight_all = 1

command PlugUpdate :call s:PlugUpdate()
function s:PlugUpdate() abort
  for dir in readdir(s:plugins_path, {n -> isdirectory(s:plugins_path .. n)})
    echo 'updating ' .. dir
    call system('cd ' .. s:plugins_path .. dir .. ' && git pull')
  endfor
endfunction

command PlugDeleteAll :call s:PlugDeleteAll()
function s:PlugDeleteAll() abort
  for dir in readdir(s:plugins_path, {n -> isdirectory(s:plugins_path .. n)})
    echon 'deleting ' .. dir .. ', '
    if !empty(system('cd ' .. s:plugins_path .. dir .. ' && git status --porcelain'))
      echohl Error | echon 'not clean, aborted' | echohl None
    else
      echon 'done'
      call delete(s:plugins_path .. dir, "rf")
    endif
    echo ''
  endfor
endfunction

if filereadable(expand('~/dotfiles/plugins_local.vim'))
  source ~/dotfiles/plugins_local.vim
endif

" modeline
" vim: expandtab tabstop=2 textwidth=0
