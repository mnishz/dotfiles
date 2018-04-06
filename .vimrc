set title
set number

let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME

if !has('kaoriya')

  set t_Co=256
  set fileencodings=cp932,ucs-bom,ucs-2le,ucs-2,iso-2022-jp-3,utf-8,euc-jisx0213,euc-jp

else

  " バックアップ用ファイルとundo用ファイルを、元ファイルの場所ではなく一箇所にまとめる。

  let s:bak_path = s:cache_home . "/vim/bak"
  let s:undo_path = s:cache_home . "/vim/undo"

  if !isdirectory(s:bak_path)

    call mkdir(s:bak_path, "p")
  endif

  if !isdirectory(s:undo_path)

    call mkdir(s:undo_path, "p")
  endif

  let &backupdir = s:bak_path
  let &undodir = s:undo_path
endif

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

" https://qiita.com/kawaz/items/ee725f6214f91337b42b
" dein自体の自動インストール
let s:dein_dir = s:cache_home . '/vim/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath
" プラグイン読み込み＆キャッシュ作成
let s:toml_file = fnamemodify(expand('<sfile>'), ':h').'/.dein.toml'
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  call dein#load_toml(s:toml_file)
  call dein#end()
endif
" 不足プラグインの自動インストール
if has('vim_starting') && dein#check_install()
  call dein#install()
endif

" Required:
filetype plugin indent on
syntax enable

"End dein Scripts-------------------------

" (:bro olで表示される)ファイルの履歴を30までに制限する。その他はKaoriyaのデフォルトの設定を残した。
set viminfo='30,<50,s10,h,rA:,rB:

set ignorecase
set smartcase
set nowrapscan
set incsearch
set hlsearch

set tabstop=4
set expandtab
set shiftwidth=4

set autoindent
set smartindent
set cindent

set nowrap
set showmatch
set matchtime=1
set list
set listchars=tab:>-,trail:-
set cursorline

set showcmd
set laststatus=2
set cmdheight=2

set tags=./tags;

set autochdir

" 3行ずつ進む、3行ずつ戻る
nnoremap <c-j> 3<c-e>
nnoremap <c-k> 3<c-y>

" ctrl-tabで次のtabに進む
nnoremap <c-tab> :tabn<cr>
nnoremap <c-s-tab> :tabp<cr>

nnoremap <f12> g<c-]>
" 新規タブでtjumpする
nnoremap <c-f12> :sp<cr><c-w>Tg<c-]>

" 改行
nnoremap <c-enter> o<esc>

" 常にvery magicで検索する
nnoremap / /\v

" 選択範囲を検索する
vnoremap * y/<c-r>0<cr>
