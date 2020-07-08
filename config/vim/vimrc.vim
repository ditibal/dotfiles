" "
"                       __   _(_)_ __ ___  _ __ ___
"                       \ \ / / | '_ ` _ \| '__/ __|
"                        \ V /| | | | | | | | | (__
"                       (_)_/ |_|_| |_| |_|_|  \___|
"
"
set nocompatible             " No to the total compatibility with the ancient vi

" TODO: С+down: 5-down
" TODO: php fold

call plug#begin('~/.vim/plugged')

" Colorschemes
Plug 'ayu-theme/ayu-vim'

" Autocompletion of (, [, {, ', ", ...
Plug 'Raimondi/delimitMate'

" Define another type of |key-mapping| called
Plug 'kana/vim-arpeggio'

" browse the vim undo tree
Plug 'sjl/gundo.vim'

" A better looking status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" toggle comments
Plug 'tpope/vim-commentary'

" extend repetitions by the 'dot' key
Plug 'tpope/vim-repeat'

" TODO: записать в шапаргалку хоткеи
" text-objects
Plug 'kana/vim-textobj-entire' " ae, ie
Plug 'kana/vim-textobj-indent' " ai, ii, aI, iI
Plug 'kana/vim-textobj-lastpat' " a/, i/, a?, i?
Plug 'kana/vim-textobj-line' " al, il
Plug 'kana/vim-textobj-underscore' " a_, i_
Plug 'kana/vim-textobj-user'

" TODO: записать в шапаргалку хоткеи
" to surround vim objects with a pair of identical chars
Plug 'tpope/vim-surround'

" TODO: записать в шапаргалку хоткеи
" Pairs of handy bracket mappings
Plug 'tpope/vim-unimpaired'

" TODO: записать в шапаргалку хоткеи
" Fast motions in vim
Plug 'Lokaltog/vim-easymotion'

" TODO: записать в шапаргалку хоткеи
" Explore filesystem
Plug 'scrooloose/nerdtree', { 'on' : 'NERDTreeToggle' }

" TODO: записать в шапаргалку хоткеи
Plug 'mattn/emmet-vim', {'for': ['html', 'php', 'xhttml', 'css', 'xml', 'xls', 'markdown']}

" TODO: записать в шапаргалку хоткеи
" vim-easy-align
Plug  'junegunn/vim-easy-align'

" TODO: записать в шапаргалку хоткеи
" awesome multiple selection feature
Plug 'terryma/vim-multiple-cursors'

" Admin Git
Plug 'tpope/vim-fugitive'

" Show git repository changes in the current file
Plug 'airblade/vim-gitgutter'

" File explorer (needed where ranger is not available)
Plug 'Shougo/vimfiler', { 'on' : 'VimFiler' }

" Powerful and advanced Snippets tool
Plug 'SirVer/ultisnips'
" Plug 'SirVer/ultisnips', {'tag': '3.2', 'dir': get(g:, 'plug_home', '~/.vim/bundle') . '/ultisnips_py2' }

" TODO: записать в шапаргалку снипеты
" Snippets for Ultisnips
Plug 'honza/vim-snippets'

" Syntax checking hacks for vim
Plug 'scrooloose/syntastic'

Plug 'shougo/neocomplete.vim'

" Better whitespace highlighting
Plug 'ntpeters/vim-better-whitespace'

" Plug 'gcorne/phpfolding.vim'

Plug 'shawncplus/phpcomplete.vim'

" Start a * or # search from a visual block
Plug 'bronson/vim-visual-star-search'

" Unite. The interface to rule almost everything
Plug 'Shougo/unite.vim'
Plug 'Shougo/unite-outline'

" Plugin to display the indention levels with thin vertical lines
Plug 'Yggdroot/indentLine'

" Syntax highlight {{{
" vue
Plug 'posva/vim-vue'

" syntax for php
Plug 'stanangeloff/php.vim'

" json
" Plug 'elzr/vim-json', {'for' : 'json'}
" }}}

" Plug 'seletskiy/vim-pythonx'

Plug 'tpope/vim-abolish'

Plug 'alvan/vim-php-manual'

Plug 'mikehaertl/yii2-apidoc-vim'

Plug 'chr4/nginx.vim'

Plug 'digitaltoad/vim-pug'

Plug 'AndrewRadev/splitjoin.vim'

Plug 'lfilho/cosco.vim'

call plug#end()

source ~/.config/vim/general.vim

for f in split(glob('~/.config/vim/plugins/*.vim'), '\n')
    exe 'source' f
endfor

let g:indentLine_setConceal = 0

autocmd FileType java,php,scss,css,javascript,coffee,python,vim autocmd BufWritePre <buffer> StripWhitespace
