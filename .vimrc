let s:dein_dir = expand('~/.vim/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &compatible
    set nocompatible
endif


"--------------------------
" Start Dein Settings.
"--------------------------
" bundleで管理するディレクトリを指定
execute 'set runtimepath^=' . s:dein_repo_dir

call dein#begin(s:dein_dir)

" dein自体をdeinで管理
call dein#add('Shougo/dein.vim')
" vimを閉じずにファイル操作
call dein#add('scrooloose/nerdtree')
" 自動補完 luaが有効になってないと使えない
call dein#add('Shougo/neocomplete.vim')
" 自動で括弧閉じ
call dein#add('Townk/vim-autoclose')

call dein#add('kannokanno/previm')

call dein#add('tyru/open-browser.vim')

call dein#end()

if dein#check_install()
    call dein#install()
endif

filetype plugin indent on

"------------------------
" End Dein Settings.
"------------------------

set tabstop=4

syntax enable
set background=dark
colorscheme solarized

" バックスペースで削除できるものを指定
set backspace=indent,eol,start
" カーソルを行頭，行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]

set clipboard=unnamed,autoselect

let g:neocomplete#enable_at_startup = 1

autocmd FileType python setl autoindent
autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setl tabstop=8 expandtab shiftwidth=4 softtabstop=4

noremap ; :
noremap : ;

nnoremap <C-e> :NERDTree<CR>

" neocompleteの補完候補をTabで選択できるようにする
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
