" ============================================================================
" MioVim - Configurazione Vim per JavaScript e TypeScript
" ============================================================================

" Compatibilità
set nocompatible
filetype off

" ============================================================================
" Plugin Manager - vim-plug
" ============================================================================
" Installa vim-plug automaticamente se non presente
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Core plugins
Plug 'tpope/vim-sensible'              " Configurazioni sensate di base
Plug 'scrooloose/nerdtree'             " File explorer
Plug 'jistr/vim-nerdtree-tabs'         " NERDTree tabs
Plug 'Xuyuanp/nerdtree-git-plugin'     " Git status in NERDTree

" Interfaccia e temi
Plug 'vim-airline/vim-airline'         " Status bar
Plug 'vim-airline/vim-airline-themes'  " Temi per airline
Plug 'morhetz/gruvbox'                 " Tema gruvbox
Plug 'ryanoasis/vim-devicons'          " Icone per file
Plug 'tiagofumo/vim-nerdtree-syntax-highlight' " Syntax highlighting per NERDTree

" Navigazione e ricerca
Plug 'ctrlpvim/ctrlp.vim'             " Fuzzy finder
Plug 'mileszs/ack.vim'                " Ricerca avanzata
Plug 'easymotion/vim-easymotion'      " Navigazione veloce

" Git
Plug 'tpope/vim-fugitive'             " Git wrapper
Plug 'airblade/vim-gitgutter'         " Git diff markers

" Editing utilities
Plug 'tpope/vim-surround'             " Gestione di quotes, brackets, etc.
Plug 'tpope/vim-commentary'           " Commenti intelligenti
Plug 'jiangmiao/auto-pairs'           " Auto-chiusura parentesi
Plug 'alvan/vim-closetag'             " Auto-chiusura tag HTML/JSX

" JavaScript e TypeScript
Plug 'pangloss/vim-javascript'        " Syntax highlighting JS
Plug 'leafgarland/typescript-vim'     " Syntax highlighting TS
Plug 'maxmellon/vim-jsx-pretty'       " JSX syntax highlighting
Plug 'peitalin/vim-jsx-typescript'    " TSX syntax highlighting
Plug 'jparise/vim-graphql'            " GraphQL syntax

" LSP e completamento
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Language Server Protocol
Plug 'honza/vim-snippets'             " Snippets collection

" Formattazione e linting
Plug 'prettier/vim-prettier', { 'do': 'yarn install' } " Prettier
Plug 'dense-analysis/ale'             " Linting asincrono

" Debugging
Plug 'puremourning/vimspector'        " Debugger

call plug#end()

" ============================================================================
" Configurazioni generali
" ============================================================================

" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

" Interfaccia
set number                    " Numeri di riga
set relativenumber           " Numeri relativi
set cursorline              " Evidenzia riga corrente
set showcmd                 " Mostra comandi
set showmatch               " Evidenzia parentesi corrispondenti
set ruler                   " Mostra posizione cursore
set laststatus=2            " Sempre mostra status line
set wildmenu                " Menu di completamento comandi
set wildmode=longest:full,full
set title                   " Mostra titolo nella finestra

" Colori e tema
syntax enable
set background=dark
colorscheme gruvbox
set t_Co=256
set termguicolors

" Indentazione
set autoindent
set smartindent
set cindent
set tabstop=2               " Tab = 2 spazi
set shiftwidth=2            " Indentazione = 2 spazi
set expandtab               " Usa spazi invece di tab
set smarttab

" Ricerca
set hlsearch                " Evidenzia risultati ricerca
set incsearch               " Ricerca incrementale
set ignorecase              " Ignora case
set smartcase               " Smart case sensitivity

" File handling
set autoread                " Ricarica file modificati
set hidden                  " Permette buffer nascosti
set backup
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undofile
set undodir=~/.vim/undo//

" Performance
set lazyredraw             " Non ridisegnare durante macro
set ttyfast                " Terminal veloce
set updatetime=300         " Tempo di aggiornamento più veloce

" Comportamenti
set backspace=indent,eol,start  " Backspace funziona sempre
set wrap                        " Word wrap
set linebreak                   " Break a word boundaries
set scrolloff=8                 " Mantieni 8 righe di contesto
set sidescrolloff=15           " Mantieni 15 colonne di contesto

" ============================================================================
" Configurazioni plugin specifiche
" ============================================================================

" NERDTree
let g:NERDTreeWinSize=30
let g:NERDTreeShowHidden=1
let g:NERDTreeMinimalUI=1
let g:NERDTreeDirArrows=1
let g:NERDTreeAutoDeleteBuffer=1
let g:NERDTreeQuitOnOpen=0
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }

" Airline
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#formatter='unique_tail'

" CtrlP
let g:ctrlp_working_path_mode='ra'
let g:ctrlp_show_hidden=1
let g:ctrlp_custom_ignore={
  \ 'dir':  '\v[\/](\.git|\.hg|\.svn|node_modules|dist|build)$',
  \ 'file': '\v\.(exe|so|dll|log)$',
  \ }

" ALE (Linting)
let g:ale_sign_error='✗'
let g:ale_sign_warning='⚠'
let g:ale_echo_msg_format='[%linter%] %code: %%s'
let g:ale_lint_on_text_changed='never'
let g:ale_lint_on_insert_leave=1
let g:ale_fix_on_save=1

" Linters specifici per JS/TS
let g:ale_linters={
\   'javascript': ['eslint', 'flow'],
\   'typescript': ['eslint', 'tsserver'],
\   'javascriptreact': ['eslint', 'flow'],
\   'typescriptreact': ['eslint', 'tsserver'],
\}

" Fixers per formattazione automatica
let g:ale_fixers={
\   'javascript': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\   'javascriptreact': ['prettier', 'eslint'],
\   'typescriptreact': ['prettier', 'eslint'],
\   'json': ['prettier'],
\   'css': ['prettier'],
\   'scss': ['prettier'],
\   'html': ['prettier'],
\   'markdown': ['prettier'],
\}

" Prettier
let g:prettier#autoformat=1
let g:prettier#autoformat_require_pragma=0
let g:prettier#config#single_quote='true'
let g:prettier#config#trailing_comma='es5'
let g:prettier#config#semi='false'

" Git
let g:gitgutter_enabled=1
let g:gitgutter_map_keys=0
let g:gitgutter_highlight_lines=0

" ============================================================================
" Mappature tasti
" ============================================================================

" Leader key
let mapleader=" "
let g:mapleader=" "

" Navigazione generale
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :wq<CR>
nnoremap <leader>z :q!<CR>

" Navigazione tra buffer
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprev<CR>
nnoremap <leader>bd :bdelete<CR>

" Navigazione tra split
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize split
nnoremap <leader>+ :resize +5<CR>
nnoremap <leader>- :resize -5<CR>
nnoremap <leader>> :vertical resize +5<CR>
nnoremap <leader>< :vertical resize -5<CR>

" NERDTree
nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>

" CtrlP
nnoremap <leader>p :CtrlP<CR>
nnoremap <leader>pb :CtrlPBuffer<CR>
nnoremap <leader>pm :CtrlPMRU<CR>

" Git
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gl :Gpull<CR>
nnoremap <leader>gd :Gdiff<CR>

" Ricerca
nnoremap <leader>/ :nohlsearch<CR>
nnoremap <leader>a :Ack<Space>

" Editing
nnoremap <leader>s :%s/\<<C-r><C-w>\>/
vnoremap <leader>s :s/\%V

" ============================================================================
" Autocomandi
" ============================================================================

augroup javascript_typescript
  autocmd!
  " Auto-formattazione al salvataggio
  autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx PrettierAsync
  
  " Impostazioni specifiche per JS/TS
  autocmd FileType javascript,typescript,javascriptreact,typescriptreact setlocal
    \ tabstop=2
    \ shiftwidth=2
    \ expandtab
    \ softtabstop=2
    \ foldmethod=syntax
    \ foldlevel=20
augroup END

augroup general
  autocmd!
  " Torna all'ultima posizione del cursore
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  
  " Rimuovi spazi finali al salvataggio
  autocmd BufWritePre * :%s/\s\+$//e
  
  " Crea directory se non esiste
  autocmd BufWritePre * if !isdirectory(expand("<afile>:p:h")) | call mkdir(expand("<afile>:p:h"), "p") | endif
augroup END

" ============================================================================
" Funzioni personalizzate
" ============================================================================

" Funzione per aprire terminale
function! OpenTerminal()
  split term://zsh
  resize 15
endfunction
nnoremap <leader>tt :call OpenTerminal()<CR>

" Funzione per reload configurazione
function! ReloadVimrc()
  source $MYVIMRC
  echo "Configurazione ricaricata!"
endfunction
nnoremap <leader>r :call ReloadVimrc()<CR>

" ============================================================================
" Creazione directory necessarie
" ============================================================================
if !isdirectory($HOME."/.vim/backup")
  call mkdir($HOME."/.vim/backup", "p")
endif
if !isdirectory($HOME."/.vim/swap")
  call mkdir($HOME."/.vim/swap", "p")
endif
if !isdirectory($HOME."/.vim/undo")
  call mkdir($HOME."/.vim/undo", "p")
endif

echo "MioVim caricato! Leader key: <Space>"