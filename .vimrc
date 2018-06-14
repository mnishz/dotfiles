" 会社での作業用設定
let g:for_office_work = v:true

let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME

if !g:for_office_work
  " for vimdoc-ja-working
  " let autofmt_allow_over_tw=1
  set fileencoding=utf-8
  set fileformat=unix
  set encoding=utf-8
endif

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
  set ttimeoutlen=100

else

  if g:for_office_work
    " guessを使いたい、が、それより前にeuc-jpを持ってくる
    set fileencodings=euc-jp,guess,ucs-bom,ucs-2le,ucs-2,iso-2022-jp-3,utf-8,euc-jisx0213
    " grepの結果をeuc-jp -> shift_jisに(Gtagsの結果についてはgtags.vimで対策)
    set shellpipe=2>\&1\ \|\ nkf32\ -Es\ >\ %s
  endif

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
  inoremap <silent> <esc> <esc>:set iminsert=0<cr>

  augroup transparency
    autocmd!
    autocmd FocusGained * set transparency=255
    autocmd FocusLost * set transparency=200
  augroup END

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

set title titlestring=%F
set number

" (:bro olで表示される)ファイルの履歴を30までに制限する。その他はKaoriyaのデフォルトの設定を残した。
" ctrlpのほうが便利そうなのでそちらを使うことにした。
" set viminfo='30,<50,s10,h,rA:,rB:

set ignorecase
set smartcase
set nowrapscan
set incsearch
set hlsearch

" set grepprg=grep\ -n
set grepprg=git\ grep\ --line-number

set tabstop=4
set expandtab

if g:for_office_work
  set shiftwidth=2
else
  set shiftwidth=4
endif

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
set wildmode=longest:full,full

set nostartofline

hi Ignore ctermfg=red

if g:for_office_work
  " コメントでの自動改行を抑止
  set textwidth=0
endif

" set tags=./tags;

" 代わりに(:Cd)を使うことにした。
" set autochdir

" リモート環境では<ctrl + 特殊キー>はほとんど動かない
if !has('kaoriya')
  noremap <tab> :tabn<cr>
  noremap <a-right> :tabn<cr>
  noremap <a-left> :tabp<cr>
else
  " ctrl-tabで次のtabに進む
  noremap <c-tab> :tabn<cr>
  noremap <c-s-tab> :tabp<cr>
  inoremap <c-tab> <esc>:tabn<cr>
  inoremap <c-s-tab> <esc>:tabp<cr>
  " ctrl-+/ctrl--でtabを隣に移動
  noremap <c-kPlus> :tabm+<cr>
  noremap <c-kMinus> :tabm-<cr>
  " 改行
  noremap <c-cr> o<esc>
endif

noremap <c-f4> :tabc<cr>
noremap <space>c :tabc<cr>
noremap <c-n> :tabnew<cr>

" 3行ずつ進む、3行ずつ戻る
noremap <c-j> 3<c-e>
noremap <c-k> 3<c-y>
vnoremap <c-j> 3j
vnoremap <c-k> 3k
" 行末に移動、いまいち'f'や't'の旨みを感じない
noremap ; $
vnoremap ; $h
" 文字列の先頭に移動(すでに先頭であれば1列目に移動)
noremap <silent> 0 :call GoToFirstColumn()<cr>
vnoremap 0 ^

" 常にvery magicで検索する
noremap / /\v
" 検索の履歴をたどるときはvery magicをはずす
noremap /<up> /<up>
" *をvery magicで検索するように置き換える、(遠い)次の検索候補に飛んでしまうのが嫌なので<bs>で一個戻ってから検索する
nnoremap * yiw<bs>/\v<c-r>0<cr>
" 単語で検索
nnoremap <space>* yiw<bs>/\v<<c-r>0><cr>
" 検索対象を追加していく
nnoremap <bar> yiw<bs>/<up><bar><c-r>0<cr>
nnoremap <space><bar> yiw<bs>/<up><bar><<c-r>0><cr>
" 選択範囲をそのまま(正規表現を使わずに)検索する
vnoremap * y<bs>/\V<c-r>0<cr>
vnoremap <space>* y<bs>/\V\<<c-r>0\><cr>

" 置換("ctrl-r"にしたかったが、"r"系はいろいろと使われているので代わりにOffice系で使われる"ctrl-h"を使う。)
nnoremap <c-h> :%s/\v//gc<left><left><left><left>

" grep
nnoremap <c-g> :tabnew <bar> set transparency=200 <bar> grep -iE "" <bar> cw<left><left><left><left><left><left>
" ctrl + shiftは使えない。。
" nnoremap <c-s-g> :tabnew <bar> grep -iE --no-index "" <bar> cw<left><left><left><left><left><left>
nnoremap } :cn<cr>
nnoremap { :cp<cr>

if g:for_office_work
  " セクション(メソッド)間移動がうまく動かないケースがあるので、簡易的なメソッド間移動方法を定義
  " nnoremap [[ ?\v::\w+\([^\)]*\)[^\{]*\n{0,1}\{<cr>
  " nnoremap ]] /\v::\w+\([^\)]*\)[^\{]*\n{0,1}\{<cr>

  nnoremap <space><space> A // nishi 
  " 関数っぽいものを検索(ハイライト)
  nnoremap <space>/ /\v\w+\(<cr>
endif

" gtags関連、ctagsはお役御免
" nnoremap ctags :!start ctags -R *<cr>
" nnoremap <f12> g<c-]>
" " 新規タブでtjumpする
" nnoremap <c-f12> :sp<cr><c-w>Tg<c-]>
nnoremap gtags :!start gtags -v<cr>
nnoremap <f11> :Gtags -f %<cr>
nnoremap <f12> :GtagsCursor<cr>
nnoremap <c-f12> :sp<cr><c-w>T:GtagsCursor<cr>
nnoremap <s-f12> :sp<cr><c-w>T:tabm-<cr>:Gtags -r <c-r><c-w><cr>
nnoremap <c-f11> :vs<cr><c-w>l:GtagsCursor<cr>
nnoremap <s-f11> :sp<cr>:GtagsCursor<cr>

" 現在のウィンドウを別タブに移動する
nnoremap <f10> <c-w>T
nnoremap <c-f10> :sp<cr><c-w>T

noremap <a-h> <c-w>h
noremap <a-j> <c-w>j
noremap <a-k> <c-w>k
noremap <a-l> <c-w>l
inoremap <a-h> <esc><c-w>h
inoremap <a-j> <esc><c-w>j
inoremap <a-k> <esc><c-w>k
inoremap <a-l> <esc><c-w>l

" 行末までヤンク
nnoremap Y y$
" ノーマルモードでのWindowsクリップボードへの単語コピー
nnoremap <c-insert> viw"*y
" 毎度レジスタを指定するのが面倒なので、a, b, cだけヤンクとペーストを割り当てておく
nnoremap <space>ya "ayiw
nnoremap <space>yb "byiw
nnoremap <space>yc "cyiw
nnoremap <space>pa "ap
nnoremap <space>pb "bp
nnoremap <space>pc "cp

noremap <c-z> :echo "nop"<cr>

" うっかり改行してしまったときにインデントをすべて消す
" <c-o>だとundoがおかしくなる
inoremap <silent> <bs> <c-r>=BsForInsertMode()<cr>

" " 自作コマンドサンプル(引数なしならnargsは要らないかも)
" command! -nargs=0 MyFunc call s:MyFunc()
" 
" " ":help expression"とやると幸せになれるかも
" function! s:MyFunc()
"   " EXコマンド(ex-cmd-indexもしくはexpression-commands)はそのまま呼び出せる
"     echo "foo"
"     normal gg
"   " 式を評価してくれないもの(変数をそのまま文字列として解釈してしまうもの)についてはexecuteを使う
"     let l:tabNumber = 1
"     " 間違い
"     tabnext l:tabNumber
"     " 正解
"     execute "tabnext " . l:tabNumber
"   " 組み込み関数(functions)や自作関数を'直接'呼び出すときにはcallを使う
"   " ただしletやechoなど式を評価するものの後ろであればcallは必要ない
"     call feedkeys("gg")
"   " keypressをemulateするにはnormal(EXコマンド)もしくはfeedkeys(関数)を使う
"   " 外部コマンド(シェルコマンド)はsystem
"   " 特殊な表現を文字列に展開したいときはexpand
" endfunction

command! FooBarTest call s:FooBarTest()
function! s:FooBarTest()
  if getline(".") =~ '^{.*$'
    echo "foo"
  else
    echo "bar"
  endif
endfunction

" 現在ファイルの位置に移動するコマンド
" コマンドは将来的に別ファイルにしたほうがいいかも。
" kaoriyaの場合、cmdex.vimにまったく同じものがCdCurrentで定義してある。
" command! -nargs=0 Cd cd %:p:h
command! Cd call s:CdToGitRoot()

function! s:CdToGitRoot()
  let l:orgPath = getcwd()
  cd %:p:h
  while v:true
    " echo getcwd()
    let l:result = finddir(".git")
    if empty(l:result)
      let l:currPath = getcwd()
      cd ..
      if l:currPath == getcwd()
        " これ以上上に行けなければやめて、元のpathに戻す
        echo "no root..."
        execute "cd " . l:orgPath
        break
      endif
    else
      echo getcwd()
      break
    endif
  endwhile
endfunction

command! -nargs=0 CloseRightTabs call s:CloseRightTabs()

function! s:CloseRightTabs()
  " 自分自身は閉じないので"+1"
  let l:firstTabNumberToClose = tabpagenr() + 1
  let l:totalTabCount = tabpagenr('$')
  " 後ろから順に閉じていく
  " 前からだとtab numberが常に更新されるため同じtab numberを閉じ続ける必要があり、
  " そうするとエラーが起きたときだけ閉じるtab numberをincrementしなければならず処理が面倒
  " 未保存の変更などで閉じることができなかった場合、そのtabたちだけが残る
  for currTabNumber in range(l:firstTabNumberToClose, l:totalTabCount)
    " ややこしい。。。
    let l:tabNumberToClose = l:totalTabCount - (currTabNumber - l:firstTabNumberToClose)
    execute "tabclose " . l:tabNumberToClose
  endfor
  echo "done!"
endfunction

command! -nargs=0 Ccl call s:Ccl()

function! s:Ccl()
  let l:orgTabNumber = tabpagenr()
  for currTabNumber in range(1, tabpagenr('$'))
    execute "tabnext " . currTabNumber
    ccl
  endfor
  execute "tabnext " . l:orgTabNumber
endfunction

function! g:GoToFirstColumn()
  let l:orgColumn = col(".")
  " 一度'^'で移動
  normal ^
  if l:orgColumn != 1 && l:orgColumn <= col(".")
    " 1列目だったら何もしない('^'でやめる)
    " 先頭より前だったらさらに'0'に移動
    normal! 0
  endif
endfunction

command! GoBackToGrep call s:GoBackToGrep()

function! s:GoBackToGrep()
  let l:found = v:false
  while v:true
    let l:currList = getqflist({'all': 1})
    if stridx(l:currList["title"], "grep") > 0 | let l:found = v:true | endif
    if l:found || l:currList["nr"] <= 1
      break
    else
      silent colder
    endif
  endwhile
  if l:found | echo "found" | else | echo "not found" | endif
endfunction

command! -nargs=1 CGoTo call s:CGoTo(<f-args>)

function! s:GetCurrQuickFixListNumber()
  return getqflist({"nr": 0})["nr"]
endfunction

function! s:CGoTo(listNumber)
  if a:listNumber < 1 || a:listNumber > 10 | echo "invalid" | return | endif
  let l:currListNumber = s:GetCurrQuickFixListNumber()
  let l:diff = abs(l:currListNumber - a:listNumber)
  if (l:currListNumber > a:listNumber)
    execute("silent" . l:diff . "colder")
  elseif (l:currListNumber < a:listNumber)
    execute("silent" . l:diff . "cnewer")
  endif
endfunction

function! g:BsForInsertMode()
  if getline(".") =~ '^ \+$'
    return "\<c-u>" " インデントのみの場合はすべて消す
  else
    return "\<c-h>" " それ以外の場合は1文字消す
  endif
endfunction

command! ReloadWithEucJp e ++enc=euc-jp
