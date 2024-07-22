if has("unix")
  set rtp^=/usr/share/vim/vimfiles/
endif

syntax enable

set number          " Case insensitive matching
set hlsearch        " Highlight all search matches
set colorcolumn=80  " Show coloured line at column 80
set ignorecase      " Ignore case when searching
set nowrap          " Keep lines long
set incsearch       " Start highlighting matching parts immediately

set termguicolors

" Navigate between splits with keyboard shortcuts
" https://realpython.com/blog/python/vim-and-python-a-match-made-in-heaven/
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

packadd! palenight.vim
colorscheme palenight

set background=dark

autocmd FileType apache,conf,html,htmldjango,json,nftables,sql,yaml,xml setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType javascript,nginx,python,sh,sshconfig,zsh setlocal shiftwidth=4 softtabstop=4 expandtab

" Ale
packloadall
silent! helptags ALL

set title

if exists("g:neovide")
    " Put anything you want to happen only in Neovide here
    " set guifont=Source\ Code\ Pro:h14
    "set guifont=Noto\ Sans\ Mono:h14
    set guifont=Noto\ Sans\ Mono:h11
endif
