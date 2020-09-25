let s:dein_dir = expand('~/.vim/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &compatible
    set nocompatible
endif

"--------------------------
" Start Dein Settings.
"--------------------------
" bundleで管理するディレクトリを指定
"execute 'set runtimepath^=' . s:dein_repo_dir

"if dein#load_state(s:dein_dir)
"	call dein#begin(s:dein_dir)
	
	" プラグインリストを収めた TOML ファイル
	" 予め TOML ファイル（後述）を用意しておく
	"let g:rc_dir    = expand('~/.vim/rc')
	"let s:toml      = g:rc_dir . '/dein.toml'
	"let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'
	
	" TOML を読み込み、キャッシュしておく
    "call dein#load_toml(s:toml,      {'lazy': 0})
    "call dein#load_toml(s:lazy_toml, {'lazy': 1})

	" 設定終了
    "call dein#end()
    "call dein#save_state()
"endif

"if dein#check_install()
"    call dein#install()
"endif

filetype plugin indent on

"------------------------
" End Dein Settings.
"------------------------

set tabstop=4

set background=dark
"colorscheme solarized
syntax on

" バックスペースで削除できるものを指定
set backspace=indent,eol,start
" カーソルを行頭，行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]

set clipboard=unnamed,autoselect

autocmd FileType python setl autoindent
autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setl tabstop=8 expandtab shiftwidth=4 softtabstop=4

noremap ; :
noremap : ;

nnoremap <C-e> :NERDTree<CR>

" neocompleteの補完候補をTabで選択できるようにする
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"

" インサートモードでもコマンドで移動できるようにする
inoremap <C-j>  <down>
inoremap <C-k>  <up>
inoremap <C-h>  <left>
inoremap <C-l>  <right>

set completeopt=menuone

" set completeopt-=noinsert




