noremap <F5> :w<CR>:silent !gcc %:p -o %:p.elf<CR>:redraw!<CR>:vert ter ++cols=50 %:p.elf<CR>
