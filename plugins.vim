scriptencoding utf-8

if has('win32')
  const s:plugins_path = "~/vimfiles/pack/plugins/start"
else
  const s:plugins_path = "~/.vim/pack/plugins/start"
endif
if !isdirectory(s:plugins_path) | call mkdir(s:plugins_path, "p") | endif

function s:Install(path, branch = '') abort
  const l:dir = expand(s:plugins_path .. '/' .. substitute(a:path, '/', '_', 'g'))
  if !isdirectory(l:dir)
    echo 'installing ' .. a:path
    if empty(a:branch)
      call system('git clone --depth 1 https://github.com/' .. a:path .. ' ' .. l:dir)
    else
      call system('git clone --depth 1 -b ' .. a:branch .. ' --single-branch https://github.com/' .. a:path .. ' ' .. l:dir)
    endif
  endif
endfunction

call s:Install('vim-jp/vimdoc-ja')
call s:Install('lyuts/vim-rtags')
call s:Install('mattn/vim-lexiv')
" call s:Install('airblade/vim-gitgutter')

call s:Install('mnishz/notes.vim')
call s:Install('mnishz/devotion.vim')
call s:Install('mnishz/colorscheme-preview.vim')
call s:Install('mnishz/rainfall.vim', 'tenki_jp')

call s:Install('vim-airline/vim-airline')
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
  augroup END

call s:Install('Yggdroot/indentLine')
  let g:indentLine_char = '┊'
  let g:indentLine_fileType = ['c', 'cpp', 'ipp', 'hpp', 'hh']

call s:Install('ctrlpvim/ctrlp.vim')
  let g:ctrlp_clear_cache_on_exit = 0
  let g:ctrlp_lazy_update = 1
  let g:ctrlp_root_markers = ['gtags']
  let g:ctrlp_match_window = 'max:30'
  " <c-m>は使えません！！！enterの挙動も変わってしまう
  nnoremap mru :CtrlPMRUFiles<cr>

call s:Install('scrooloose/nerdtree')
  nnoremap <c-e> :NERDTreeToggle<cr>
  let g:NERDTreeHijackNetrw = 0

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
call s:Install('prabirshrestha/async.vim')
call s:Install('prabirshrestha/asyncomplete-lsp.vim')
call s:Install('prabirshrestha/vim-lsp')
  if executable('clangd')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'clangd',
      \ 'cmd': {server_info->['clangd']},
      \ 'whitelist': ['c', 'cpp', 'cc'],
      \ })
  endif
  " if executable('cquery')
  "   au User lsp_setup call lsp#register_server({
  "     \ 'name': 'cquery',
  "     \ 'cmd': {server_info->['cquery']},
  "     \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
  "     \ 'initialization_options': { 'cacheDirectory': '/tmp/cquery/cache' },
  "     \ 'whitelist': ['c', 'cpp', 'cc'],
  "     \ })
  " endif
  let g:lsp_diagnostics_echo_cursor = 1

" modeline
" vim: expandtab tabstop=2 textwidth=0
