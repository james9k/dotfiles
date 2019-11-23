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

autocmd FileType html,htmldjango,json,sql,yaml setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType conf,nginx,python,sh,sshconfig,zsh setlocal shiftwidth=4 softtabstop=4 expandtab

" Ale
packloadall
silent! helptags ALL
