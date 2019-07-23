set guifont=Cica:h10:cSHIFTJIS

" 起動時に画面を最大化する
if g:help_translation
  set columns=84
else
  au GUIEnter * simalt ~x
endif

" 起動に時間がかかるので、menuを読み込まない。
" ただしこの設定をしても読み込んでいる。よく分からない。
" 実力行使でファイル名を"menu.vim" -> "menu.vim.bak"に変更。 -> 結局やめた。
set guioptions-=m " メニューバー非表示
set guioptions-=r " 右スクロールバー非表示
set guioptions-=L " 左スクロールバー非表示
set guioptions-=T " ツールバー非表示

" 常にタブバーを表示する。ちなみにgvimへのSendToショートカットには"-p --remote-tab-silent"が足してあって、
" gvimをSendToで開いた場合、多重起動せずにタブで開く。
set showtabline=2

" アンダーラインを引く(gui) -> 結局やめた。
" highlight CursorLine gui=underline guifg=NONE guibg=NONE
