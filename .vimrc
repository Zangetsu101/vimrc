""""""""""""""""""""""""""""""""""""CopyToClipboard""""""""""""""""""""""""""""""""""""

"WSL yank support
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
    augroup WSLYank
        autocmd!
		autocmd TextYankPost * if v:event.operator ==# 'y' && v:event.regname ==# '' | call system('cat |' . s:clip, @0) | endif
    augroup END
endif

""""""""""""""""""""""""""""""""""""CopyToClipboard""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""KeyMaps""""""""""""""""""""""""""""""""""""

let mapleader = " "

nnoremap <Leader>t :NERDTreeToggle<cr>

" move lines up or down for vim-move
execute "set <M-j>=\ej"
execute "set <M-k>=\ek"
execute "set <M-h>=\eh"
execute "set <M-l>=\el"

""""""""""""""""""""""""""""""""""""KeyMaps""""""""""""""""""""""""""""""""""""

set number relativenumber

set nocompatible

set noshowmode

set splitbelow
set splitright

syntax on

filetype plugin on

set path+=**

set wildmenu

set wildignore+=**/node_modules/**

set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set nowrap
set smartcase
set incsearch

""""""""""""""""""""""""""""""""""""Plugins""""""""""""""""""""""""""""""""""""

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'sheerun/vim-polyglot'
Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'preservim/nerdtree'
Plug 'jiangmiao/auto-pairs'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'matze/vim-move'

call plug#end()

""""""""""""""""""""""""""""""""""""Plugins""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""ColorScheme""""""""""""""""""""""""""""""""""""

autocmd vimenter * ++nested colorscheme gruvbox
set background=dark

""""""""""""""""""""""""""""""""""""ColorScheme""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""StatusLine""""""""""""""""""""""""""""""""""""

set laststatus=2

let g:lightline = {
	\ 'active': {
	\   'left': [ 
	\ 		[ 'mode', 'paste' ],
	\		  [ 'gitbranch','gitstatus', 'cocstatus', 'readonly', 'filename', 'modified' ], 
	\ 	],
	\ 	'right':[
	\		  [ 'filetype', 'fileencoding', 'lineinfo', 'percent' ],
	\   ],
	\ },
	\ 'component_function': {
	\   'gitbranch': 'FugitiveStatusline',
	\	  'cocstatus': 'coc#status',
  \   'gitstatus': 'GitStatus',
	\ },
	\ }

" Use autocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

function! GitStatus()
  let [a,m,r] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', a, m, r)
endfunction

""""""""""""""""""""""""""""""""""""StatusLine""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""Cursor""""""""""""""""""""""""""""""""""""
" Cursor in terminal
" https://vim.fandom.com/wiki/Configuring_the_cursor
" 1 or 0 -> blinking block
" 2 solid block
" 3 -> blinking underscore
" 4 solid underscore
" Recent versions of xterm (282 or above) also support
" 5 -> blinking vertical bar
" 6 -> solid vertical bar
    
if &term =~ '^xterm'
	" normal mode
	let &t_EI .= "\<Esc>[0 q"
	" insert mode
	let &t_SI .= "\<Esc>[5 q"
	" replace mode
	let &t_SR .= "\<Esc>[4 q"
endif

""""""""""""""""""""""""""""""""""""Cursor""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""Coc""""""""""""""""""""""""""""""""""""

" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

let g:coc_filetype_map = {'javascript': 'javascriptreact'}
let g:coc_global_extensions = ['coc-json', 'coc-prettier', 'coc-clangd',
	\	'coc-tsserver', 'coc-tailwindcss', 'coc-eslint']

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
" if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  " set signcolumn=number
" else
set signcolumn=yes
" endif

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Show all diagnostics.
nnoremap <silent><nowait> <leader>d  :<C-u>CocList diagnostics<cr>

""""""""""""""""""""""""""""""""""""Coc""""""""""""""""""""""""""""""""""""
