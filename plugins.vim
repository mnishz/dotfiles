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

call s:Install('vim-jp/vimdoc-ja')
call s:Install('lyuts/vim-rtags', (has('python') || has('python3')))
" call s:Install('airblade/vim-gitgutter')

call s:Install('mattn/vim-lexiv')
  inoremap <expr> <c-h> lexiv#paren_delete()

call s:Install('mnishz/notes.vim')
call s:Install('mnishz/devotion.vim')
call s:Install('mnishz/colorscheme-preview.vim')

call s:Install('mnishz/rainfall.vim', executable('curl'), 'tenki_jp')
  let g:rainfall#url = 'https://tenki.jp/amedas/3/17/46141.html'

call s:Install('vim-airline/vim-airline')
  let g:airline#extensions#searchcount#enabled = 0
call s:Install('mnishz/current-func-info.vim')
  augroup current-func-info.vim
    autocmd!
    autocmd VimEnter * let g:airline_section_c = airline#section#create(['[%n] %<', 'file', " / %{cfi#format('%s','')} ", 'readonly'])
  augroup END

call s:Install('nightsense/office')
  set termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  augroup colorscheme
    autocmd!
    " Colorscheme イベントの発生が抑制されないよう nested を付ける
    autocmd VimEnter * nested colorscheme office-dark
    if g:help_translation
      " アクティブウィンドウのステータスラインの色を目立たせる
      autocmd ColorScheme * highlight StatusLine ctermfg=100 guifg=SeaGreen
      " Boldをつける
      autocmd ColorScheme * highlight Error gui=Bold guifg=Red
    endif
    " 日本語表示でカーソルを赤くする
    autocmd ColorScheme * highlight CursorIM guibg=Red
    " 微調整
    autocmd ColorScheme * highlight Comment guifg=#676760
    autocmd ColorScheme * highlight SpecialKey guifg=#684f76
    autocmd ColorScheme * highlight DiffText guifg=#557b9e
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
  let g:ctrlp_max_files = 20000
  " <c-m>は使えません！！！enterの挙動も変わってしまう
  nnoremap mru :CtrlPMRUFiles<cr>

call s:Install('scrooloose/nerdtree')
  nnoremap <silent> <c-e> :execute 'NERDTreeToggle ' .. g:GetGitRootPath().path<cr>
  let g:NERDTreeHijackNetrw = 0
  let g:NERDTreeShowBookmarks = 1

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

call s:Install('prabirshrestha/asyncomplete.vim')
call s:Install('prabirshrestha/asyncomplete-lsp.vim')
call s:Install('prabirshrestha/vim-lsp')
  if executable('ccls')
    au User lsp_setup call lsp#register_server({
          \ 'name': 'ccls',
          \ 'cmd': {server_info->['ccls']},
          \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
          \ 'initialization_options': {'cache': {'directory': '/tmp/ccls/cache' }},
          \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
          \ })
  elseif executable('clangd')
    au User lsp_setup call lsp#register_server({
          \ 'name': 'clangd',
          \ 'cmd': {server_info->['clangd']},
          \ 'whitelist': ['c', 'cpp', 'cc'],
          \ })
  elseif executable('cquery')
    au User lsp_setup call lsp#register_server({
          \ 'name': 'cquery',
          \ 'cmd': {server_info->['cquery']},
          \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
          \ 'initialization_options': { 'cacheDirectory': '/tmp/cquery/cache' },
          \ 'whitelist': ['c', 'cpp', 'cc'],
          \ })
  endif
  let g:lsp_diagnostics_echo_cursor = 1

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

if g:vertical_monitor
  let g:etl_digest#split_below = v:true
  let g:etl_digest#window_ratio = 25
endif

let g:etl_digest#highlight = ''
let g:etl_digest#indent_str = '  '

function g:EtlDigestBufCallback(buf) abort
  call setbufvar(a:buf, 'indentLine_enabled', 1)
  call setbufvar(a:buf, '&shiftwidth', 2)
endfunction

let g:etl_digest#buf_callback = 'g:EtlDigestBufCallback'

" modeline
" vim: expandtab tabstop=2 textwidth=0
