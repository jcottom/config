" =============================================================================
" # general
" =============================================================================
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set scrolloff=3
set linebreak
filetype on
filetype plugin indent on
syntax on
set splitright
set nofixendofline
let mapleader = "\<Space>"
set statusline=%<%f\ %h%m%r%{FugitiveStatusline()}%=%-14.(%l,%c%V%)\ %P

" completion
set completeopt=menuone,noinsert,noselect
set wildcharm=<tab>
set wildmode=longest:full,full " more familiar tab-completion style

" smarter search
set ignorecase
set smartcase

" persistent undo
set undodir=~/.vimdid
set undofile

" =============================================================================
" # language-specific
" =============================================================================

autocmd BufRead,BufNewFile Jenkinsfile set filetype=groovy

" =============================================================================
" # plugins
" =============================================================================
call plug#begin()
" colorscheme
Plug 'chriskempson/base16-vim'

" usage
Plug 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = "<c-n>"
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
let g:fzf_buffers_jump = 1

Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
autocmd BufReadPost * GitGutterBufferEnable

" python
Plug 'vim-scripts/indentpython.vim'
Plug 'psf/black' " formatting
Plug 'davidhalter/jedi-vim' " python lsp
let g:python3_host_prog = "~/repos/neovim/.venv/bin/python3"

" send text to any REPL
Plug 'jpalardy/vim-slime'
let g:slime_target = "tmux"
let g:slime_python_ipython = 1

" replace less as pager for man, git, etc.
Plug 'lambdalisue/vim-pager'
Plug 'lambdalisue/vim-manpager'
Plug 'powerman/vim-plugin-AnsiEsc'

" fuzzy finder
Plug 'airblade/vim-rooter'
let g:rooter_patterns = ['.git']
call plug#end()

" =============================================================================
" # color and highlighting
" =============================================================================
" use base16-shell-provided colorscheme
" change theme with `base16_*` shell aliases
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" brighter, fancier comments
highlight Comment cterm=italic
call Base16hi("Comment", g:base16_gui09, "", g:base16_cterm09, "", "", "")

" brighter text for unchanged parts of diff lines
highlight DiffChange ctermfg=20 guifg=20

" =============================================================================
" # key-mappings
" =============================================================================

" move by line
nnoremap j gj
nnoremap k gk

" very magic by default
nnoremap ? ?\v
nnoremap / /\v
"cnoremap %s/ %sm/
cnoremap %s/ %s/\v

" open new file adjacent to current file
nnoremap <leader>o :e <C-R>=expand("%:p:h") . "/" <CR>

" <leader><leader> toggles between buffers
nnoremap <leader><leader> <c-^>

" search for word under cursor
"nnoremap <leader>s :Rg <C-R>=expand("<cword>")<CR><CR>
"nnoremap <leader>S :Rg <C-R>=expand("<cWORD>")<CR><CR>

" file search
if executable('rg')
	set grepprg=rg\ --no-heading\ --vimgrep
	set grepformat=%f:%l:%c:%m
endif

" show open buffers in wildmenu
nnoremap <leader><tab> :Buffers<cr>

" toggle gutter and linenumbers
nnoremap <leader>g :set nu!<cr>:GitGutterBufferToggle<cr>
