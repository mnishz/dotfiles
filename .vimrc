" 会社での作業用設定
if !exists("g:office_work") | let g:office_work = v:false | endif
if !exists("g:help_translation") | let g:help_translation = v:false | endif

unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

let g:loaded_matchparen = 1

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

" 変数じゃなくて関数にすればサイズが変わっても対応できる。けどそこまでする必要ある？
let g:is_vertical_monitor = ((&columns / &lines) < 2) ? v:true : v:false
let g:new_vnew = g:is_vertical_monitor ? 'new' : 'vnew'

if !has('win32')

  colorscheme torte
  " set fileencodings=utf-8,cp932,euc-jp,euc-jisx0213,ucs-bom,ucs-2le,ucs-2,iso-2022-jp-3

  " https://qiita.com/m_nish/items/f6e5f875c2d0954a6630
  " 挿入モードを出る時，IME をオフにする．
  if empty($GNOME_TERMINAL_SCREEN) && &term =~ 'xterm'
    if empty($TMUX)
      let &t_EI .= "\e[<0t"
    else
      let &t_EI .= "\ePtmux;\e\e[<0t\e\\"
      " ESC キーを押してから挿入モードを出るまでの時間を短くする -> defaults.vim で設定
      set ttimeoutlen=50
    endif
  endif

  " inoremap <silent> <esc> <esc>:call system('ibus engine "xkb:jp::jpn"')<cr><c-l>

  if &term =~ 'xterm'
    " インサートモードでのカーソル切り替え
    let &t_ti .= "\e[1 q"
    let &t_SI .= "\e[5 q"
    let &t_EI .= "\e[1 q"
    let &t_te .= "\e[0 q"

    set ttymouse=sgr
  endif

  " (:bro olで表示される)ファイルの履歴を60までに制限する。その他はデフォルトの設定。
  " set viminfo='60,<50,s10,h
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

  function g:RestoreMouse(timer) abort
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

set title titlestring=%F
set number

set ignorecase
set smartcase
set nowrapscan
set incsearch
set hlsearch

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
set listchars=tab:>-,trail:␣
set cursorline

au TerminalOpen * if &buftype == 'terminal' | setlocal nolist | endif

set showcmd
set cmdheight=3
set cmdwinheight=15
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

if has('win32')
  set clipboard+=unnamed
endif

set helplang=ja

set history=10000
set termwinscroll=100000

augroup FORMATOPTIONS
  autocmd!
  autocmd FileType * setlocal formatoptions-=ro
augroup END

augroup WindowLocalOptions
  autocmd!
  autocmd BufWinEnter * set nofoldenable
augroup END

"バイナリ編集(xxd)モード（vim -b での起動、もしくは *.bin ファイルを開くと発動します）
augroup BinaryXXD
  autocmd!
  autocmd BufReadPre  *.bin setlocal binary

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

nnoremap zl zL
nnoremap zh zH

" 常にvery magicで検索する
noremap  /  /\v
nnoremap /  :set imsearch=0<cr>/\v
nnoremap // :set imsearch=2<cr>/\v
" comment, uncomment
noremap <space><space> :call <SID>ToggleComment()<cr>
" folding a block
nnoremap <space>- <s-v>$%kojzf
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

function s:CurlyBracket(text) abort
  if &diff
    return a:text == "}" ? "]c" : "[c"
  elseif getloclist(0, {'winid' : 0}).winid != 0
    return a:text == "}" ? ":lne\<cr>" : ":lp\<cr>"
  else
    " assume it quickfix
    return a:text == "}" ? ":cn\<cr>" : ":cp\<cr>"
  endif
endfunction

" from `:help section`
" nnoremap [[ ?{<CR>w99[{zz
" nnoremap ]] j0?{<CR>w99[{%/{<CR>zz

" 関数っぽいものを検索(ハイライト)
nnoremap <space>/ /\v\w+\ze\(<cr>

set <xF4>=[1;*S
set <F4>=OS
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
" gpは常にレジスタ0を貼り付ける
noremap gp "0p

nnoremap <space>v :tabnew ~/.vimrc<cr>

noremap <c-z> :echo "nop"<cr>

cnoremap <c-p> <up>

nnoremap <space>k :call <SID>MoveUpwardDownward(v:true)<cr>
nnoremap <space>j :call <SID>MoveUpwardDownward(v:false)<cr>
nnoremap <space>p :call popup_clear()<cr>
nnoremap <space>s :setlocal invspell spelllang=en_us<cr>

" よく打ち間違えるので。。。<c-@> は多分使わない。
inoremap <c-@> <c-[>

noremap! <expr> <c-r>/ <SID>PasteSlash()

" " 自作コマンドサンプル(引数なしならnargsは要らないかも)
" command -nargs=0 MyFunc call s:MyFunc()
" 
" " ":help expression"とやると幸せになれるかも
" function s:MyFunc() abort
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

command FooBarTest call s:FooBarTest()
function s:FooBarTest(...) abort
  echo "bar"
  return ""
endfunction

" 現在ファイルの位置に移動するコマンド
" コマンドは将来的に別ファイルにしたほうがいいかも。
" kaoriyaの場合、cmdex.vimにまったく同じものがCdCurrentで定義してある。
" command -nargs=0 Cd cd %:p:h

command Cd execute "cd " .. g:GetGitRootPath().path | echo getcwd()
command Lcd execute "lcd " .. g:GetGitRootPath().path | echo getcwd()
command Tcd execute "tcd " .. g:GetGitRootPath().path | echo getcwd()

function g:GetGitRootPath(...) abort
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
    let l:result = findfile('.git', l:targetPath)
    if !empty(l:result)
      let l:result = fnamemodify(l:result, ':p:h')
      return {'found': v:true, 'path': l:result}
    else
      echo 'no root...'
      return {'found': v:false, 'path': '.'}
    endif
  endif
endfunction

if empty(getftype('.git'))
  let &grepprg = 'grep -nr --exclude=tags --exclude-dir=.svn'
else
  let &grepprg = 'git grep --line-number'
endif

function s:DoGrep(tabnew) abort
  let l:warnings = ""
  let l:gitRootOfPwd = g:GetGitRootPath(getcwd())
  if l:gitRootOfPwd.path != g:GetGitRootPath().path
    let l:warnings = l:warnings . "NOT the same repository, "
  endif
  if !l:gitRootOfPwd.found
    let l:warnings = l:warnings . "NOT a git repository, "
    let &grepprg = 'grep -nr --exclude=tags --exclude-dir=.svn'
  else
    let &grepprg = 'git grep --line-number'
  endif
  if l:warnings != ""
    echohl ErrorMsg | echo "Caution: " . l:warnings . "continue..." | echohl None | echo ""
  endif
  let l:keyHeadStr = ":"
  if a:tabnew
    let l:keyHeadStr = ":tabnew \<bar> "
  endif
  if has('win32')
    let l:keyHeadStr .= "set transparency=200 \<bar> grep -iEI"
  else
    let l:keyHeadStr .= "grep -iEI"
  endif
  let l:keyTailStr = "\<bar> botright cw"
  let l:leftKeyCount = 15
"   if !l:gitRootOfPwd.found
"     let l:keyHeadStr = l:keyHeadStr . " --no-index"
"     let l:keyTailStr = "-- \":!.svn/\" " . l:keyTailStr
"     let l:leftKeyCount += 13
"   endif
  call feedkeys(l:keyHeadStr . " \"\" " . l:keyTailStr)
  for i in range(l:leftKeyCount)
      call feedkeys("\<left>")
  endfor
endfunction

command CloseRightTabs call s:CloseRightTabs()

function s:CloseRightTabs() abort
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

command Ccl call s:Ccl()

function s:Ccl() abort
  let l:orgTabNumber = tabpagenr()
  for currTabNumber in range(1, tabpagenr('$'))
    execute "tabnext " . currTabNumber
    ccl
  endfor
  execute "tabnext " . l:orgTabNumber
endfunction

function s:GoToFirstColumn() abort
  let l:orgColumn = col(".")
  " 一度'^'で移動
  normal ^
  if l:orgColumn != 1 && l:orgColumn <= col(".")
    " 1列目だったら何もしない('^'でやめる)
    " 先頭より前だったらさらに'0'に移動
    normal! 0
  endif
endfunction

command CGrep call s:CGrep()

function s:CGrep() abort
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

command -nargs=1 CGoTo call s:CGoTo(<f-args>)

function s:GetCurrQuickFixListNumber() abort
  return getqflist({"nr": 0})["nr"]
endfunction

function s:CGoTo(listNumber) abort
  if a:listNumber < 1 || a:listNumber > 10 | echo "invalid" | return | endif
  let l:currListNumber = s:GetCurrQuickFixListNumber()
  let l:diff = abs(l:currListNumber - a:listNumber)
  if (l:currListNumber > a:listNumber)
    execute("silent" . l:diff . "colder")
  elseif (l:currListNumber < a:listNumber)
    execute("silent" . l:diff . "cnewer")
  endif
endfunction

function s:ToggleComment() range abort
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

command ReloadWithEucJp e ++enc=euc-jp
command Term vert term ++noclose bash
command TermDot vert new | lcd ~/dotfiles | term ++noclose ++curwin bash

command -nargs=1 -complete=command Redir call s:Redir(<f-args>)

function s:Redir(command) abort
  if &clipboard =~# 'unnamed'
    " clipboard+=unnamed を使う場合は、" ではなく * からペーストされるのでこっちのほうが都合がいい
    redir @*
  else
    redir @"
  endif
  silent execute a:command
  redir END
endfunction

function s:MoveUpwardDownward(upward) abort
  let l:searchStr = '^' . getline('.')[:getcurpos()[2]-2] . '\S'
  if a:upward
    call search(l:searchStr, 'bez')
  else
    call search(l:searchStr, 'ez')
  endif
endfunction

function s:PasteSlash() abort
  let l:i = 0
  while @/[l:i:l:i+1] =~? '^\\\w'
    let l:i += 2
  endwhile
  return @/[l:i:]
endfunction

command -nargs=1 -range=% Split <line1>,<line2>call s:Split(<f-args>)

" Kaoriya gVim doesn't support default parameter yet
" function s:Split(split_count, separator = ', ') range abort
function s:Split(split_count) range abort
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

command WriteSudo call s:WriteSudo()
command OwnFile !sudo chown $USER:$USER %

function s:WriteSudo() abort
  w !sudo tee > /dev/null %
  e!
endfunction

let s:TEMP_TAGS = 'tags_'

function s:IsRepository() abort
  return (!empty(getftype(getcwd() .. '/.git')) || !empty(getftype(getcwd() .. '/.svn')))
endfunction

command CreateTags if s:IsRepository() | call system('touch tags') | call system('rm -f ' .. s:TEMP_TAGS) | call s:UpdateTags(v:true) | else | echo 'not repository' | endif

augroup TAGS
  autocmd!
  autocmd BufRead * call s:UpdateTagsIfNeeded()
augroup END

let s:tagsLastPath = ''
let s:tagsLastTime = 0

function s:UpdateTagsIfNeeded() abort
  let l:PWD = getcwd()
  let l:CURR_TIME = localtime()
  if s:tagsLastPath !=# l:PWD || (l:CURR_TIME - s:tagsLastTime) > 60 * 10  " 10 min
    let s:tagsLastPath = l:PWD
    let s:tagsLastTime = l:CURR_TIME
    call s:UpdateTags(v:false)
  endif
endfunction

function s:UpdateTags(recreate) abort
  if !s:IsRepository() || !filereadable(getcwd() .. '/tags') | return | endif
  " copy .notfunction for work environment
  if !filereadable('.notfunction') && filereadable(expand('~/.notfunction'))
    call system('cp ~/.notfunction .')
  endif
  if has('win32')
    if executable('ctags')
      !start ctags -R *
    endif
    if executable('gtags')
      !start gtags -v
    endif
  else
    let l:ctags_options = '-R --sort=yes --c++-kinds=+p --fields=+iaS --langmap=c++:+.ipp.tpp --extra=+q --exclude=library/*/* --exclude=*[Tt]est/* *'
    if a:recreate
      call job_start('/bin/bash -c "ctags ' .. l:ctags_options .. '"')
      call job_start('/bin/bash -c "gtags"')
    else
      call job_start('/bin/bash -c "ctags -f ' .. s:TEMP_TAGS .. ' ' .. l:ctags_options .. '"', {'close_cb': function('s:ReplaceTags')})
      call job_start('/bin/bash -c "global -u"')
    endif
  endif
endfunction

function s:ReplaceTags(ch_dummy) abort
  call system('mv tags_ tags')
endfunction

" https://github.com/greymd/oscyank.vim
" how to use: yank -> type ':CopyToClipboard'
command CopyToClipboard call s:CopyToClipboardByOSC52()
function s:CopyToClipboardByOSC52() abort
  let l:txt_file = trim(system('mktemp /tmp/vim_txt_XXX'))
  call writefile(split(@", '\n'), l:txt_file)
  let l:enc_file = system('mktemp /tmp/vim_enc_XXX')
  let l:executeCmd = "base64 " .. l:txt_file .. " | tr -d '\\n' > " .. l:enc_file
  let l:encodedText = system(l:executeCmd)
  call delete(l:txt_file)
  if !empty($TMUX)
    let l:executeCmd = 'echo -en "\033Ptmux;\033\033]52;;$(cat ' .. l:enc_file .. ')\033\033\\\\\033\\" > /dev/tty'
  elseif $TERM ==? "screen"
    let l:executeCmd = 'echo -en "\033P\033]52;;$(cat '          .. l:enc_file .. ')\007\033\\"         > /dev/tty'
  else
    let l:executeCmd = 'echo -en "\033]52;;$(cat '               .. l:enc_file .. ')\033\\"             > /dev/tty'
  endif
  call system(l:executeCmd)
  call delete(l:enc_file)
endfunction

command ToggleClipboard call s:ToggleClipboard()
function s:ToggleClipboard() abort
  if execute('autocmd TextYankPost') =~# 's:CopyToClipboardByOSC52'
    augroup CLIPBOARD
      autocmd!
    augroup END
    echo 'disabled'
  else
    augroup CLIPBOARD
      autocmd!
      autocmd TextYankPost * call s:CopyToClipboardByOSC52()
    augroup END
    echo 'enabled'
  endif
endfunction

command -nargs=1 Comment call s:CreatePopupComment(<q-args>, '<')
command -nargs=1 CommentUpper call s:CreatePopupComment(<q-args>, '^')
command -nargs=1 CommentLower call s:CreatePopupComment(<q-args>, 'v')
command -nargs=1 CommentRight call s:CreatePopupComment(<q-args>, '>')
function s:CreatePopupComment(text, direction) abort
  if a:direction == '<'
    call popup_create('- ' .. a:text, #{border: [0, 0, 0, 1], borderchars: ['^', '>', 'v', '<'], drag: v:true, close: 'click'})
  elseif a:direction == '^'
    call popup_create(a:text, #{border: [1, 0, 0, 0], borderchars: ['^', '>', 'v', '<'], drag: v:true, close: 'click'})
  elseif a:direction == 'v'
    call popup_create(a:text, #{border: [0, 0, 1, 0], borderchars: ['^', '>', 'v', '<'], drag: v:true, close: 'click'})
  elseif a:direction == '>'
    call popup_create(a:text .. ' -', #{border: [0, 1, 0, 0], borderchars: ['^', '>', 'v', '<'], drag: v:true, close: 'click'})
  endif
endfunction

command -nargs=+ -complete=file Git call s:GitCommand(<q-args>)
function s:GitCommand(args) abort
  let l:buf_name = 'git ' .. a:args
  if expand('%') !=# l:buf_name
    execute g:new_vnew l:buf_name
  endif
  set ft=diff
  set bt=nofile
  set noswapfile
  %d
  silent execute 'r !git ' .. a:args
  1d
  execute 'nnoremap <buffer> \\ :Git' a:args .. '<cr>'
  doautocmd FileType
endfunction

command -nargs=0 SvnDiff call s:SvnDiff()
function s:SvnDiff() abort
  let l:buf_name = 'svn diff'
  if expand('%') !=# l:buf_name
    execute g:new_vnew l:buf_name
  endif
  set ft=diff
  set bt=nofile
  set noswapfile
  %d
  silent execute 'r !svn diff'
  1d
  execute 'nnoremap <buffer> \\ :SvnDiff<cr>'
endfunction

let @d = ':DiffLine'
tnoremap @d N@d
command -nargs=0 DiffLine call s:OpenDiffLine()
" requires `git config --global diff.noprefix true`
function s:OpenDiffLine() abort
  let l:diff_line_line_num = search('^@@.*+', 'bn')
  if l:diff_line_line_num == 0 | echoerr "not found" | endif
  let l:diff_line = getline(l:diff_line_line_num)
  let l:diff_line_idx_start = match(l:diff_line, '+') + 1
  let l:diff_line_idx_end = match(l:diff_line, ',', l:diff_line_idx_start) - 1
  let l:diff_line = l:diff_line[l:diff_line_idx_start:l:diff_line_idx_end]
  let l:diff_file_line_num = search('^+++', 'bn')
  let l:diff_file = getline(l:diff_file_line_num)
  let l:diff_file_idx_end = match(l:diff_file, '\t')
  if l:diff_file_idx_end == -1
    " git
    let l:diff_file = l:diff_file[6:]
  else
    " svn
    let l:diff_file = l:diff_file[4:l:diff_file_idx_end]
  endif
  execute 'rightbelow' g:new_vnew '+' .. l:diff_line l:diff_file
endfunction

source ~/dotfiles/plugins.vim

set secure

" modeline
" vim: expandtab tabstop=2 textwidth=0
