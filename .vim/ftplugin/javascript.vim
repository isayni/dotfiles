"   nodejs execution and output to a reusable buffer window
nnoremap <silent> <F5> :call RunNode()<CR>

function RunNode()
    " save
    silent execute "update"

    if exists("t:buf_nr") && bufexists(t:buf_nr) && bufwinnr(t:buf_nr) != bufwinnr('%')
        silent execute bufwinnr(t:buf_nr) . 'wincmd c'
    endif

    silent execute 'vert ter node "%:p" ' . 'nodejs'
    let t:buf_nr = bufnr('%')
endfunction
