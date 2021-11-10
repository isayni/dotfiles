"   python execution and output to a reusable buffer window
nnoremap <silent> <F5> :call RunPython()<CR>

function RunPython()
    " save
    silent execute "update"

    if exists("t:buf_nr") && bufexists(t:buf_nr) && bufwinnr(t:buf_nr) != bufwinnr('%')
        silent execute bufwinnr(t:buf_nr) . 'wincmd c'
    endif

    silent execute 'vert ter python "%:p" ' . 'Python'
    let t:buf_nr = bufnr('%')
endfunction
