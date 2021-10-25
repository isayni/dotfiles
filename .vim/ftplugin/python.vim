"   python execution and output to a reusable buffer window
nnoremap <silent> <F5> :call ExecutePython()<CR>
"vnoremap <silent> <F5> :<C-u>call ExecutePython()<CR>

function ExecutePython()
    " save current file
    silent execute "update"
    " execute script and save output to the @o registry
    let @o=system("python " . shellescape(expand('%:p')))
    " get file path of current file
    let s:current_buffer_file_path = expand("%")

    let s:output_buffer_name = "Python"
    let s:output_buffer_filetype = "output"

    " reuse existing buffer window if it exists otherwise create a new one
    " vertically
    if !exists("s:buf_nr") || !bufexists(s:buf_nr)
        silent execute 'botright vnew ' . s:output_buffer_name
        let s:buf_nr = bufnr('%')
    elseif bufwinnr(s:buf_nr) == -1
        silent execute 'botright vnew'
        silent execute s:buf_nr . 'buffer'
    elseif bufwinnr(s:buf_nr) != bufwinnr('%')
        silent execute bufwinnr(s:buf_nr) . 'wincmd w'
    endif

    "silent execute "setlocal filetype=" . s:output_buffer_filetype
    setlocal bufhidden=delete
    setlocal noswapfile
    setlocal winfixheight
    setlocal nobuflisted
    setlocal nonumber
    setlocal norelativenumber
    setlocal showbreak=""

    " clear the buffer
    setlocal noreadonly
    setlocal modifiable
    %delete _

    " add the console output
    silent execute ".!python " . shellescape(s:current_buffer_file_path , 1)
    "read !python \#:p
    "norm ggVG<Esc>d"opggdd
    "
endfunction
