set title
set number

let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME

if !has('kaoriya')

  set t_Co=256
  colorscheme default
  set fileencodings=cp932,ucs-bom,ucs-2le,ucs-2,iso-2022-jp-3,utf-8,euc-jisx0213,euc-jp

  " https://qiita.com/mwmsnn/items/0b40662a22162907efae
  " 挿入モードに入る時，前回の挿入モードにおける IME の状態を復元する．
  " Tera Termでしか動いていない。。。
  set t_SI+=[<r
  " 挿入モードを出る時，現在の IME の状態を保存し，IME をオフにする．
  set t_EI+=[<s[<0t
  " Vim 終了時，IME を無効にし，無効にした状態を保存する．
  set t_te+=[<0t[<s
  " ESC キーを押してから挿入モードを出るまでの時間を短くする
  set timeoutlen=100

else

  " guessを使いたい、が、それより前にeuc-jpを持ってくる
  set fileencodings=euc-jp,guess,ucs-bom,ucs-2le,ucs-2,iso-2022-jp-3,utf-8,euc-jisx0213

  " バックアップ用ファイルとundo用ファイルを、元ファイルの場所ではなく一箇所にまとめる。
  " swapファイルも追加

  let s:bak_path = s:cache_home . "/vim/bak"
  let s:undo_path = s:cache_home . "/vim/undo"
  let s:swap_path = s:cache_home . "/vim/swap"

  if !isdirectory(s:bak_path)

    call mkdir(s:bak_path, "p")
  endif

  if !isdirectory(s:undo_path)

    call mkdir(s:undo_path, "p")
  endif

  if !isdirectory(s:swap_path)

    call mkdir(s:swap_path, "p")
  endif

  let &backupdir = s:bak_path
  let &undodir = s:undo_path
  let &directory = s:swap_path

  " うーん、defaultの設定とどっちがいいか分からん。後で消すかも。。。
  " insert modeに入る/出るときにIMEをoffにする
  " imsearchはiminsertと同じ挙動にする -> -1で同じ挙動になると書いてあるがならない。1で期待通りの動きをするのでこれでよしとする。
  set imsearch=1
  inoremap <esc> <esc>:set iminsert=0<cr>
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
let s:dein_dir = s:cache_home . '/dein'
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
" ctrlpのほうが便利そうなのでそちらを使うことにした。
" set viminfo='30,<50,s10,h,rA:,rB:

set ignorecase
set smartcase
set nowrapscan
set incsearch
set hlsearch

set grepprg=grep\ -n

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
set cmdheight=2
set laststatus=2

set wildmenu
set wildmode=longest,full

" コメントでの自動改行を抑止
set textwidth=0

" set tags=./tags;

" 代わりに(:Cd)を使うことにした。
" set autochdir

" リモート環境では<ctrl + 特殊キー>はほとんど動かない
" ここから ----------------------------------------
  " ctrl-tabで次のtabに進む
  nnoremap <c-tab> :tabn<cr>
  nnoremap <c-s-tab> :tabp<cr>
  " ctrl-+/ctrl--でtabを隣に移動
  nnoremap <c-kPlus> :tabm+<cr>
  nnoremap <c-kMinus> :tabm-<cr>

  " 改行
  nnoremap <c-cr> o<esc>
" ここまで ----------------------------------------

" 3行ずつ進む、3行ずつ戻る
nnoremap <c-j> 3<c-e>
nnoremap <c-k> 3<c-y>

" 常にvery magicで検索する
nnoremap / /\v

" 置換("ctrl-r"にしたかったが、"r"系はいろいろと使われているので代わりにOffice系で使われる"ctrl-h"を使う。)
nnoremap <c-h> :%s/\vGtagsCursor

" grep
nnoremap <c-g> :tabnew <bar> grep -irE "" * <bar> cw<left><left><left><left><left><left><left><left>

" セクション(メソッド)間移動がうまく動かないケースがあるので、簡易的なメソッド間移動方法を定義
" nnoremap [[ ?\v::\w+\([^\)]*\)[^\{]*\n{0,1}\{<cr>
" nnoremap ]] /\v::\w+\([^\)]*\)[^\{]*\n{0,1}\{<cr>

" gtags関連、ctagsはお役御免
" nnoremap ctags :!ctags -R *<cr>
" nnoremap <f12> g<c-]>
" " 新規タブでtjumpする
" nnoremap <c-f12> :sp<cr><c-w>Tg<c-]>
nnoremap gtags :silent !gtags -v<cr>
nnoremap <f11> :Gtags -f %<cr>
nnoremap <f12> :GtagsCursor<cr>
nnoremap <c-f12> :sp<cr><c-w>T:GtagsCursor<cr>

" 行末までヤンク
nnoremap Y y$
" 行末に貼り付け
nnoremap P A<c-r><c-"><esc>

" ノーマルモードでのWindowsクリップボードへの単語コピー
nnoremap <c-insert> viw"*y

" cnだけ登録しておく、cpは今のところなし
nnoremap <c-n> :cn<cr>

" 選択範囲を検索する
vnoremap * y/<c-r>0<cr>

" 現在ファイルの位置に移動するコマンド
" コマンドは将来的に別ファイルにしたほうがいいかも。
" kaoriyaの場合、cmdex.vimにまったく同じものがCdCurrentで定義してある。
command! -nargs=0 Cd cd %:p:h
