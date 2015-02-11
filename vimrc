" ---------------------------------------------------------------------------
" Fichier .vimrc pour vim
" (C) Laurent (laurent@bewie.org)
"
" General
" ---------------------------------------------------------------------------

set nocompatible " essential
set history=1000 " lots of command line history
set cf " error files / jumping
set ffs=unix,dos,mac " support these files
filetype on
filetype plugin indent on " load filetype plugin
set isk+=_,$,@,%,#,- " none word dividers
set viminfo='1000,f1,:100,@100,/20
set modeline " make sure modeline support is enabled
set autoread " reload files (no local changes only)
set tabpagemax=50 " open 50 tabs max

" Fugitive config
set laststatus=2
set statusline=[%l,%v\ %P%M]\ %f\ %r%h%w\ (%{&ff})\ %{fugitive#statusline()}


" ---------------------------------------------------------------------------
" Colors / Theme
" ---------------------------------------------------------------------------

if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  colorscheme mustang
endif

" ---------------------------------------------------------------------------
" Highlight
" ---------------------------------------------------------------------------

highlight Comment ctermfg=DarkGrey guifg=#444444
highlight StatusLineNC ctermfg=Black ctermbg=DarkGrey cterm=bold
highlight StatusLine ctermbg=Black ctermfg=LightGrey
highlight LineNr ctermfg=Blue ctermbg=Black

" ----------------------------------------------------------------------------
" Highlight Trailing Whitespace
" ----------------------------------------------------------------------------

"set list listchars=trail:.,tab:>.
highlight SpecialKey ctermfg=DarkGray ctermbg=Black

" ----------------------------------------------------------------------------
" Backups
" ----------------------------------------------------------------------------

set nobackup " do not keep backups after close
set nowritebackup " do not keep a backup while working
set noswapfile " don't keep swp files either
set backupdir=$HOME/.vim/backup " store backups under ~/.vim/backup
set backupcopy=yes " keep attributes of original file
set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*
set directory=~/.vim/swap,~/tmp,. " keep swp files under ~/.vim/swap

" ----------------------------------------------------------------------------
" UI
" ----------------------------------------------------------------------------

set ruler " show the cursor position all the time
set noshowcmd " don't display incomplete commands
set nolazyredraw " turn off lazy redraw
set number " line numbers
set wildmenu " turn on wild menu
set wildmode=list:longest,full
set ch=2 " command line height
set backspace=2 " allow backspacing over everything in insert mode
"set whichwrap+=<,>,h,l,[,] " backspace and cursor keys wrap to
set shortmess=filtIoOA " shorten messages
set report=0 " tell us about changes
set nostartofline " don't jump to the start of line when scrolling
set title
set cursorline

" ----------------------------------------------------------------------------
" Visual Cues
" ----------------------------------------------------------------------------

set showmatch " brackets/braces that is
set showmode  " Show current mode
set mat=5 " duration to show matching brace (1/10 sec)
set incsearch " do incremental searching
set laststatus=2 " always show the status line
set ignorecase " ignore case when searching
set hlsearch " highlight searches
set visualbell " shut the fuck up

" ----------------------------------------------------------------------------
" Text Formatting
" ----------------------------------------------------------------------------

set autoindent " automatic indent new lines
"set smartindent " be smart about it
"set nowrap " do not wrap lines
set shiftwidth=4 " ..
set softtabstop=4 " yep, two
set tabstop=2
set expandtab " expand tabs to spaces
set smarttab "
set virtualedit=block " allow virtual edit in visual block ..
"set formatoptions+=n " support for numbered/bullet lists
"set textwidth=80 

" ---------------------------------------------------------------------------
" ENCODING SETTINGS
" ---------------------------------------------------------------------------
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8

" ----------------------------------------------------------------------------
" Mappings
" ----------------------------------------------------------------------------

" remap <LEADER> to ',' (instead of '\')
let mapleader = ","

" quickfix mappings
map <F7> :cn<CR>
map <S-F7> :cp<CR>
map <A-F7> :copen<CR>

" emacs movement keybindings in insert mode
imap <C-a> <C-o>0
imap <C-e> <C-o>$
map <C-e> $
map <C-a> 0

" reflow paragraph with Q in normal and visual mode
nnoremap Q gqap
vnoremap Q gq

" sane movement with wrap turned on
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" do not menu with left / right in command line
cnoremap <Left> <Space><BS><Left>
cnoremap <Right> <Space><BS><Right>

" gundo mapping
map <C-u> <Esc>:GundoToggle<CR>
" Tasklist
map <C-T> <Plug>TaskList

" ----------------------------------------------------------------------------
" Auto Commands
" ----------------------------------------------------------------------------

" jump to last position of buffer when opening
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |
                         \ exe "normal g'\"" | endif

" don't use cindent for javascript
autocmd FileType javascript setlocal nocindent

" ----------------------------------------------------------------------------
" PATH on MacOS X
" ----------------------------------------------------------------------------

if system('uname') =~ 'Darwin'
  let $PATH = $HOME .
    \ '/usr/local/bin:/usr/local/sbin:' .
    \ '/usr/pkg/bin:' .
    \ '/opt/local/bin:/opt/local/sbin:' .
    \ $PATH
endif

" ---------------------------------------------------------------------------
" sh config
" ---------------------------------------------------------------------------

au Filetype sh,bash set ts=4 sts=4 sw=4 expandtab
let g:is_bash = 1

" ---------------------------------------------------------------------------
" Misc mappings
" ---------------------------------------------------------------------------

" duplicate current tab with same file+line
map ,t :tabnew %<CR>

" open directory dirname of current file, and in new tab
map ,d :e %:h/<CR>
map ,dt :tabnew %:h/<CR>

" open gf under cursor in new tab
map ,f :tabnew <cfile><CR>

" I use these commands in my TODO file
map ,a o<ESC>:r!date +'\%A, \%B \%d, \%Y'<CR>:r!date +'\%A, \%B \%d, \%Y' \| sed 's/./-/g'<CR>A<CR><ESC>
map ,o o[ ]
map ,O O[ ]
map ,x :s/^\[ \]/[x]/<CR>
map ,X :s/^\[x\]/[ ]/<CR>

" ---------------------------------------------------------------------------
" Open URL on current line in browser
" ---------------------------------------------------------------------------

function! Browser ()
    let line0 = getline (".")
    let line = matchstr (line0, "http[^ )]*")
    let line = escape (line, "#?&;|%")
    exec ':silent !open ' . "\"" . line . "\""
endfunction
map ,w :call Browser ()<CR>

" ---------------------------------------------------------------------------
" Strip all trailing whitespace in file
" ---------------------------------------------------------------------------

function! StripWhitespace ()
    exec ':%s/ \+$//gc'
endfunction
map ,s :call StripWhitespace ()<CR>

" ---------------------------------------------------------------------------
" File Types
" ---------------------------------------------------------------------------

au BufRead,BufNewFile *.rpdf set ft=ruby
au BufRead,BufNewFile *.rxls set ft=ruby
au BufRead,BufNewFile *.ru set ft=ruby
au BufRead,BufNewFile *.god set ft=ruby
au BufRead,BufNewFile *.rtxt set ft=html spell


" --------------------------------------------------------------------------
" ManPageView
" --------------------------------------------------------------------------

let g:manpageview_pgm= 'man -P "/usr/bin/less -is"'
let $MANPAGER = '/usr/bin/less -is'

" make file executable
command -nargs=* Xe !chmod +x <args>
command! -nargs=0 Xe !chmod +x %

" --------------------------------------------------------------------------
" Pathogen load
" --------------------------------------------------------------------------
call pathogen#runtime_append_all_bundles()
call pathogen#infect()
call pathogen#helptags()
