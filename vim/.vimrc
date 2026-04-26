" General Settings
set nocompatible              " Disable Vi compatibility
syntax on                     " Enable syntax highlighting
" filetype plugin indent on     " Enable filetype detection, plugins and indenting

" Tabs & Indentation
set tabstop=2                 " Number of spaces that a <Tab> in the file counts for
set shiftwidth=2              " Number of spaces to use for each step of (auto)indent
set softtabstop=2             " Number of spaces that a <Tab> counts for while performing editing operations
set expandtab                 " Use spaces instead of tabs
set smartindent               " Smart indentation
set autoindent                " Copy indent from current line when starting a new line

" Line Numbers
set number                    " Show absolute line number
set relativenumber            " Show relative line numbers

" Search Settings
set ignorecase                " Ignore case when searching
set smartcase                 " But don't ignore case if search pattern has uppercase
set incsearch                 " Show matches while typing
set hlsearch                  " Highlight all matches

" Interface
set ruler                     " Show cursor position
set showcmd                   " Show (partial) command in status line
set wildmenu                  " Enhanced command line completion
set lazyredraw                " Don't redraw while executing macros
set showmatch                 " Show matching brackets

" Show Tabs & Whitespace
set list                      " Show invisible characters
set listchars=tab:→\ ,trail:·,extends:›,precedes:‹,nbsp:␣  " Define how to show tabs and spaces

" Encoding
set encoding=utf-8
set fileencoding=utf-8

" Clipboard (for Linux - requires +clipboard support)
set clipboard=unnamedplus     " Use system clipboard

" Tab Bar Settings
set showtabline=2             " Always show tab bar (0=never, 1=only if there are at least two tabs, 2=always)
set tabpagemax=15             " Maximum number of tab pages to open

" Set mouse
set mouse=a
