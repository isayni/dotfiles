"          _
"   __   _(_)_ __ ___  _ __ ___
"   \ \ / / | '_ ` _ \| '__/ __|
"    \ V /| | | | | | | | | (__
"     \_/ |_|_| |_| |_|_|  \___|
"

call plug#begin('~/.vim/plugged')
" colorschemes
Plug 'morhetz/gruvbox'
Plug 'ghifarit53/tokyonight-vim'
"
Plug 'itchyny/lightline.vim'
Plug 'ap/vim-css-color'
Plug 'alvan/vim-closetag'
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'
Plug 'sheerun/vim-polyglot'
Plug 'OmniSharp/omnisharp-vim'
Plug 'junegunn/vim-easy-align'
Plug 'maksimr/vim-jsbeautify'
Plug 'dense-analysis/ale'
Plug 'tpope/vim-fugitive'
Plug 'SirVer/ultisnips'
Plug 'lervag/vimtex'
Plug 'junegunn/goyo.vim'
Plug 'xuhdev/vim-latex-live-preview'
call plug#end()

command RC :e $MYVIMRC

filetype plugin indent on
syntax on
let mapleader=","

for f in split(globpath(expand('~/.vim/'), '*.vim'), '\n') | execute 'source ' . f | endfor

if !filereadable(expand('~/.vim/scheme.vim'))
    " SCHEME
    let g:scheme="gruvbox"
    autocmd ColorScheme * hi Normal guibg=NONE
    autocmd ColorScheme * hi Visual guibg=#161616
    autocmd ColorScheme * hi Visual guifg=#fbf1c7
    autocmd ColorScheme * hi StatusLine cterm=NONE
    autocmd ColorScheme * hi StatusLineNC cterm=NONE
    colorscheme gruvbox
    set termguicolors
    set bg=dark
    " Alacritty
    let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
    let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
    if has("gui_running")
        set guifont=Inconsolata_SemiCondensed_Mediu:h16:W500:cANSI:qDRAFT
        " gui options to set only scrollbar visible (no menu/tool bar, scrollbar)
        set guioptions=ir
        hi Cursor guifg=white
    endif
endif

set noswapfile
set wrap
set scrolloff=3
set splitright splitbelow
set noerrorbells
set shortmess=filnxtoOsc
set encoding=utf-8
set backspace=start,eol,indent
set tabstop=4 softtabstop=4 shiftwidth=4
set ttimeoutlen=0
set autoindent expandtab smartindent
set nu rnu
set linebreak
set nobackup nowritebackup
set updatetime=500
set mouse=a
set autochdir
" fix mouse issues when using Alacritty
set ttymouse=sgr

" folding
set foldmethod=indent
set foldlevel=999
noremap ` za

" highlighting search results
set hlsearch incsearch
noremap <silent> <leader>l :nohl<CR>
set smartcase

nmap j gj
nmap k gk
nnoremap Y y$

" rearrenge lines
nnoremap K :m .-2<CR>==
nnoremap J :m .+1<CR>==
vnoremap K :m '<-2<CR>gv=gv
vnoremap J :m '>+1<CR>gv=gv

" tab lines in visual mode
vmap > >gv
vmap < <gv

" map S to global replace
nnoremap S :%s///g<Left><Left><Left>

" remap ctrl+w to ctrl to switch tabs (also for terminal splits)
tnoremap <C-h> <C-w>h
noremap  <C-h> <C-w>h
tnoremap <C-j> <C-w>j
noremap  <C-j> <C-w>j
tnoremap <C-k> <C-w>k
noremap  <C-k> <C-w>k
tnoremap <C-l> <C-w>l
noremap  <C-l> <C-w>l

" tabs navigation
noremap <Leader><Tab> :tabnext<CR>
noremap <C-n> :tabnew<CR>
noremap <Leader>= :vertical resize +15<CR>
noremap <Leader>- :vertical resize -15<CR>

" Remove trailing whitespaces on save
autocmd BufWritePre * %s/\s\+$//e

nnoremap <C-f> :GFiles<CR>

au VimEnter * let g:ex_list={}
function SmartWindow(func)
    silent execute "update"

    let l:parent = bufnr('%')
    let l:file = expand('%')

    if exists("g:ex_list[l:parent]") && bufexists(g:ex_list[l:parent]) && bufwinnr(g:ex_list[l:parent]) != bufwinnr('%')
        silent execute bufwinnr(g:ex_list[l:parent]) . ' wincmd w'
        silent execute 'e!'
        silent execute 'ter ++curwin ' . a:func
    else
        silent execute 'botright vert ter ' . a:func
    endif

    let g:ex_list[l:parent] = bufnr('%')
endfunction

command -nargs=1 Rename :call Rename(<f-args>)

function Rename(t)
    let l:old = expand('%')
    silent execute "saveas " . a:t
    silent execute "!rm " . l:old
    redraw!
endfunction

" Lightline
set laststatus=2
set noshowmode
let g:lightline = {
    \ 'colorscheme' : g:scheme,
    \ 'active': {
    \   'left': [['mode'],
    \            ['gitstatus', 'filename']],
    \   'right':[['lineinfo'],
    \            ['wordcount'],
    \            ['fileformat', 'fileencoding', 'filetype']]
    \ },
    \ 'component_function': {
    \   'wordcount': 'LightlineWordCount',
    \   'gitstatus': 'LightlineGitStatus',
    \ },
    \ }
function LightlineWordCount()
    if has_key(wordcount(),'visual_words')
        let g:word_count=wordcount().visual_words."/".wordcount().words " count selected words
    else
        let g:word_count=wordcount().cursor_words."/".wordcount().words " or shows words 'so far'
    endif
    return g:word_count
endfunction

function LightlineGitStatus()
  return get(g:, 'coc_git_status', '')
endfunction

"    easy-align
vmap gs <Plug>(EasyAlign)

"    NERDTree
let NERDTreeWinSize=20
let NERDTreeShowHidden=1
noremap <Leader>f :NERDTreeToggle<CR>
" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif

"    OmniSharp
let g:OmniSharp_server_use_mono = 1

"    UltiSnips
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsExpandTrigger = '<f5>'

"    vim-latex-live-preview
let g:livepreview_previewer = 'zathura'

"    close-tag
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'
let g:closetag_filetypes = 'html,xhtml,phtml'
let g:closetag_xhtml_filetypes = 'xhtml,jsx'
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_shortcut = '>'
let g:closetag_close_shortcut = '<leader>>'
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ 'typescriptreact': 'jsxRegion,tsxRegion',
    \ 'javascriptreact': 'jsxRegion',
    \ }

"    COC
nnoremap gd :call CocActionAsync('jumpDefinition')<CR>
let g:coc_global_extensions = [
\   'coc-json',
\   'coc-clangd',
\   'coc-css',
\   'coc-cssmodules',
\   'coc-emmet',
\   'coc-git',
\   'coc-html',
\   'coc-html-css-support',
\   'coc-java',
\   'coc-jedi',
\   'coc-pairs',
\   'coc-sh',
\   'coc-tsserver',
\   'coc-xml',
\   'coc-yaml',
\   'coc-vimtex',
\   '@yaegassy/coc-ansible',
\   ]
inoremap <silent><expr> <c-@> coc#refresh()
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
let g:coc_filetype_map = {
  \ 'yaml.ansible': 'ansible',
  \ }

let g:ale_virtualtext_cursor = 'current'
