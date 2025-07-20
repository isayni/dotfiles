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
Plug 'pearofducks/ansible-vim'
Plug 'airblade/vim-rooter'
Plug 'christoomey/vim-tmux-navigator'
call plug#end()

" BINDS
" -- normal
" leader f - toggle NERDTree
" leader r - refresh NERDTree position
" leader l - clear highlight
" leader <Tab> - switch tab
" leader -     - resize pane down
" leader =     - resize pane up
" S        - global replace
" gd       - COC jump to definition
" `        - fold
"
" Ctrl-F   - FZF git files
" -- visual
" gs - easy-align
"
" COMMANDS
" :Rg - FZF ripgrep git project
" :GBranches - FZF git branches
" :GTags - FZF git tags

command RC :e $MYVIMRC

filetype plugin indent on
syntax on
let mapleader=","

for f in split(globpath(expand('~/.vim/'), '*.vim'), '\n') | execute 'source ' . f | endfor

if !filereadable(expand('~/.vim/scheme.vim'))
    " SCHEME
    let g:scheme="gruvbox"
    " set background=light
    autocmd ColorScheme * hi Normal guibg=NONE
    autocmd ColorScheme * hi Visual guibg=#161616
    autocmd ColorScheme * hi Visual guifg=#fbf1c7
    autocmd ColorScheme * hi StatusLine cterm=NONE
    autocmd ColorScheme * hi StatusLineNC cterm=NONE
    colorscheme gruvbox
    set termguicolors
    set cursorline
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

"    Lightline
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
" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif

" Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction
" Highlight currently open buffer in NERDTree
nmap <Leader>r :call SyncTree()<CR>

function! ToggleNerdTree()
  set eventignore=BufEnter
  NERDTreeToggle
  set eventignore=
endfunction
nmap <Leader>f :call ToggleNerdTree()<CR>

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
\   'coc-snippets',
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

"    ALE
let g:ale_virtualtext_cursor = 'current'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_yaml_yamllint_options = '-c ~/.yamllint.yml'

"    WSL yank support
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
    augroup END
endif

"    FZF
" include hidden directories except .git
command! -bang -nargs=* Rg
    \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case --hidden --glob=\!.git -- ".fzf#shellescape(<q-args>), fzf#vim#with_preview(), <bang>0)

let g:fzf_colors = {
\ 'fg':      ['fg', 'Comment'],
\ 'bg':      ['bg', 'Normal'],
\ 'hl':      ['fg', 'Statement'],
\ 'fg+':     ['fg', 'Normal'],
\ 'bg+':     ['bg', 'CursorLine'],
\ 'hl+':     ['fg', 'Statement'],
\ 'info':    ['fg', 'PreProc'],
\ 'border':  ['fg', 'Normal'],
\ 'query':   ['fg', 'Normal'],
\ 'prompt':  ['fg', 'Conditional'],
\ 'pointer': ['fg', 'Exception'],
\ 'marker':  ['fg', 'Keyword'],
\ 'spinner': ['fg', 'Label'],
\ 'header':  ['fg', 'Comment'],
\ 'preview-fg':      ['fg', 'Normal'],
\ 'preview-bg':      ['bg', 'Normal'] }

let g:fzf_action = {
  \ 'ctrl-i': 'split',
  \ 'ctrl-s': 'vsplit' }

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
