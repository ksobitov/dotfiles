let mapleader = "\<Space>"

" Enable line numbers
set number

set relativenumber

" Enable syntax highlighting
syntax enable

" Enable mouse support
set mouse=a

" Paste enable
set paste

" Auto-indentation
" set autoindent

" Enable smart indenting
set smartindent

" Highlight search results as you type
set incsearch

" Enable case-insensitive search
set ignorecase
set smartcase

" Fix for pasting in tmux
set clipboard=unnamedplus

" Enable line wrapping
set wrap

" Set the background color to dark (useful for dark themes)
set background=dark

" Enable persistent undo history
set undofile
set undodir=~/.vim/undo

" Enable 256-color terminal support
set t_Co=256

" Use case-insensitive searching
set ignorecase
set smartcase

" Automatically re-read the file if it changes outside Vim
set autoread

" Set tabstop to 2 spaces
set tabstop=2

" Set shiftwidth to 2 spaces
set shiftwidth=2

" Set soft tabstop to 2 spaces
set softtabstop=2

" Autocompletion for command-line mode
set wildmenu

" Indentation and formatting for YAML files
au FileType yaml setlocal ai ts=2 sw=2 et

" Auto-reloading of changes in vimrc
augroup vimrc
  autocmd!
  autocmd BufWritePost .vimrc source %
augroup END

" Useful status line with file path, Git branch, and more
set statusline=%F%m%r%h%w\ [%L,%v][%p%%]\ [%b]

" Integration with Git for displaying Git status
let &background = "dark"
autocmd BufRead,BufNewFile * if getline(1) =~ '^<<<<<<< ' | set ft=gitmerge | endif

" Quickly toggle line numbers with a key mapping
nnoremap <leader>n :set invnumber<CR>

" Custom keybindings for common tasks
map <leader>w :w<CR>
map <leader>q :q<CR>
map <leader>bd :bd<CR>
map <leader>o :only<CR>
map <leader>s :vsp<CR>
map <leader>vs :vsplit<CR>
map <leader>sp :split<CR>
map <leader>q :q<CR>
map <leader>qa :qa<CR>

" Use Ctrl+A to select all in visual mode
vnoremap <C-a> <Esc>ggVG

" Map ; to : (for quicker command entering)
nnoremap ; :

" Toggle line wrapping
nnoremap <leader>tw :set wrap!<CR>
