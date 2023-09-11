" ---------------------------------------------------------
" --               vim config by Anapal                  --
" --     My personal config for my (or your) needs.      --
" --                                                     --
" --      > https://github.com/AnapalOne/dotfiles        --
" ---------------------------------------------------------

" ------------------- Configs ------------------- 
set nocompatible 
set number
set wrap
set nobackup
set nowritebackup
set noswapfile 
set ruler
set showcmd 
set autoread
set autowrite 
set hidden
set nocursorcolumn
set nocursorline
set encoding=utf-8
set termguicolors

" // Is enabled by default by plug#end()
syntax enable
filetype plugin indent on

" // nerdtree plugin configs
let g:NERDTreeWinSize=50
let g:NERDTreeWinPos="right"
let g:NERDTreeMouseMode=3
let g:NERDTreeShowHidden=1
let g:NERDTreeDirArrows=1

" // indenting
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" // color themes
let g:airline_theme='catppuccin_frappe'
colorscheme catppuccin_frappe
" disable background color
hi Normal guibg=NONE ctermbg=NONE 

" // vim-airline
let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts = 1

set fillchars-=vert:\| | set fillchars+=vert:\  " replace '|' in tab separation with a whitespace


" ------------------- Autostart Commands -------------------
autocmd VimEnter * NERDTree | wincmd p

" close vim when nerdtree is the only window
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" auto-install vim-plug if not installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif



" ------------------- Plugins ------------------- 
call plug#begin()

    " Start with [Plug] and then the plugin name to install plugins
    Plug 'preservim/nerdtree'
    Plug 'mg979/vim-visual-multi'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'ryanoasis/vim-devicons'
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    Plug 'nordtheme/vim', { 'as' : 'nord' }
    Plug 'catppuccin/vim', { 'as': 'catppuccin' }

call plug#end()


" ------------------- Keybindings -------------------
" tab movement
nnoremap <C-Left> <C-w>h
nnoremap <C-Right> <C-w>l
nnoremap <Esc>[1;3C :bnext<CR>
nnoremap <Esc>[1;3D :bprevious<CR>

" nerdtree
nnoremap <C-b> :NERDTreeToggle<CR>


" ------------------- Other -------------------
