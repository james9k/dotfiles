set guifont=Source\ Code\ Pro:h11
set mouse=nv

" Set Copy,Cut and Paste shortcut keys
" paste will first go into visual mode
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+
