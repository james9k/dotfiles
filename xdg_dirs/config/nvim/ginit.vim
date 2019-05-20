if has("mac")
  set guifont=Fira\ Code:h11
endif

if has("unix")
  "set guifont=Source\ Code\ Pro:h11
  set guifont=DejaVu\ Sans\ Mono:h11
  set guifont=Fira\ Code:h11
  "set guifont=Fira\ Mono:h11
endif

set mouse=nv

" Set Copy,Cut and Paste shortcut keys
" paste will first go into visual mode
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+
