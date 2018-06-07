" .profile
" vim: si ai ft=vim:

" (c) 2018, Andres Aquino <inbox@andresaquino.sh>
" This file is licensed under the BSD License version 3 or later.
" See the LICENSE file.

" Notes
" 1- use what ever you want for indenting, but use spaces for aligning
" 2- indent !
" 3- follow the best practices for coding
"
" Links
" http://vimcasts.org/
" https://vim-bootstrap.com/
" https://medium.com/usevim
" https://vim.rtorr.com/
" https://www.cs.oberlin.edu/~kuperman/help/vim/home.html

scriptencoding utf-8

" Be iMproved
if has('vim_starting')
  set nocompatible
endif

let vimplug_exists=expand('~/.vim/autoload/plug.vim')

if !filereadable(vimplug_exists)
  if !executable("curl")
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent !\curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

" Required:
call plug#begin(expand('~/.vim/plugged'))

"" Packages
"--------------------------------------

"" LightLine
" https://github.com/itchyny/lightline.vim
" A light and configurable statusline/tabline plugin for Vim
Plug 'itchyny/lightline.vim'

"" Stellarized
" https://github.com/rafi/awesome-vim-colorschemes
" Collection of awesome color schemes for Neo/vim, merged for quick use.
Plug 'rafi/awesome-vim-colorschemes'

"" VIM Polyglot
" https://github.com/ekalinin/Dockerfile.vim
" A solid language pack for Vim.
Plug 'sheerun/vim-polyglot'

"" IndentLine
" https://github.com/Yggdroot/indentLine
" Display the indention levels with thin vertical lines
Plug 'Yggdroot/indentLine'

"" vim-autoformat
" https://github.com/chiel92/vim-autoformat
" Provide easy code formatting in Vim by integrating existing code formatters.
Plug 'chiel92/vim-autoformat'

"" Ultisnips
" https://github.com/SirVer/ultisnips
" The ultimate snippet solution for Vim.
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

"" SuperTab
" https://github.com/ervandew/supertab
" Perform all your vim insert mode completions with Tab
Plug 'ervandew/supertab'

"" VIM Commentary
" https://github.com/tpope/vim-commentary
" Comment stuff out.
" gcc to comment out a line (takes a count)
" gc to comment out the target of a motion (for example, gcap to comment out a paragraph)
" gc in visual mode to comment out the selection
" and gc in operator pending mode to target a comment.
Plug 'tpope/vim-commentary'

"" Bookmarks
" https://github.com/MattesGroeger/vim-bookmarks
" Allows toggling bookmarks per line, also quickfix window gives access to all bookmarks.
Plug 'MattesGroeger/vim-bookmarks'

"" EditorConfig
" https://github.com/editorconfig/editorconfig-vim
" EditorConfig plugin for Vim
Plug 'editorconfig/editorconfig-vim'

"" GIT Integration
" https://github.com/tpope/vim-fugitive
" a Git wrapper so awesome, it should be illegal
Plug 'tpope/vim-fugitive'

"" GIT diff in the gutter (sign column)
" https://github.com/airblade/vim-gitgutter
" A Vim plugin which shows a git diff in the 'gutter' (sign column).
" It shows which lines have been added, modified, or removed. You can also preview, stage, and undo individual hunks.
Plug 'airblade/vim-gitgutter'

"" DelimitMate
" https://github.com/Raimondi/delimitMate
" insert mode auto-completion for quotes, parens, brackets, etc.
Plug 'tpope/vim-endwise'
Plug 'Raimondi/delimitMate'

"" Braceless
" https://github.com/tweekmonster/braceless.vim/
" Text objects, folding, and more for Python and other indented languages.
Plug 'tweekmonster/braceless.vim'

"" CtrlP
" https://github.com/ctrlpvim/ctrlp.vim
" Active fork of kien/ctrlp.vim—Fuzzy file, buffer, mru, tag, etc finder
Plug 'ctrlpvim/ctrlp.vim'

"" gist-vim
" https://github.com/mattn/gist-vim
" vimscript for gist to post, read, update and delete gist of github
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'

"" Modern matchit and matchparen replacement matchit.vim
" https://github.com/andymass/vim-matchup
" match-up is a drop-in replacement for the vim plugin matchit.vim.
" match-up aims to enhance all of matchit's features, fix a number of its deficiencies
" and bugs, and add a few totally new features.
Plug 'andymass/vim-matchup'

"" Useful plugins

"" DragVisuals
" https://github.com/pablobfonseca/vim-dragvisualsG
Plug 'pablobfonseca/vim-dragvisuals'

"" VisualBlocks
" https://github.com/vim-scripts/vis
Plug 'vim-scripts/vis'

"" tables
" https://github.com/dhruvasagar/vim-table-mode
Plug 'dhruvasagar/vim-table-mode'

"" end
call plug#end()

"" VIM setup
" Encoding
set fileformats=unix,dos,mac
set encoding=utf-8
set termencoding=UTF-8
set fileencodings=utf-8
set bomb
set binary
set ttyfast
filetype plugin on
filetype indent on

" Fix backspace indent and show tab
set backspace=indent,eol,start
set listchars=tab:↦\ ,extends:#,nbsp:.
hi SpecialKey ctermfg=grey guifg=grey

" Tabs. May be overriten by autocmd rules
set softtabstop=8
set tabstop=4
set shiftwidth=4
set noexpandtab

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase
set iskeyword=a-z,A-Z,48-57,_,.,-,>,@

"" swp files
set nobackup
"set noswapfile

"" behaviour
set autowrite
set autoread
set autoindent
set smartindent
set nowrap
set noshowmode

" folding
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2

" shell
if exists('$SHELL')
  set shell=$SHELL
else
  set shell=/bin/sh
endif

"" Visual Settings
syntax enable
syntax on
set ruler
set number
set cmdheight=1

"" Passing options
set modeline
set modelines=10

set title
set titleold="Terminal"
set titlestring=%F
set colorcolumn=-1
set scrolloff=3

"" go to last line
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

"" leader key
let mapleader = ","

"" Buffers mapping
" Mappings to access buffers
" \b \f \g : go back/forward/last-used
nnoremap <Leader>l :ls<CR>
nnoremap <Leader>j :bp<CR>
nnoremap <Leader>k :bn<CR>
nnoremap <Leader>g :e#<CR>
nnoremap <Leader>d :bd<CR>
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>

"" Debug
"set verbose=14
"set verbosefile=vimdebug.log

"" Colorscheme setup
colorscheme nord
"set background=dark

"" EditorConfig
let g:EditorConfig_verbose = 0
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

"" LightLine setup
if !has('gui_running')
  set t_Co=256
endif
set laststatus=2
let g:lightline = {
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
  \   'right': [ [ 'lineinfo' ],
  \              [ 'percent' ],
  \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'fugitive#statusline'
  \ },
\}

"" Ultisnips setup
" Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

"" IntentLine setup
"let g:indentLine_color_term = 239
"let g:indentLine_bgcolor_term = 202

"" CtrlP setup
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_use_caching = 1
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_cache_dir = $HOME.'/.ctrlpcache'
let g:ctrlp_max_files = 1000
let g:ctrlp_max_history = &history
let g:ctrlp_max_depth = 10
let g:ctrlp_user_command = [
\ '.git', 'cd %s && git ls-files',
\ 'rg %s --files --color=never --glob ""',
\ 'find %s -type f'
\ ]
let g:ctrlp_custom_ignore = '\v[\/](\.git|\.hg|\.svn|\.git.*|\.git\/.*)$'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.tar.gz,*.tgz,*.tbz
nnoremap <leader>b :CtrlPBuffer<CR>

"" vim gutter setup
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '¯'
let g:gitgutter_sign_modified_removed = '_'

"" vim-gist setup
" Only :w! updates a gist.
let g:gist_update_on_write = 2

"" vim table setup
let g:table_mode_corner_corner='+'
let g:table_mode_header_fillchar='-'

"" vim bookmarks setup
let g:bookmark_sign = '›'
let g:bookmark_annotation_sign = '»'
let g:bookmark_auto_save = 1

"" DragVisuals
" Remove any introduced trailing whitespace after moving
let g:DVB_TrimWS = 1
vmap  <expr>  <S-LEFT>   DVB_Drag('left')
vmap  <expr>  <S-RIGHT>  DVB_Drag('right')
vmap  <expr>  <S-DOWN>   DVB_Drag('down')
vmap  <expr>  <S-UP>     DVB_Drag('up')


"" -
