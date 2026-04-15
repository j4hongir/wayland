set number
set relativenumber
set cursorline
set scrolloff=8
set sidescrolloff=8
set hlsearch
set incsearch
set ignorecase
set smartcase
set autoindent
set smartindent
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set clipboard=unnamedplus
syntax enable

nnoremap <Esc>s :w<CR>
nnoremap <Esc>q :q<CR>
nnoremap <Esc>k :wq<CR>
nnoremap <Esc>d :q!<CR>
nnoremap <Esc>o o<Esc>
nnoremap <Esc>O O<Esc>
nnoremap <Esc>l `.

nnoremap <Esc>[1;3A :m .-2<CR>==
nnoremap <Esc>[1;3B :m .+1<CR>==

nnoremap <Esc>ws :split<CR>
nnoremap <Esc>wv :vsplit<CR>
nnoremap <Esc>wh <C-w>h
nnoremap <Esc>wj <C-w>j
nnoremap <Esc>wk <C-w>k
nnoremap <Esc>wl <C-w>l
nnoremap <Esc>wc <C-w>c
nnoremap <Esc>w= <C-w>=
nnoremap <Esc>wo <C-w>o
nnoremap <Esc>w+ <C-w>+
nnoremap <Esc>w- <C-w>-

inoremap <Esc><Space> <Esc>
inoremap { {}<Left>
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap ' ''<Left>
inoremap " ""<Left>

vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
xnoremap <Esc>[1;3A :m '<-2<CR>gv=gv
xnoremap <Esc>[1;3B :m '>+1<CR>gv=gv

nnoremap d "_d
nnoremap dd "_dd
nnoremap x "_x
xnoremap d "_d
