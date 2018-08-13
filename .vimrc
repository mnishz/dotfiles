" ��Ђł̍�Ɨp�ݒ�
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

" �o�b�N�A�b�v�p�t�@�C����undo�p�t�@�C�����A���t�@�C���̏ꏊ�ł͂Ȃ���ӏ��ɂ܂Ƃ߂�B
" swap�t�@�C�����ǉ�
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
  " �}�����[�h�ɓ��鎞�C�O��̑}�����[�h�ɂ����� IME �̏�Ԃ𕜌�����D
  " Tera Term�ł��������Ă��Ȃ��B�B�B
  set t_SI+=[<r
  " �}�����[�h���o�鎞�C���݂� IME �̏�Ԃ�ۑ����CIME ���I�t�ɂ���D
  set t_EI+=[<s[<0t
  " Vim �I�����CIME �𖳌��ɂ��C�����ɂ�����Ԃ�ۑ�����D
  set t_te+=[<0t[<s
  " ESC �L�[�������Ă���}�����[�h���o��܂ł̎��Ԃ�Z������
  set ttimeoutlen=100

else

  if g:office_work
    " guess���g�������A���A������O��euc-jp�������Ă���
    set fileencodings=euc-jp,guess,ucs-bom,ucs-2le,ucs-2,iso-2022-jp-3,utf-8,euc-jisx0213
    " grep�̌��ʂ�euc-jp -> shift_jis��(Gtags�̌��ʂɂ��Ă�gtags.vim�ő΍�)
    set shellpipe=2>\&1\ \|\ nkf32\ -Es\ >\ %s
  endif

  " ���[��Adefault�̐ݒ�Ƃǂ������������������B��ŏ��������B�B�B
  " insert mode���o��Ƃ���IME��off�ɂ��� -> �K��IME off�ŊJ�n����
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
" dein���̂̎����C���X�g�[��
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath
" �v���O�C���ǂݍ��݁��L���b�V���쐬
let s:toml_file = fnamemodify(expand('<sfile>'), ':h').'/.dein.toml'
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  call dein#load_toml(s:toml_file)
  call dein#end()
endif
" �s���v���O�C���̎����C���X�g�[��
if has('vim_starting') && dein#check_install()
  call dein#install()
endif

" Required:
filetype plugin indent on
syntax enable

"End dein Scripts-------------------------

set title titlestring=%F
set number

" (:bro ol�ŕ\�������)�t�@�C���̗�����30�܂łɐ�������B���̑���Kaoriya�̃f�t�H���g�̐ݒ���c�����B
" ctrlp�̂ق����֗������Ȃ̂ł�������g�����Ƃɂ����B
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

"�o�C�i���ҏW(xxd)���[�h�ivim -b �ł̋N���A�������� *.bin �t�@�C�����J���Ɣ������܂��j
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
  " �R�����g�ł̎������s��}�~
  set textwidth=0
endif

" set tags=./tags;

" �����(:Cd)���g�����Ƃɂ����B
" set autochdir

" �����[�g���ł�<ctrl + ����L�[>�͂قƂ�Ǔ����Ȃ�
if !has('kaoriya')
  noremap <tab> :tabn<cr>
  noremap <a-right> :tabn<cr>
  noremap <a-left> :tabp<cr>
else
  " ctrl-tab�Ŏ���tab�ɐi��
  noremap <c-tab> :tabn<cr>
  noremap <c-s-tab> :tabp<cr>
  inoremap <c-tab> <esc>:tabn<cr>
  inoremap <c-s-tab> <esc>:tabp<cr>
  " ctrl-+/ctrl--��tab��ׂɈړ�
  noremap <c-kPlus> :tabm+<cr>
  noremap <c-kMinus> :tabm-<cr>
  " ���s
  noremap <c-cr> o<esc>
endif

noremap <c-f4> :tabc<cr>
noremap <space>c :tabc<cr>
noremap <c-n> :tabnew<cr>

" 3�s���i�ށA3�s���߂�
noremap <c-j> 3<c-e>
noremap <c-k> 3<c-y>
vnoremap <c-j> 3j
vnoremap <c-k> 3k
" �s���Ɉړ��A���܂���'f'��'t'�̎|�݂������Ȃ�
noremap ; $
vnoremap ; $h
" ������̐擪�Ɉړ�(���łɐ擪�ł����1��ڂɈړ�)
noremap <silent> 0 :call g:GoToFirstColumn()<cr>
vnoremap 0 ^

" ���very magic�Ō�������
noremap  /  /\v
nnoremap /  :set imsearch=0<cr>/\v
nnoremap // :set imsearch=2<cr>/\v
" comment, uncomment
vnoremap <space><space> :call g:ToggleComment()<cr>
" �����̗��������ǂ�Ƃ���very magic���͂���
nnoremap /<up> :set imsearch=0<cr>/<up>
noremap  /<up> /<up>
" *��very magic�Ō�������悤�ɒu��������A(����)���̌������ɔ��ł��܂��̂����Ȃ̂�<bs>�ň�߂��Ă��猟������
nnoremap * yiw<bs>/\v<c-r>0<cr>
" �P��Ō���
nnoremap <space>* yiw<bs>/\v<<c-r>0><cr>
" �����Ώۂ�ǉ����Ă���
nnoremap <bar> yiw<bs>/<up><bar><c-r>0<cr>
nnoremap <space><bar> yiw<bs>/<up><bar><<c-r>0><cr>
" �I��͈͂����̂܂�(���K�\�����g�킸��)��������
vnoremap * y<bs>/\V<c-r>0<cr>
vnoremap <space>* y<bs>/\V\<<c-r>0\><cr>

" �u��("ctrl-r"�ɂ������������A"r"�n�͂��낢��Ǝg���Ă���̂ő����Office�n�Ŏg����"ctrl-h"���g���B)
nnoremap <c-h> :%s/\v//gc<left><left><left><left>

" grep
nnoremap <silent> <c-g> :call g:DoGrep()<cr>
nnoremap } :cn<cr>
nnoremap { :cp<cr>

if g:office_work
  " �Z�N�V����(���\�b�h)�Ԉړ������܂������Ȃ��P�[�X������̂ŁA�ȈՓI�ȃ��\�b�h�Ԉړ����@���`
  " nnoremap [[ ?\v::\w+\([^\)]*\)[^\{]*\n{0,1}\{<cr>
  " nnoremap ]] /\v::\w+\([^\)]*\)[^\{]*\n{0,1}\{<cr>

  nnoremap <space><space> A // nishi 
endif

" �֐����ۂ����̂�����(�n�C���C�g)
nnoremap <space>/ /\v\w+\(<cr>

" gtags�֘A�Actags�͂������
" nnoremap ctags :!start ctags -R *<cr>
" nnoremap <f12> g<c-]>
" " �V�K�^�u��tjump����
" nnoremap <c-f12> :sp<cr><c-w>Tg<c-]>
nnoremap gtags :!start gtags -v<cr>
nnoremap <f11> :Gtags -f %<cr>
nnoremap <f12> :GtagsCursor<cr>
nnoremap <c-f12> :sp<cr><c-w>T:GtagsCursor<cr>
nnoremap <s-f12> :sp<cr><c-w>T:tabm-<cr>:Gtags -r <c-r><c-w><cr>
" nnoremap <s-f12> :sp<cr><c-w>T:tabm-<cr>:execute("Gtags -r " . cfi#format('%s', '')[0:-3])<cr>
nnoremap <c-f11> :vs<cr><c-w>l:GtagsCursor<cr>
nnoremap <s-f11> :sp<cr>:GtagsCursor<cr>

" ���݂̃E�B���h�E��ʃ^�u�Ɉړ�����
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

" �s���܂Ń����N
nnoremap Y y$
" �m�[�}�����[�h�ł�Windows�N���b�v�{�[�h�ւ̒P��R�s�[
nnoremap <c-insert> viw"*y
" ���x���W�X�^���w�肷��̂��ʓ|�Ȃ̂ŁAa, b, c���������N�ƃy�[�X�g�����蓖�ĂĂ���
nnoremap <space>ya "ayiw
nnoremap <space>yb "byiw
nnoremap <space>yc "cyiw
nnoremap <space>pa "ap
nnoremap <space>pb "bp
nnoremap <space>pc "cp

nnoremap <space>v :tabnew ~/.vimrc<cr>

noremap <c-z> :echo "nop"<cr>

" ����������s���Ă��܂����Ƃ��ɃC���f���g�����ׂď��� -> <expr>���g�����ق������ꂢ����
" <c-o>����undo�����������Ȃ�
inoremap <silent> <bs> <c-r>=g:BsForInsertMode()<cr>

nnoremap + :call g:ChangeFontSize(1)<cr>
nnoremap - :call g:ChangeFontSize(-1)<cr>

" " ����R�}���h�T���v��(�����Ȃ��Ȃ�nargs�͗v��Ȃ�����)
" command! -nargs=0 MyFunc call s:MyFunc()
" 
" " ":help expression"�Ƃ��ƍK���ɂȂ�邩��
" function! s:MyFunc()
"   " EX�R�}���h(ex-cmd-index��������expression-commands)�͂��̂܂܌Ăяo����
"     echo "foo"
"     normal gg
"   " ����]�����Ă���Ȃ�����(�ϐ������̂܂ܕ�����Ƃ��ĉ��߂��Ă��܂�����)�ɂ��Ă�execute���g��
"     let l:tabNumber = 1
"     " �ԈႢ
"     tabnext l:tabNumber
"     " ����
"     execute "tabnext " . l:tabNumber
"   " �g�ݍ��݊֐�(functions��������function-list)�⎩��֐���'����'�Ăяo���Ƃ��ɂ�call���g��
"   " ������let��echo�Ȃǎ���]��������̂̌��ł����call�͕K�v�Ȃ�
"     call feedkeys("gg")
"   " keypress��emulate����ɂ�normal(EX�R�}���h)��������feedkeys(�֐�)���g��
"   " �O���R�}���h(�V�F���R�}���h)��system
"   " ����ȕ\���𕶎���ɓW�J�������Ƃ���expand
" endfunction

command! FooBarTest call s:FooBarTest()
function! g:FooBarTest(...)
  return ""
endfunction

" ���݃t�@�C���̈ʒu�Ɉړ�����R�}���h
" �R�}���h�͏����I�ɕʃt�@�C���ɂ����ق������������B
" kaoriya�̏ꍇ�Acmdex.vim�ɂ܂������������̂�CdCurrent�Œ�`���Ă���B
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
    " ��肽���̂� == "\<esc>" �Ȃ񂾂��ǁA���܂������Ȃ��B���������B�B
    if l:c == 27 | redraw | echo "" | return | endif " �����Ƃ��܂��������@�͂Ȃ����̂��B�B
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
  " �������g�͕��Ȃ��̂�"+1"
  let l:firstTabNumberToClose = tabpagenr() + 1
  let l:totalTabCount = tabpagenr('$')
  " ��납�珇�ɕ��Ă���
  " �O���炾��tab number����ɍX�V����邽�ߓ���tab number���������K�v������A
  " ��������ƃG���[���N�����Ƃ���������tab number��increment���Ȃ���΂Ȃ炸�������ʓ|
  " ���ۑ��̕ύX�Ȃǂŕ��邱�Ƃ��ł��Ȃ������ꍇ�A����tab�����������c��
  for currTabNumber in range(l:firstTabNumberToClose, l:totalTabCount)
    " ��₱�����B�B�B
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
  " ��x'^'�ňړ�
  normal ^
  if l:orgColumn != 1 && l:orgColumn <= col(".")
    " 1��ڂ������牽�����Ȃ�('^'�ł�߂�)
    " �擪���O�������炳���'0'�Ɉړ�
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
    return "\<c-u>" " �C���f���g�݂̂̏ꍇ�͂��ׂď���
  else
    return "\<c-h>" " ����ȊO�̏ꍇ��1��������
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
    let l:sizeStartPos += 2 " �����J�n�����܂ňړ�
  endif
  let l:sizeEndPos = stridx(&guifont, ":", l:sizeStartPos)
  if (l:sizeEndPos == -1)
    echo "err"
    return
  else
    let l:sizeEndPos -= 1 " �����I�������܂ňړ�
  endif
  let l:orgFontSize = str2nr(&guifont[l:sizeStartPos:l:sizeEndPos])
  let l:newFontSize = printf("%d", l:orgFontSize + a:diff)
  let &guifont = &guifont[0:(l:sizeStartPos-1)] . l:newFontSize . &guifont[(l:sizeEndPos+1):-1]
endfunction

command! ReloadWithEucJp e ++enc=euc-jp
