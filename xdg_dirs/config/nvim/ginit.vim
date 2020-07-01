if has("unix")
    let firacode=system('fc-list | grep -c Fira\ Code')
    let dejavu=system('fc-list | grep -c DejaVu\ Sans\ Mono')
    let incon=system('fc-list | grep -c Inconsolata')

    if ( dejavu > 0 )
        set guifont=DejaVu\ Sans\ Mono\ 6
    elseif ( firacode > 0 )
        set guifont=Fira\ Code\ 10
    elseif ( incon > 0 )
        set guifont=Inconsolata 10
    endif

elseif has("mac")
    set guifont=Menlo:h9,Monaco:h10
endif

set mouse=nv

" Set Copy,Cut and Paste shortcut keys
" paste will first go into visual mode
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+
