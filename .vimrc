call plug#begin('~/.vim/plugged')
" colorschemes
Plug 'gruvbox-community/gruvbox'
Plug 'ghifarit53/tokyonight-vim'
"
Plug 'itchyny/lightline.vim'
Plug 'ap/vim-css-color'
Plug 'alvan/vim-closetag'
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug 'OmniSharp/omnisharp-vim'
Plug 'junegunn/vim-easy-align'
call plug#end()

command RC :e $MYVIMRC

filetype plugin indent on
syntax on
let mapleader=","

if has("gui_running")
    set guifont=Inconsolata_SemiCondensed_Mediu:h16:W500:cANSI:qDRAFT
    " gui options to set only scrollbar visible (no menu/tool bar, scrollbar)
    set guioptions=ir
    hi Cursor guifg=white
endif

" fix mouse issues when using Alacritty
set ttymouse=sgr

" Lightline
set laststatus=2
set noshowmode
let g:lightline = {'colorscheme' : 'gruvbox'}

" SCHEME
set termguicolors
let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
set bg=dark
let g:tokyonight_style = 'night'
let g:tokyonight_enable_italic = 1
colorscheme gruvbox
" Transparent background
hi Normal guibg = NONE
hi Visual guibg =#ffffff
set cursorline
hi CursorLine cterm=NONE guibg=NONE

" Remove trailing whitespaces on save
autocmd BufWritePre * %s/\s\+$//e

" Automatically change vim current directory to the opened file
autocmd BufEnter * silent! lcd %:p:h<CR>:pwd<CR>

" folding
set foldmethod=indent
set foldlevel=999
noremap ` za

" NERDTree
let NERDTreeWinSize=20
let NERDTreeShowHidden=1
nmap <C-f> :NERDTreeToggle<CR>
" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" map S to global replace
nmap S :%s///g<Left><Left><Left>

" tab lines in visual mode
vmap <Tab> >gv
vmap <S-Tab> <gv

" rearrenge lines
nnoremap K :m .-2<CR>==
nnoremap J :m .+1<CR>==

" highlighting search results
set hlsearch incsearch
noremap <silent> <leader>l :nohl<CR>
set smartcase

" remap ctrl+w to ctrl to switch tabs (also for terminal splits)
tnoremap <C-h> <C-w>h
noremap <C-h> <C-w>h
tnoremap <C-j> <C-w>j
noremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
noremap <C-k> <C-w>k
tnoremap <C-l> <C-w>l
noremap <C-l> <C-w>l

nmap j gj
nmap k gk

set clipboard=unnamedplus
set noswapfile
set wrap
set scrolloff=3
set splitright splitbelow
set noerrorbells
set shortmess=filnxtoOsc
set encoding=utf-8
set backspace=start,eol,indent
set tabstop=4 softtabstop=4 shiftwidth=4
set autoindent expandtab smartindent
set nu rnu
set linebreak
set nobackup nowritebackup
set updatetime=500
set mouse=a
set autochdir

" easy-align
xmap gs <Plug>(EasyAlign)
nmap gs <Plug>(EasyAlign)

let g:OmniSharp_server_use_mono = 1

"   close-tag
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
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
