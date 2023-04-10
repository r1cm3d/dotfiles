filetype plugin indent on
syntax on
set background=dark
colorscheme PaperColor
set softtabstop=8
set tabstop=8
set shiftwidth=8
set backspace=indent,eol,start
set showcmd
set ruler
set relativenumber
set ignorecase
set smartcase
set incsearch
"set hlsearch
set expandtab
set scrolloff=3
set wildmenu
set encoding=utf8
set ai
set si
set autowrite

au FileType go nmap <F5> :DlvToggleBreakpoint<CR>
au FileType go nmap <F6> :DlvTestCurrent<CR>
nmap <leader>nt :NERDTreeToggle<CR>
nmap <leader>ntf :NERDTreeFind<CR>
nmap <C-F>f <Plug>CtrlSFPrompt
nmap <C-w>t :below terminal<CR>
nnoremap <Leader>gb :<C-u>call gitblame#echo()<CR>

" Common Go commands
"au FileType go nmap <leader>r <Plug>(go-run)
"au FileType go nmap <leader>t <Plug>(go-test)
"au FileType go nmap <leader>c <Plug>(go-coverage-toggle)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>tf <Plug>(go-test-func)
au FileType go nmap <Leader>ren <Plug>(go-rename)
au FileType go nmap <Leader>r <Plug>(go-referrers)
au FileType go nmap <Leader>f <Plug>(go-fmt)
au FileType go nmap <Leader>i <Plug>(go-implements)
au FileType go nmap <Leader>inf <Plug>(go-info)
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>ae <Plug>(go-alternate-edit)
au FileType go nmap <Leader>av <Plug>(go-alternate-vertical)

" Popup windows for Go documentation
let g:go_doc_popup_window = 1

" Enable lsp for Go by using gopls
let g:completor_filetype_map = {}
let g:completor_filetype_map.go = {'ft': 'lsp', 'cmd': 'gopls - remote=auto'}"
