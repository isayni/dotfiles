" C++ compiling
noremap <F4> :w<CR>:silent !g++ %:p -o %:p.exe<CR>:redraw!<CR>
noremap <F5> :w<CR>:silent !g++ %:p -o %:p.exe<CR>:redraw!<CR>:vert ter ++cols=50 %:p.exe<CR>
