" SCHEME
let g:scheme="gruvbox"
colorscheme gruvbox
if has("gui_running")
    set guifont=Inconsolata_SemiCondensed_Mediu:h16:W500:cANSI:qDRAFT
    " gui options to set only scrollbar visible (no menu/tool bar, scrollbar)
    set guioptions=ir
    hi Cursor guifg=white
endif
set termguicolors
set bg=dark
let g:tokyonight_style = 'night'
let g:tokyonight_enable_italic = 1
hi Normal guibg = NONE
hi Visual guibg =#161616
hi Visual guifg =#fbf1c7
set cursorline
hi CursorLine cterm=NONE guibg=NONE
" Alacritty
let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
