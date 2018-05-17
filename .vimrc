" ‰ïĞ‚Å‚Ìì‹Æ—pİ’è
let g:for_office_work = v:true

let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME

if !has('kaoriya')

  set t_Co=256
  colorscheme default
  set fileencodings=cp932,ucs-bom,ucs-2le,ucs-2,iso-2022-jp-3,utf-8,euc-jisx0213,euc-jp

  " https://qiita.com/mwmsnn/items/0b40662a22162907efae
  " ‘}“üƒ‚[ƒh‚É“ü‚éC‘O‰ñ‚Ì‘}“üƒ‚[ƒh‚É‚¨‚¯‚é IME ‚Ìó‘Ô‚ğ•œŒ³‚·‚éD
  " Tera Term‚Å‚µ‚©“®‚¢‚Ä‚¢‚È‚¢BBB
  set t_SI+=[<r
  " ‘}“üƒ‚[ƒh‚ğo‚éCŒ»İ‚Ì IME ‚Ìó‘Ô‚ğ•Û‘¶‚µCIME ‚ğƒIƒt‚É‚·‚éD
  set t_EI+=[<s[<0t
  " Vim I—¹CIME ‚ğ–³Œø‚É‚µC–³Œø‚É‚µ‚½ó‘Ô‚ğ•Û‘¶‚·‚éD
  set t_te+=[<0t[<s
  " ESC ƒL[‚ğ‰Ÿ‚µ‚Ä‚©‚ç‘}“üƒ‚[ƒh‚ğo‚é‚Ü‚Å‚ÌŠÔ‚ğ’Z‚­‚·‚é
  set timeoutlen=100

else

  if g:for_office_work
    " guess‚ğg‚¢‚½‚¢A‚ªA‚»‚ê‚æ‚è‘O‚Éeuc-jp‚ğ‚Á‚Ä‚­‚é
    set fileencodings=euc-jp,guess,ucs-bom,ucs-2le,ucs-2,iso-2022-jp-3,utf-8,euc-jisx0213
    " grep‚ÌŒ‹‰Ê‚ğeuc-jp -> shift_jis‚É(Gtags‚ÌŒ‹‰Ê‚Í•Ï‚í‚ç‚È‚¢BBB)
    set shellpipe=2>\&1\|nkf32\ -Es>%s
  endif

  " ƒoƒbƒNƒAƒbƒv—pƒtƒ@ƒCƒ‹‚Æundo—pƒtƒ@ƒCƒ‹‚ğAŒ³ƒtƒ@ƒCƒ‹‚ÌêŠ‚Å‚Í‚È‚­ˆê‰ÓŠ‚É‚Ü‚Æ‚ß‚éB
  " swapƒtƒ@ƒCƒ‹‚à’Ç‰Á

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

  " ‚¤[‚ñAdefault‚Ìİ’è‚Æ‚Ç‚Á‚¿‚ª‚¢‚¢‚©•ª‚©‚ç‚ñBŒã‚ÅÁ‚·‚©‚àBBB
  " insert mode‚É“ü‚é/o‚é‚Æ‚«‚ÉIME‚ğoff‚É‚·‚é
  " imsearch‚Íiminsert‚Æ“¯‚¶‹““®‚É‚·‚é -> -1‚Å“¯‚¶‹““®‚É‚È‚é‚Æ‘‚¢‚Ä‚ ‚é‚ª‚È‚ç‚È‚¢B1‚ÅŠú‘Ò’Ê‚è‚Ì“®‚«‚ğ‚·‚é‚Ì‚Å‚±‚ê‚Å‚æ‚µ‚Æ‚·‚éB
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
" dein©‘Ì‚Ì©“®ƒCƒ“ƒXƒg[ƒ‹
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath
" ƒvƒ‰ƒOƒCƒ““Ç‚İ‚İ•ƒLƒƒƒbƒVƒ…ì¬
let s:toml_file = fnamemodify(expand('<sfile>'), ':h').'/.dein.toml'
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  call dein#load_toml(s:toml_file)
  call dein#end()
endif
" •s‘«ƒvƒ‰ƒOƒCƒ“‚Ì©“®ƒCƒ“ƒXƒg[ƒ‹
if has('vim_starting') && dein#check_install()
  call dein#install()
endif

" Required:
filetype plugin indent on
syntax enable

"End dein Scripts-------------------------

set title titlestring=%F
set number

" (:bro ol‚Å•\¦‚³‚ê‚é)ƒtƒ@ƒCƒ‹‚Ì—š—ğ‚ğ30‚Ü‚Å‚É§ŒÀ‚·‚éB‚»‚Ì‘¼‚ÍKaoriya‚ÌƒfƒtƒHƒ‹ƒg‚Ìİ’è‚ğc‚µ‚½B
" ctrlp‚Ì‚Ù‚¤‚ª•Ö—˜‚»‚¤‚È‚Ì‚Å‚»‚¿‚ç‚ğg‚¤‚±‚Æ‚É‚µ‚½B
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

" ƒRƒƒ“ƒg‚Å‚Ì©“®‰üs‚ğ—}~
set textwidth=0

" set tags=./tags;

" ‘ã‚í‚è‚É(:Cd)‚ğg‚¤‚±‚Æ‚É‚µ‚½B
" set autochdir

" ƒŠƒ‚[ƒgŠÂ‹«‚Å‚Í<ctrl + “ÁêƒL[>‚Í‚Ù‚Æ‚ñ‚Ç“®‚©‚È‚¢
" ‚±‚±‚©‚ç ----------------------------------------
  " ctrl-tab‚ÅŸ‚Ìtab‚Éi‚Ş
  nnoremap <c-tab> :tabn<cr>
  nnoremap <c-s-tab> :tabp<cr>
  inoremap <c-tab> <esc>:tabn<cr>
  inoremap <c-s-tab> <esc>:tabp<cr>
  " ctrl-+/ctrl--‚Åtab‚ğ—×‚ÉˆÚ“®
  nnoremap <c-kPlus> :tabm+<cr>
  nnoremap <c-kMinus> :tabm-<cr>
  nnoremap <c-f4> :tabc<cr>
  nnoremap <space>c :tabc<cr>
  nnoremap <c-n> :tabnew<cr>

  " ‰üs
  nnoremap <c-cr> o<esc>
" ‚±‚±‚Ü‚Å ----------------------------------------

" 3s‚¸‚Âi‚ŞA3s‚¸‚Â–ß‚é
nnoremap <c-j> 3<c-e>
nnoremap <c-k> 3<c-y>
vnoremap <c-j> 3j
vnoremap <c-k> 3k
" s––‚ÉˆÚ“®A‚¢‚Ü‚¢‚¿'f'‚â't'‚Ì|‚İ‚ğŠ´‚¶‚È‚¢
noremap ; $
" •¶š—ñ‚Ìæ“ª‚ÉˆÚ“®(‚·‚Å‚Éæ“ª‚Å‚ ‚ê‚Î1—ñ–Ú‚ÉˆÚ“®)
nnoremap <silent> 0 :call GoToFirstColumn()<cr>
vnoremap 0 ^

" í‚Évery magic‚ÅŒŸõ‚·‚é
nnoremap / /\v
" ŒŸõ‚Ì—š—ğ‚ğ‚½‚Ç‚é‚Æ‚«‚Ívery magic‚ğ‚Í‚¸‚·
nnoremap /<up> /<up>
" *‚ğvery magic‚ÅŒŸõ‚·‚é‚æ‚¤‚É’u‚«Š·‚¦‚éA(‰“‚¢)Ÿ‚ÌŒŸõŒó•â‚É”ò‚ñ‚Å‚µ‚Ü‚¤‚Ì‚ªŒ™‚È‚Ì‚Å<bs>‚ÅˆêŒÂ–ß‚Á‚Ä‚©‚çŒŸõ‚·‚é
nnoremap * yiw<bs>/\v<c-r>0<cr>
" ’PŒê‚ÅŒŸõ
nnoremap <space>* yiw<bs>/\v<<c-r>0><cr>
" ŒŸõ‘ÎÛ‚ğ’Ç‰Á‚µ‚Ä‚¢‚­
nnoremap <bar> yiw<bs>/<up><bar><c-r>0<cr>
nnoremap <space><bar> yiw<bs>/<up><bar><<c-r>0><cr>
" ‘I‘ğ”ÍˆÍ‚ğ‚»‚Ì‚Ü‚Ü(³‹K•\Œ»‚ğg‚í‚¸‚É)ŒŸõ‚·‚é
vnoremap * y<bs>/\V<c-r>0<cr>
vnoremap <space>* y<bs>/\V\<<c-r>0\><cr>

" ’uŠ·("ctrl-r"‚É‚µ‚½‚©‚Á‚½‚ªA"r"Œn‚Í‚¢‚ë‚¢‚ë‚Æg‚í‚ê‚Ä‚¢‚é‚Ì‚Å‘ã‚í‚è‚ÉOfficeŒn‚Åg‚í‚ê‚é"ctrl-h"‚ğg‚¤B)
nnoremap <c-h> :%s/\v

" grep
nnoremap <c-g> :tabnew <bar> grep -iE "" <bar> cw<left><left><left><left><left><left>
nnoremap } :cn<cr>
nnoremap { :cp<cr>

if g:for_office_work
  " ƒZƒNƒVƒ‡ƒ“(ƒƒ\ƒbƒh)ŠÔˆÚ“®‚ª‚¤‚Ü‚­“®‚©‚È‚¢ƒP[ƒX‚ª‚ ‚é‚Ì‚ÅAŠÈˆÕ“I‚Èƒƒ\ƒbƒhŠÔˆÚ“®•û–@‚ğ’è‹`
  " nnoremap [[ ?\v::\w+\([^\)]*\)[^\{]*\n{0,1}\{<cr>
  " nnoremap ]] /\v::\w+\([^\)]*\)[^\{]*\n{0,1}\{<cr>

  nnoremap <space><space> A // nishi 
  " ŠÖ”‚Á‚Û‚¢‚à‚Ì‚ğŒŸõ(ƒnƒCƒ‰ƒCƒg)
  nnoremap <space>/ /\v\w+\(<cr>
endif

" gtagsŠÖ˜AActags‚Í‚¨–ğŒä–Æ
nnoremap ctags :!start ctags -R *<cr>
" nnoremap <f12> g<c-]>
" " V‹Kƒ^ƒu‚Åtjump‚·‚é
" nnoremap <c-f12> :sp<cr><c-w>Tg<c-]>
nnoremap gtags :!start gtags -v<cr>
nnoremap <f11> :Gtags -f %<cr>
nnoremap <f12> :GtagsCursor<cr>
nnoremap <c-f12> :sp<cr><c-w>T:GtagsCursor<cr>
nnoremap <s-f12> :sp<cr><c-w>T:tabm-<cr>:Gtags -r <c-r><c-w><cr>
nnoremap <c-f11> :vs<cr><c-w>l:GtagsCursor<cr>
nnoremap <s-f11> :sp<cr>:GtagsCursor<cr>

" Œ»İ‚ÌƒEƒBƒ“ƒhƒE‚ğ•Êƒ^ƒu‚ÉˆÚ“®‚·‚é
nnoremap <f10> <c-w>T
nnoremap <c-f10> :sp<cr><c-w>T

" s––‚Ü‚Åƒ„ƒ“ƒN
nnoremap Y y$
" ƒm[ƒ}ƒ‹ƒ‚[ƒh‚Å‚ÌWindowsƒNƒŠƒbƒvƒ{[ƒh‚Ö‚Ì’PŒêƒRƒs[
nnoremap <c-insert> viw"*y
" –ˆ“xƒŒƒWƒXƒ^‚ğw’è‚·‚é‚Ì‚ª–Ê“|‚È‚Ì‚ÅAa, b, c‚¾‚¯ƒ„ƒ“ƒN‚Æƒy[ƒXƒg‚ğŠ„‚è“–‚Ä‚Ä‚¨‚­
nnoremap <space>ya "ayiw
nnoremap <space>yb "byiw
nnoremap <space>yc "cyiw
nnoremap <space>pa "ap
nnoremap <space>pb "bp
nnoremap <space>pc "cp

" " ©ìƒRƒ}ƒ“ƒhƒTƒ“ƒvƒ‹(ˆø”‚È‚µ‚È‚çnargs‚Í—v‚ç‚È‚¢‚©‚à)
" command! -nargs=0 MyFunc call s:MyFunc()
" 
" " ":help expression"‚Æ‚â‚é‚ÆK‚¹‚É‚È‚ê‚é‚©‚à
" function! s:MyFunc()
"   " EXƒRƒ}ƒ“ƒh(ex-cmd-index)‚Í‚»‚Ì‚Ü‚ÜŒÄ‚Ño‚¹‚é
"     echo "foo"
"     normal gg
"   " ®‚ğ•]‰¿‚µ‚Ä‚­‚ê‚È‚¢‚à‚Ì(•Ï”‚ğ‚»‚Ì‚Ü‚Ü‰ğß‚µ‚Ä‚µ‚Ü‚¤‚à‚Ì)‚É‚Â‚¢‚Ä‚Íexecute‚ğg‚¤
"     let l:tabNumber = 1
"     " ŠÔˆá‚¢
"     tabnext l:tabNumber
"     " ³‰ğ
"     execute "tabnext " . l:tabNumber
"   " ‘g‚İ‚İŠÖ”(functions)‚â©ìŠÖ”‚ğŒÄ‚Ño‚·‚Æ‚«‚É‚Ícall‚ğg‚¤
"     call feedkeys("gg")
"   " keypress‚ğemulate‚·‚é‚É‚Ínormal(EXƒRƒ}ƒ“ƒh)‚à‚µ‚­‚Ífeedkeys(ŠÖ”)‚ğg‚¤
"   " ŠO•”ƒRƒ}ƒ“ƒh‚Ísystem
" endfunction

" Œ»İƒtƒ@ƒCƒ‹‚ÌˆÊ’u‚ÉˆÚ“®‚·‚éƒRƒ}ƒ“ƒh
" ƒRƒ}ƒ“ƒh‚Í«—ˆ“I‚É•Êƒtƒ@ƒCƒ‹‚É‚µ‚½‚Ù‚¤‚ª‚¢‚¢‚©‚àB
" kaoriya‚Ìê‡Acmdex.vim‚É‚Ü‚Á‚½‚­“¯‚¶‚à‚Ì‚ªCdCurrent‚Å’è‹`‚µ‚Ä‚ ‚éB
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
        " ‚±‚êˆÈãã‚És‚¯‚È‚¯‚ê‚Î‚â‚ß‚ÄAŒ³‚Ìpath‚É–ß‚·
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
  " ©•ª©g‚Í•Â‚¶‚È‚¢‚Ì‚Å"+1"
  let l:firstTabNumberToClose = tabpagenr() + 1
  let l:totalTabCount = tabpagenr('$')
  " Œã‚ë‚©‚ç‡‚É•Â‚¶‚Ä‚¢‚­
  " ‘O‚©‚ç‚¾‚Ætab number‚ªí‚ÉXV‚³‚ê‚é‚½‚ß“¯‚¶tab number‚ğ•Â‚¶‘±‚¯‚é•K—v‚ª‚ ‚èA
  " ‚»‚¤‚·‚é‚ÆƒGƒ‰[‚ª‹N‚«‚½‚Æ‚«‚¾‚¯•Â‚¶‚étab number‚ğincrement‚µ‚È‚¯‚ê‚Î‚È‚ç‚¸ˆ—‚ª–Ê“|
  " –¢•Û‘¶‚Ì•ÏX‚È‚Ç‚Å•Â‚¶‚é‚±‚Æ‚ª‚Å‚«‚È‚©‚Á‚½ê‡A‚»‚Ìtab‚½‚¿‚¾‚¯‚ªc‚é
  for currTabNumber in range(l:firstTabNumberToClose, l:totalTabCount)
    " ‚â‚â‚±‚µ‚¢BBB
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
  " ˆê“x'^'‚ÅˆÚ“®
  normal ^
  if l:orgColumn != 1 && l:orgColumn <= col(".")
    " 1—ñ–Ú‚¾‚Á‚½‚ç‰½‚à‚µ‚È‚¢('^'‚Å‚â‚ß‚é)
    " æ“ª‚æ‚è‘O‚¾‚Á‚½‚ç‚³‚ç‚É'0'‚ÉˆÚ“®
    normal! 0
  endif
endfunction
