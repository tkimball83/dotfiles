" .vimrc

function! s:StripTrailingWhitespace() abort
  let l:view = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:view)
endfunction

augroup strip_trailing_whitespace
  autocmd!
  autocmd BufWritePre * call s:StripTrailingWhitespace()
augroup END

filetype plugin indent on
set autoread
set clipboard=
set cursorline
set expandtab
set nobackup
set noswapfile
set nowritebackup
set number
set ruler
set scrolloff=5
set shiftwidth=2
set showcmd
set showmatch
set showmode
set smarttab
set tabstop=2
set visualbell
set viminfo=
syntax on
