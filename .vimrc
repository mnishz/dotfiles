" 会社での作業用設定
if !exists("g:office_work") | let g:office_work = v:false | endif
if !exists("g:help_translation") | let g:help_translation = v:false | endif

unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

if g:help_translation
  " settings for vimdoc-ja-working
  set fileencoding=utf-8
  set fileformat=unix
  set encoding=utf-8
  let g:autofmt_allow_over_tw = 1
  set formatoptions+=mM
endif

scriptencoding utf-8

" バックアップ用ファイルとundo用ファイルを、元ファイルの場所ではなく一箇所にまとめる。
" swapファイルも追加
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:bak_path = s:cache_home . "/vim/bak"
let s:undo_path = s:cache_home . "/vim/undo"
let s:swap_path = s:cache_home . "/vim/swap"
if !isdirectory(s:bak_path) | call mkdir(s:bak_path, "p") | endif
if !isdirectory(s:undo_path) | call mkdir(s:undo_path, "p") | endif
if !isdirectory(s:swap_path) | call mkdir(s:swap_path, "p") | endif
let &backupdir = s:bak_path . '//'
let &undodir = s:undo_path
let &directory = s:swap_path
set backup
set writebackup
set undofile
set swapfile

if !has('kaoriya')

  set t_Co=256
  colorscheme torte
  set fileencodings=utf-8,cp932,euc-jp,euc-jisx0213,ucs-bom,ucs-2le,ucs-2,iso-2022-jp-3

  " https://qiita.com/mwmsnn/items/0b40662a22162907efae
  " Tera Termでしか動いていない。。。 -> mintty 3.0.2 でも動くようになった
  " 挿入モードに入る時，前回の挿入モードにおける IME の状態を復元する．
  " set t_SI+=[<r
  " 挿入モードを出る時，現在の IME の状態を保存し，IME をオフにする．
  set t_EI+=[<s[<0t
  " Vim 終了時，IME を無効にし，無効にした状態を保存する．
  set t_te+=[<0t[<s
  " ESC キーを押してから挿入モードを出るまでの時間を短くする
  set ttimeoutlen=100
  " inoremap <silent> <esc> <esc>:call system('ibus engine "xkb:jp::jpn"')<cr><c-l>

  if &term =~ "xterm"
      let &t_ti.="\e[1 q"
      let &t_SI.="\e[5 q"
      let &t_EI.="\e[1 q"
      let &t_te.="\e[0 q"
  endif

  filetype on
  filetype plugin on
  filetype indent on

  " (:bro olで表示される)ファイルの履歴を60までに制限する。その他はデフォルトの設定。
  set viminfo='60,<50,s10,h

else

  if g:office_work
    " guessを使いたい、が、会社のファイルはほとんどeuc-jpなので、それより前に持ってくる
    set fileencodings=euc-jp,guess,ucs-bom,ucs-2le,ucs-2,iso-2022-jp-3,utf-8,euc-jisx0213
    " grepの結果を(euc-jpから)shift_jisに(Gtagsの結果についてはgtags.vimで対策)
    set shellpipe=2>\&1\ \|\ nkf32\ -s\ >\ %s
  endif

  " うーん、defaultの設定とどっちがいいか分からん。後で消すかも。。。
  " insert modeを出るときにIMEをoffにする -> 必ずIME offで開始する
  inoremap <silent> <esc> <esc>:set iminsert=0<cr>

  augroup transparency
    autocmd!
    autocmd FocusLost * set transparency=200
    autocmd FocusGained * set transparency=255
  augroup END

  function g:RestoreMouse(timer)
    " 8.1.0011でもっと簡単に調べる方法が入ったけどまだ使えない。
    " if !empty(mapcheck('<leftmouse>', 'n'))
    let l:mapping = maparg('<leftmouse>', 'n', v:false, v:true)
    if has_key(l:mapping, 'rhs') && l:mapping['rhs'] ==? '<nop>'
      unmap <leftmouse>
    endif
    let l:mapping = maparg('<leftmouse>', 'i', v:false, v:true)
    if has_key(l:mapping, 'rhs') && l:mapping['rhs'] ==? '<nop>'
      unmap! <leftmouse>
    endif
  endfunction

  augroup disable_mouse_click
    " 非アクティブの状態での一発目のマウスクリックではカーソルを移動させない
    " FocusGainedだけで処理しようとしても、マウスイベントは既に発生していて手遅れ
    autocmd!
    autocmd FocusLost * noremap <leftmouse> <nop>
    autocmd FocusLost * noremap! <leftmouse> <nop>
    autocmd FocusGained * call timer_start(100, 'g:RestoreMouse')
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
let g:dein#types#git#clone_depth = 1
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

set ignorecase
set smartcase
set nowrapscan
set incsearch
set hlsearch

set grepprg=git\ grep\ --line-number

" 既にファイル内にあるタブ文字を空白何個分で表示するか
set tabstop=4
" tabstopに合わせる
set shiftwidth=0
" bsでshiftwidth分削除する
set smarttab
" タブ文字の代わりに空白を入力する
set expandtab

set autoindent
set smartindent

set nowrap
set showmatch
set matchtime=1
set list
set listchars=tab:>-,trail:-
set cursorline

set showcmd
set cmdheight=2
set laststatus=2
set shortmess-=S

set wildmenu
set wildmode=longest:full,full

set nostartofline

set nrformats-=octal

set path+=**
" この path の設定だと時間がかかりすぎるので include を除外
set complete-=i

set diffopt+=vertical

set clipboard+=unnamed

set helplang=ja

set termwinscroll=100000

augroup WindowLocalOptions
  autocmd!
  autocmd BufWinEnter * set nofoldenable
augroup END

"バイナリ編集(xxd)モード（vim -b での起動、もしくは *.bin ファイルを開くと発動します）
augroup BinaryXXD
  autocmd!
  autocmd BufReadPre  *.bin let &binary =1

  autocmd BufReadPost * if &binary
  autocmd BufReadPost *   silent %!xxd -g 1
  autocmd BufReadPost *   set ft=xxd
  autocmd BufReadPost * endif

  autocmd BufWritePre * if &binary
  autocmd BufWritePre *   %!xxd -r
  autocmd BufWritePre * endif

  autocmd BufWritePost * if &binary
  autocmd BufWritePost *   silent %!xxd -g 1
  autocmd BufWritePost *   set nomod
  autocmd BufWritePost * endif
augroup END

" shell側で対応する？
" git status --short | grep "^ M " | cut -c 4- | xargs -I FILE nkf32 -ex --in-place FILE
if g:office_work
  augroup ConvertEucjp
    autocmd!
    autocmd BufWritePost * if &fileencoding ==# "euc-jp"
    autocmd BufWritePost *   let b:DoConvert = v:true
    autocmd BufWritePost * endif
    " BufUnload -> BufDelete -> BufWipeout
    " Vimを終了したときはBufUnloadしか呼ばれないっぽい？よく分からない
    autocmd BufLeave * if exists("b:DoConvert") && b:DoConvert
"     autocmd BufLeave *   let b:orgAutoRead = &autoread
"     autocmd BufLeave *   setlocal autoread
    autocmd BufLeave *   silent !nkf32 -Eex --in-place %
    autocmd BufLeave *   e
"     autocmd BufLeave *   if b:orgAutoRead == v:false
"     autocmd BufLeave *     setlocal noautoread
"     autocmd BufLeave *   endif
    autocmd BufLeave *   let b:DoConvert = v:false
    autocmd BufLeave * endif
    autocmd BufUnload * if exists("b:DoConvert") && b:DoConvert
    autocmd BufUnload *   !start nkf32 -Eex --in-place %
    autocmd BufUnload *   let b:DoConvert = v:false
    autocmd BufUnload * endif
  augroup END
endif

nnoremap <space>h :tabp<cr>
nnoremap <space>l :tabn<cr>
nnoremap <c-w><space>h <c-w>:tabp<cr>
nnoremap <c-w><space>l <c-w>:tabn<cr>
tnoremap <c-w><space>h <c-w>:tabp<cr>
tnoremap <c-w><space>l <c-w>:tabn<cr>

tnoremap <c-w><c-w> <c-w>.

" 改行、普段使わないので<cr>だけにマップしたいけど、grep結果にも影響あるので要検討
noremap <c-cr> o<esc>

noremap <space>c :tabc<cr>
noremap <c-n> :tabnew<cr>
tnoremap <c-n> <c-w>:tabnew<cr>

" 3行ずつ進む、3行ずつ戻る
noremap <c-j> 3<c-e>
noremap <c-k> 3<c-y>
vnoremap <c-j> 3j
vnoremap <c-k> 3k
" 行末に移動、いまいち'f'や't'の旨みを感じない
noremap ; $
vnoremap ; $h
" 文字列の先頭に移動(すでに先頭であれば1列目に移動)
noremap <silent> 0 :call <SID>GoToFirstColumn()<cr>
vnoremap 0 ^

" 常にvery magicで検索する
noremap  /  /\v
nnoremap /  :set imsearch=0<cr>/\v
nnoremap // :set imsearch=2<cr>/\v
" comment, uncomment
noremap <space><space> :call <SID>ToggleComment()<cr>
" 検索の履歴をたどるときはvery magicをはずす
noremap  /<up> /<up>
nnoremap /<up> :set imsearch=0<cr>/<up>
" *をvery magicで検索するように置き換える、(遠い)次の検索候補に飛んでしまうのが嫌なので<bs>で一個戻ってから検索する
nnoremap * yiw<bs>/\v<c-r>0<cr>
" 単語で検索
nnoremap <space>* yiw<bs>/\v<<c-r>0><cr>
" 検索対象を追加していく
nnoremap <bar> yiw<bs>/<up><bar><c-r>0<cr>
nnoremap <space><bar> yiw<bs>/<up><bar><<c-r>0><cr>
" 選択範囲をそのまま(正規表現を使わずに)検索する
vnoremap * y:let @" = escape(@", '/\')<cr><bs>/\V<c-r>0<cr>
vnoremap <space>* y<bs>/\V\<<c-r>0\><cr>

" 置換("ctrl-r"にしたかったが、"r"系はいろいろと使われているので代わりにOffice系で使われる"ctrl-h"を使う。)
nnoremap <c-h> :%s///g<left><left>
vnoremap <c-h> :s///g<left><left>

" grep
nnoremap <silent> <c-g> :call <SID>DoGrep(v:true)<cr>
nnoremap <silent> g<c-g> :call <SID>DoGrep(v:false)<cr>

nnoremap <expr> } <SID>CurlyBracket("}")
nnoremap <expr> { <SID>CurlyBracket("{")

let @d = '?^@/-l"aye?^---wll"bY:rightbelow vert new b:a'
tnoremap @d N@d

function s:CurlyBracket(text)
  if a:text == "}"
    return &diff ? "]c" : ":cn\<cr>"
  elseif a:text == "{"
    return &diff ? "[c" : ":cp\<cr>"
  else
    " do nothing
  endif
endfunction

" from `:help section`
" nnoremap [[ ?{<CR>w99[{zz
" nnoremap ]] j0?{<CR>w99[{%/{<CR>zz

" 関数っぽいものを検索(ハイライト)
nnoremap <space>/ /\v\w+\(<cr>

" 現在のウィンドウを別タブに移動する
nnoremap <f10> <c-w>T
nnoremap <c-f10> :sp<cr><c-w>T
nnoremap <f11> :Gtags -f %<cr>
nnoremap <c-f11> :vs<cr><c-w>l:GtagsCursor<cr>
nnoremap <s-f11> :sp<cr>:GtagsCursor<cr>
nnoremap <f12> :GtagsCursor<cr>
nnoremap <c-f12> :sp<cr><c-w>T:GtagsCursor<cr>
nnoremap <s-f12> :sp<cr><c-w>T:tabm-<cr>:Gtags -r <c-r><c-w><cr>
" nnoremap <s-f12> :sp<cr><c-w>T:tabm-<cr>:execute("Gtags -r " . cfi#format('%s', '')[0:-3])<cr>

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
" gpは常にレジスタ0を貼り付ける
noremap gp "0p

nnoremap <space>v :tabnew ~/.vimrc<cr>

noremap <c-z> :echo "nop"<cr>

" cnoremap ( ()<left>
" cnoremap { {}<left>
" cnoremap [ []<left>
" cnoremap " ""<left>
" cnoremap ' ''<left>

nnoremap <space>k :call <SID>MoveUpwardDownward(v:true)<cr>
nnoremap <space>j :call <SID>MoveUpwardDownward(v:false)<cr>

noremap! <expr> <c-r>/ <SID>PasteSlash()

" " 自作コマンドサンプル(引数なしならnargsは要らないかも)
" command -nargs=0 MyFunc :call s:MyFunc()
" 
" " ":help expression"とやると幸せになれるかも
" function s:MyFunc()
"   " EXコマンド(ex-cmd-indexもしくはexpression-commands)はそのまま呼び出せる
"     echo "foo"
"     normal gg
"   " 式を評価してくれないもの(変数をそのまま文字列として解釈してしまうもの)についてはexecuteを使う
"     let l:tabNumber = 1
"     " 間違い
"     tabnext l:tabNumber
"     " 正解
"     execute "tabnext " . l:tabNumber
"   " 組み込み関数(functionsもしくはfunction-list)や自作関数を'直接'呼び出すときにはcallを使う
"   " ただしletやechoなど式を評価するものの後ろであればcallは必要ない
"     call feedkeys("gg")
"   " keypressをemulateするにはnormal(EXコマンド)もしくはfeedkeys(関数)を使う
"   " 外部コマンド(シェルコマンド)はsystem
"   " 特殊な表現を文字列に展開したいときはexpand
" endfunction

command FooBarTest :call s:FooBarTest()
function s:FooBarTest(...)
  echo "bar"
  return ""
endfunction

" 現在ファイルの位置に移動するコマンド
" コマンドは将来的に別ファイルにしたほうがいいかも。
" kaoriyaの場合、cmdex.vimにまったく同じものがCdCurrentで定義してある。
" command -nargs=0 Cd :cd %:p:h

command Cd :execute "cd " .. s:GetGitRootPath().path | echo getcwd()
command Lcd :execute "lcd " .. s:GetGitRootPath().path | echo getcwd()
command Tcd :execute "tcd " .. s:GetGitRootPath().path | echo getcwd()

function s:GetGitRootPath(...)
  if a:0 > 1
    echoerr "invalid args"
    return {'found': v:false, 'path': '.'}
  endif

  " current file for no arg
  " let l:targetPath = a:0 == 0 ? escape(expand('%:p:h'), ' ') : a:1
  let l:targetPath = a:0 == 0 ? expand('%:p:h') : a:1
  if l:targetPath[1] == ':' && l:targetPath[2] == '\' && l:targetPath[3] == ''
    " Do nothing, workaround?
  else
    let l:targetPath = l:targetPath . ';'
  endif
  let l:result = finddir('.git', l:targetPath)
  if !empty(l:result)
    " let l:result = fnameescape(fnamemodify(l:result, ':p:h:h'))
    let l:result = fnamemodify(l:result, ':p:h:h')
    return {'found': v:true, 'path': l:result}
  else
    echo 'no root...'
    return {'found': v:false, 'path': '.'}
  endif
endfunction

function s:DoGrep(tabnew)
  let l:warnings = ""
  let l:gitRootOfPwd = s:GetGitRootPath(getcwd())
  if l:gitRootOfPwd.path != s:GetGitRootPath().path
    let l:warnings = l:warnings . "NOT the same repository, "
  endif
  if !l:gitRootOfPwd.found
    let l:warnings = l:warnings . "NOT a git repository, "
  endif
  if l:warnings != ""
    echohl ErrorMsg | echo "Caution: " . l:warnings . "continue... " | echohl None
    let l:c = getchar()
    " やりたいのは == "\<esc>" なんだけど、うまくいかない。直したい。。
    if l:c == 27 | redraw | echo "" | return | endif " もっとうまく消す方法はないものか。。
  endif
  let l:keyHeadStr = ":"
  if a:tabnew
    let l:keyHeadStr = ":tabnew \<bar> "
  endif
  if has('kaoriya')
    let l:keyHeadStr .= "set transparency=200 \<bar> grep -iE"
  else
    let l:keyHeadStr .= "grep -iE"
  endif
  if !l:gitRootOfPwd.found
    let l:keyHeadStr = l:keyHeadStr . " --no-index"
  endif
  call feedkeys(l:keyHeadStr . " \"\" \<bar> cw\<left>\<left>\<left>\<left>\<left>\<left>")
endfunction

command CloseRightTabs :call s:CloseRightTabs()

function s:CloseRightTabs()
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

command Ccl :call s:Ccl()

function s:Ccl()
  let l:orgTabNumber = tabpagenr()
  for currTabNumber in range(1, tabpagenr('$'))
    execute "tabnext " . currTabNumber
    ccl
  endfor
  execute "tabnext " . l:orgTabNumber
endfunction

function s:GoToFirstColumn()
  let l:orgColumn = col(".")
  " 一度'^'で移動
  normal ^
  if l:orgColumn != 1 && l:orgColumn <= col(".")
    " 1列目だったら何もしない('^'でやめる)
    " 先頭より前だったらさらに'0'に移動
    normal! 0
  endif
endfunction

command CGrep :call s:CGrep()

function s:CGrep()
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

command -nargs=1 CGoTo :call s:CGoTo(<f-args>)

function s:GetCurrQuickFixListNumber()
  return getqflist({"nr": 0})["nr"]
endfunction

function s:CGoTo(listNumber)
  if a:listNumber < 1 || a:listNumber > 10 | echo "invalid" | return | endif
  let l:currListNumber = s:GetCurrQuickFixListNumber()
  let l:diff = abs(l:currListNumber - a:listNumber)
  if (l:currListNumber > a:listNumber)
    execute("silent" . l:diff . "colder")
  elseif (l:currListNumber < a:listNumber)
    execute("silent" . l:diff . "cnewer")
  endif
endfunction

function s:ToggleComment() range
  if !exists('b:comment_text') | echoerr 'no b:comment_text' | return | endif
  let l:comment_text = escape(b:comment_text, '/$.*~')
  if getline(a:firstline) =~ '^\s*' . l:comment_text . ' '
    " uncomment with a space
    let l:substitute_text = a:firstline . ',' . a:lastline . 's/\m^\(\s*\)' . l:comment_text . ' \(.*\)/\1\2/g'
  elseif getline(a:firstline) =~ '^\s*' . l:comment_text
    " uncomment with no space
    let l:substitute_text = a:firstline . ',' . a:lastline . 's/\m^\(\s*\)' . l:comment_text . '\(.*\)/\1\2/g'
  else
    " comment out
    let l:substitute_text = a:firstline . ',' . a:lastline . 's/\m\(.*\)/' . l:comment_text . ' \1/g'
  endif
  execute l:substitute_text
endfunction

command ReloadWithEucJp :e ++enc=euc-jp
command Term :vert term ++noclose bash
command TermDot :vert new | lcd ~/dotfiles | term ++noclose ++curwin bash

command -nargs=1 -complete=command Redir :call s:Redir(<f-args>)

function s:Redir(command)
  if has('clipboard')
    " clipboard+=unnamed を使う場合は、" ではなく * からペーストされるのでこっちのほうが都合がいい
    redir @*
  else
    redir @"
  endif
  silent execute a:command
  redir END
endfunction

function s:MoveUpwardDownward(upward)
  let l:searchStr = '^' . getline('.')[:getcurpos()[2]-2] . '\S'
  if a:upward
    call search(l:searchStr, 'bez')
  else
    call search(l:searchStr, 'ez')
  endif
endfunction

function s:PasteSlash() abort
  if @/[0:1] ==? '\v'
    return @/[2:-1]
  else
    return @/
  endif
endfunction

command -nargs=1 -range=% Split :<line1>,<line2>call s:Split(<f-args>)

" Kaoriya gVim doesn't support default parameter yet
" function s:Split(split_count, separator = ', ') range
function s:Split(split_count) range
  let l:separator = ', '
  " you can use "\<TAB>" for separator
  let l:num_lines = a:lastline + 1 - a:firstline
  let l:divisible = (l:num_lines % a:split_count == 0) ? v:true : v:false
  let l:num_loop = l:num_lines / a:split_count
  if !l:divisible | let l:num_loop += 1 | endif
  let l:text = getline(a:firstline, a:lastline)
  let l:new_text = []
  " org
  for i in range(a:split_count)
    let l:new_text += ['']
    for j in range(l:num_loop)
      let l:index = j*a:split_count + i
      if l:index < len(l:text)
        let l:new_text[i] .= l:text[l:index] . l:separator
      endif
    endfor
  endfor
  " reverse
"   for i in range(l:num_loop)
"     let l:new_text += ['']
"     for j in range(a:split_count)
"       let l:index = i*a:split_count+j
"       if l:index < len(l:text)
"         let l:new_text[i] .= l:text[l:index] . l:separator
"       endif
"     endfor
"   endfor
  for i in range(len(l:new_text))
    let l:new_text[i] = l:new_text[i][:-1-len(l:separator)]
  endfor
  call setline(a:firstline, l:new_text)
  call deletebufline('%', a:firstline + len(l:new_text), a:lastline)
endfunction

command WriteSudo :w !sudo tee > /dev/null %
command OwnFile :!sudo chown nishihata %

command UpdateTags :call s:UpdateTags()

function s:UpdateTags() abort
  if has('kaoriya')
    !start ctags -R *
    !start gtags -v
  else
    let l:channel = job_getchannel(job_start('/bin/bash -c "ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --langmap=c++:+.ipp.tpp --extra=+q --exclude=library/*/* --exclude=*[Tt]est/* *"', {'close_cb': function('s:JobCompMessage')}))
    let l:channel = job_getchannel(job_start('/bin/bash -c "gtags"', {'close_cb': function('s:JobCompMessage')}))
  endif
endfunction

function s:JobCompMessage(channel) abort
  call popup_notification('finished', {})
endfunction

let g:rainfall#url = 'https://tenki.jp/amedas/3/17/46141.html'

set secure

" modeline
" vim: expandtab tabstop=2 textwidth=0
