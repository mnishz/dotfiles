" ‰ïĞ‚Å‚Ìì‹Æ—pİ’è
if !exists("g:office_work") | let g:office_work = v:false | endif
if !exists("g:help_translation") | let g:help_translation = v:false | endif

if g:help_translation
  " for vimdoc-ja-working
  set fileencoding=utf-8
  set fileformat=unix
  set encoding=utf-8
  let autofmt_allow_over_tw=1
  set formatoptions+=mM
endif

" ƒoƒbƒNƒAƒbƒv—pƒtƒ@ƒCƒ‹‚Æundo—pƒtƒ@ƒCƒ‹‚ğAŒ³ƒtƒ@ƒCƒ‹‚ÌêŠ‚Å‚Í‚È‚­ˆê‰ÓŠ‚É‚Ü‚Æ‚ß‚éB
" swapƒtƒ@ƒCƒ‹‚à’Ç‰Á
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:bak_path = s:cache_home . "/vim/bak"
let s:undo_path = s:cache_home . "/vim/undo"
let s:swap_path = s:cache_home . "/vim/swap"
if !isdirectory(s:bak_path) | call mkdir(s:bak_path, "p") | endif
if !isdirectory(s:undo_path) | call mkdir(s:undo_path, "p") | endif
if !isdirectory(s:swap_path) | call mkdir(s:swap_path, "p") | endif
let &backupdir = s:bak_path
let &undodir = s:undo_path
let &directory = s:swap_path

if !has('kaoriya')

  set t_Co=256
  colorscheme torte
  set fileencodings=euc-jp,cp932,utf-8,euc-jisx0213,ucs-bom,ucs-2le,ucs-2,iso-2022-jp-3

  set backup
  set writebackup
  set undofile
  set swapfile

  " https://qiita.com/mwmsnn/items/0b40662a22162907efae
  " ‘}“üƒ‚[ƒh‚É“ü‚éC‘O‰ñ‚Ì‘}“üƒ‚[ƒh‚É‚¨‚¯‚é IME ‚Ìó‘Ô‚ğ•œŒ³‚·‚éD
  " Tera Term‚Å‚µ‚©“®‚¢‚Ä‚¢‚È‚¢BBB
  set t_SI+=[<r
  " ‘}“üƒ‚[ƒh‚ğo‚éCŒ»İ‚Ì IME ‚Ìó‘Ô‚ğ•Û‘¶‚µCIME ‚ğƒIƒt‚É‚·‚éD
  set t_EI+=[<s[<0t
  " Vim I—¹CIME ‚ğ–³Œø‚É‚µC–³Œø‚É‚µ‚½ó‘Ô‚ğ•Û‘¶‚·‚éD
  set t_te+=[<0t[<s
  " ESC ƒL[‚ğ‰Ÿ‚µ‚Ä‚©‚ç‘}“üƒ‚[ƒh‚ğo‚é‚Ü‚Å‚ÌŠÔ‚ğ’Z‚­‚·‚é
  set ttimeoutlen=100

else

  if g:office_work
    " guess‚ğg‚¢‚½‚¢A‚ªA‚»‚ê‚æ‚è‘O‚Éeuc-jp‚ğ‚Á‚Ä‚­‚é
    set fileencodings=euc-jp,guess,ucs-bom,ucs-2le,ucs-2,iso-2022-jp-3,utf-8,euc-jisx0213
    " grep‚ÌŒ‹‰Ê‚ğeuc-jp -> shift_jis‚É(Gtags‚ÌŒ‹‰Ê‚É‚Â‚¢‚Ä‚Ígtags.vim‚Å‘Îô)
    set shellpipe=2>\&1\ \|\ nkf32\ -Es\ >\ %s
  endif

  " ‚¤[‚ñAdefault‚Ìİ’è‚Æ‚Ç‚Á‚¿‚ª‚¢‚¢‚©•ª‚©‚ç‚ñBŒã‚ÅÁ‚·‚©‚àBBB
  " insert mode‚ğo‚é‚Æ‚«‚ÉIME‚ğoff‚É‚·‚é -> •K‚¸IME off‚ÅŠJn‚·‚é
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

set shiftwidth=4
set expandtab

if g:office_work
  set shiftwidth=2
elseif g:help_translation
  set noexpandtab
endif

set autoindent
set smartindent
" set cindent

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

set nrformats-=octal

"ƒoƒCƒiƒŠ•ÒW(xxd)ƒ‚[ƒhivim -b ‚Å‚Ì‹N“®A‚à‚µ‚­‚Í *.bin ƒtƒ@ƒCƒ‹‚ğŠJ‚­‚Æ”­“®‚µ‚Ü‚·j
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

hi Ignore ctermfg=red

if !g:help_translation
  " ƒRƒƒ“ƒg‚Å‚Ì©“®‰üs‚ğ—}~
  set textwidth=0
endif

" set tags=./tags;

" ‘ã‚í‚è‚É(:Cd)‚ğg‚¤‚±‚Æ‚É‚µ‚½B
" set autochdir

" ƒŠƒ‚[ƒgŠÂ‹«‚Å‚Í<ctrl + “ÁêƒL[>‚Í‚Ù‚Æ‚ñ‚Ç“®‚©‚È‚¢
if !has('kaoriya')
  noremap <tab> :tabn<cr>
  noremap <a-right> :tabn<cr>
  noremap <a-left> :tabp<cr>
else
  " ctrl-tab‚ÅŸ‚Ìtab‚Éi‚Ş
  noremap <c-tab> :tabn<cr>
  noremap <c-s-tab> :tabp<cr>
  inoremap <c-tab> <esc>:tabn<cr>
  inoremap <c-s-tab> <esc>:tabp<cr>
  " ctrl-+/ctrl--‚Åtab‚ğ—×‚ÉˆÚ“®
  noremap <c-kPlus> :tabm+<cr>
  noremap <c-kMinus> :tabm-<cr>
  " ‰üs
  noremap <c-cr> o<esc>
endif

noremap <c-f4> :tabc<cr>
noremap <space>c :tabc<cr>
noremap <c-n> :tabnew<cr>

" 3s‚¸‚Âi‚ŞA3s‚¸‚Â–ß‚é
noremap <c-j> 3<c-e>
noremap <c-k> 3<c-y>
vnoremap <c-j> 3j
vnoremap <c-k> 3k
" s––‚ÉˆÚ“®A‚¢‚Ü‚¢‚¿'f'‚â't'‚Ì|‚İ‚ğŠ´‚¶‚È‚¢
noremap ; $
vnoremap ; $h
" •¶š—ñ‚Ìæ“ª‚ÉˆÚ“®(‚·‚Å‚Éæ“ª‚Å‚ ‚ê‚Î1—ñ–Ú‚ÉˆÚ“®)
noremap <silent> 0 :call g:GoToFirstColumn()<cr>
vnoremap 0 ^

" í‚Évery magic‚ÅŒŸõ‚·‚é
noremap  /  /\v
nnoremap /  :set imsearch=0<cr>/\v
nnoremap // :set imsearch=2<cr>/\v
" comment, uncomment
vnoremap <space><space> :call g:ToggleComment()<cr>
" ŒŸõ‚Ì—š—ğ‚ğ‚½‚Ç‚é‚Æ‚«‚Ívery magic‚ğ‚Í‚¸‚·
nnoremap /<up> :set imsearch=0<cr>/<up>
noremap  /<up> /<up>
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
nnoremap <c-h> :%s/\v//gc<left><left><left><left>

" grep
nnoremap <silent> <c-g> :call g:DoGrep()<cr>
nnoremap } :cn<cr>
nnoremap { :cp<cr>

if g:office_work
  " ƒZƒNƒVƒ‡ƒ“(ƒƒ\ƒbƒh)ŠÔˆÚ“®‚ª‚¤‚Ü‚­“®‚©‚È‚¢ƒP[ƒX‚ª‚ ‚é‚Ì‚ÅAŠÈˆÕ“I‚Èƒƒ\ƒbƒhŠÔˆÚ“®•û–@‚ğ’è‹`
  " nnoremap [[ ?\v::\w+\([^\)]*\)[^\{]*\n{0,1}\{<cr>
  " nnoremap ]] /\v::\w+\([^\)]*\)[^\{]*\n{0,1}\{<cr>

  nnoremap <space><space> A // nishi 
endif

" ŠÖ”‚Á‚Û‚¢‚à‚Ì‚ğŒŸõ(ƒnƒCƒ‰ƒCƒg)
nnoremap <space>/ /\v\w+\(<cr>

" gtagsŠÖ˜AActags‚Í‚¨–ğŒä–Æ
" nnoremap ctags :!start ctags -R *<cr>
" nnoremap <f12> g<c-]>
" " V‹Kƒ^ƒu‚Åtjump‚·‚é
" nnoremap <c-f12> :sp<cr><c-w>Tg<c-]>
nnoremap gtags :!start gtags -v<cr>
nnoremap <f11> :Gtags -f %<cr>
nnoremap <f12> :GtagsCursor<cr>
nnoremap <c-f12> :sp<cr><c-w>T:GtagsCursor<cr>
nnoremap <s-f12> :sp<cr><c-w>T:tabm-<cr>:Gtags -r <c-r><c-w><cr>
" nnoremap <s-f12> :sp<cr><c-w>T:tabm-<cr>:execute("Gtags -r " . cfi#format('%s', '')[0:-3])<cr>
nnoremap <c-f11> :vs<cr><c-w>l:GtagsCursor<cr>
nnoremap <s-f11> :sp<cr>:GtagsCursor<cr>

" Œ»İ‚ÌƒEƒBƒ“ƒhƒE‚ğ•Êƒ^ƒu‚ÉˆÚ“®‚·‚é
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

nnoremap <space>v :tabnew ~/.vimrc<cr>

noremap <c-z> :echo "nop"<cr>

" ‚¤‚Á‚©‚è‰üs‚µ‚Ä‚µ‚Ü‚Á‚½‚Æ‚«‚ÉƒCƒ“ƒfƒ“ƒg‚ğ‚·‚×‚ÄÁ‚· -> <expr>‚ğg‚Á‚½‚Ù‚¤‚ª‚«‚ê‚¢‚©‚à
" <c-o>‚¾‚Æundo‚ª‚¨‚©‚µ‚­‚È‚é
inoremap <silent> <bs> <c-r>=g:BsForInsertMode()<cr>

nnoremap + :call g:ChangeFontSize(1)<cr>
nnoremap - :call g:ChangeFontSize(-1)<cr>

" " ©ìƒRƒ}ƒ“ƒhƒTƒ“ƒvƒ‹(ˆø”‚È‚µ‚È‚çnargs‚Í—v‚ç‚È‚¢‚©‚à)
" command! -nargs=0 MyFunc call s:MyFunc()
" 
" " ":help expression"‚Æ‚â‚é‚ÆK‚¹‚É‚È‚ê‚é‚©‚à
" function! s:MyFunc()
"   " EXƒRƒ}ƒ“ƒh(ex-cmd-index‚à‚µ‚­‚Íexpression-commands)‚Í‚»‚Ì‚Ü‚ÜŒÄ‚Ño‚¹‚é
"     echo "foo"
"     normal gg
"   " ®‚ğ•]‰¿‚µ‚Ä‚­‚ê‚È‚¢‚à‚Ì(•Ï”‚ğ‚»‚Ì‚Ü‚Ü•¶š—ñ‚Æ‚µ‚Ä‰ğß‚µ‚Ä‚µ‚Ü‚¤‚à‚Ì)‚É‚Â‚¢‚Ä‚Íexecute‚ğg‚¤
"     let l:tabNumber = 1
"     " ŠÔˆá‚¢
"     tabnext l:tabNumber
"     " ³‰ğ
"     execute "tabnext " . l:tabNumber
"   " ‘g‚İ‚İŠÖ”(functions‚à‚µ‚­‚Ífunction-list)‚â©ìŠÖ”‚ğ'’¼Ú'ŒÄ‚Ño‚·‚Æ‚«‚É‚Ícall‚ğg‚¤
"   " ‚½‚¾‚µlet‚âecho‚È‚Ç®‚ğ•]‰¿‚·‚é‚à‚Ì‚ÌŒã‚ë‚Å‚ ‚ê‚Îcall‚Í•K—v‚È‚¢
"     call feedkeys("gg")
"   " keypress‚ğemulate‚·‚é‚É‚Ínormal(EXƒRƒ}ƒ“ƒh)‚à‚µ‚­‚Ífeedkeys(ŠÖ”)‚ğg‚¤
"   " ŠO•”ƒRƒ}ƒ“ƒh(ƒVƒFƒ‹ƒRƒ}ƒ“ƒh)‚Ísystem
"   " “Áê‚È•\Œ»‚ğ•¶š—ñ‚É“WŠJ‚µ‚½‚¢‚Æ‚«‚Íexpand
" endfunction

command! FooBarTest call s:FooBarTest()
function! g:FooBarTest(...)
  return ""
endfunction

" Œ»İƒtƒ@ƒCƒ‹‚ÌˆÊ’u‚ÉˆÚ“®‚·‚éƒRƒ}ƒ“ƒh
" ƒRƒ}ƒ“ƒh‚Í«—ˆ“I‚É•Êƒtƒ@ƒCƒ‹‚É‚µ‚½‚Ù‚¤‚ª‚¢‚¢‚©‚àB
" kaoriya‚Ìê‡Acmdex.vim‚É‚Ü‚Á‚½‚­“¯‚¶‚à‚Ì‚ªCdCurrent‚Å’è‹`‚µ‚Ä‚ ‚éB
" command! -nargs=0 Cd cd %:p:h
command! Cd call s:CdToGitRoot()

function! s:GetGitRootPath(...)
  if a:0 > 1
    echoerr "invalid args"
    return ""
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
  endif
  return l:result
endfunction

function! s:CdToGitRoot()
  let l:gitRootPath = s:GetGitRootPath()
  if empty(l:gitRootPath)
    echo "no root..."
  else
    execute "cd " . l:gitRootPath
    echo l:gitRootPath
  endif
endfunction

function! g:DoGrep()
  let l:warnings = ""
  let l:gitRootOfPwd = s:GetGitRootPath(getcwd())
  if l:gitRootOfPwd != s:GetGitRootPath()
    let l:warnings = l:warnings . "NOT the same repository, "
  endif
  if empty(l:gitRootOfPwd)
    let l:warnings = l:warnings . "NOT a git repository, "
  endif
  if l:warnings != ""
    echohl ErrorMsg | echo "Caution: " . l:warnings . "continue... " | echohl None
    let l:c = getchar()
    " ‚â‚è‚½‚¢‚Ì‚Í == "\<esc>" ‚È‚ñ‚¾‚¯‚ÇA‚¤‚Ü‚­‚¢‚©‚È‚¢B’¼‚µ‚½‚¢BB
    if l:c == 27 | redraw | echo "" | return | endif " ‚à‚Á‚Æ‚¤‚Ü‚­Á‚·•û–@‚Í‚È‚¢‚à‚Ì‚©BB
  endif
  if has('kaoriya')
    let l:keyHeadStr = ":tabnew \<bar> set transparency=200 \<bar> grep -iE"
  else
    let l:keyHeadStr = ":tabnew \<bar> grep -iE"
  endif
  if empty(l:gitRootOfPwd)
    let l:keyHeadStr = l:keyHeadStr . " --no-index"
  endif
  call feedkeys(l:keyHeadStr . " \"\" \<bar> cw\<left>\<left>\<left>\<left>\<left>\<left>")
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
  if getline(".") =~ '^[ \t]\+$'
    return "\<c-u>" " ƒCƒ“ƒfƒ“ƒg‚Ì‚İ‚Ìê‡‚Í‚·‚×‚ÄÁ‚·
  else
    return "\<c-h>" " ‚»‚êˆÈŠO‚Ìê‡‚Í1•¶šÁ‚·
  endif
endfunction

function! g:MyStatusLine()
  if empty(&fileencoding)
    return "%f%m%r%h%w\ /\ %{cfi#format('%s','')}%=%v\ [%{&fileformat},\ %{&encoding}]"
  else
    return "%f%m%r%h%w\ /\ %{cfi#format('%s','')}%=%v\ [%{&fileformat},\ %{&fileencoding}]"
  endif
endfunction

function! g:ToggleComment() range
  if !exists('b:comment_text') | echo 'no b:comment_text' | return | endif
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

function! g:ChangeFontSize(diff)
  let l:sizeStartPos = stridx(&guifont, ":h")
  if (l:sizeStartPos == -1)
    echo "err"
    return
  else
    let l:sizeStartPos += 2 " ”šŠJn•”•ª‚Ü‚ÅˆÚ“®
  endif
  let l:sizeEndPos = stridx(&guifont, ":", l:sizeStartPos)
  if (l:sizeEndPos == -1)
    echo "err"
    return
  else
    let l:sizeEndPos -= 1 " ”šI—¹•”•ª‚Ü‚ÅˆÚ“®
  endif
  let l:orgFontSize = str2nr(&guifont[l:sizeStartPos:l:sizeEndPos])
  let l:newFontSize = printf("%d", l:orgFontSize + a:diff)
  let &guifont = &guifont[0:(l:sizeStartPos-1)] . l:newFontSize . &guifont[(l:sizeEndPos+1):-1]
endfunction

command! ReloadWithEucJp e ++enc=euc-jp
