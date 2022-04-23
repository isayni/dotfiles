function PasteImage()
    call system('mkdir -p pics')
    let filename = split(system('echo pics/$(date +%F_%T).png'), '\n')[0]
    echo filename
    call system('xclip -selection clipboard -t image/png -o > ' . filename . ' || rm ' . filename)

    if !filereadable(filename)
        return
    endif

    let insert = [
    \   '\begin{center}'
    \ , '\includegraphics[width=\textwidth]{' . filename . '}'
    \ , '\end{center}'
    \ , '']

    call append(line('.'), insert)
    norm 4j
    redraw!
endfunction

nnoremap <C-v> :call PasteImage()<CR>
