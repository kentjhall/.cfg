set number
set autoindent
set hidden
set undodir=~/.vim/undodir
set undofile
set noexpandtab
set tabstop=8 shiftwidth=8 softtabstop=0
set textwidth=80
filetype plugin indent on
syntax on

" leader is spacebar
let mapleader = " "

" restore last position in file on reopen
if has("autocmd")
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" auto close brackets
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}

" vim-plug stuff
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
so ~/.vim/plugins.vim

" NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <C-o> :NERDTreeToggle<CR>  " open and close file tree
map <leader>n :NERDTreeFind<CR>  " open current buffer in file tree
let g:NERDTreeHijackNetrw=0

" ctrl-p
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
\}
" Use the nearest .git|.svn|.hg|.bzr directory as the cwd
let g:ctrlp_working_path_mode = 'r'
" Caching to speed up search
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
nmap <leader>p :CtrlP<CR>

" YCM
let g:ycm_semantic_triggers =  {
  \   'c' : ['->', '.'],
  \   'objc' : ['->', '.'],
  \   'cpp,objcpp' : ['->', '.', '::'],
  \   'perl' : ['->'],
  \ }
let g:ycm_complete_in_comments_and_strings=1
let g:ycm_key_list_select_completion=['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion=['<C-p>', '<Up>']
let g:ycm_key_invoke_completion = '<C-x>'
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_path_to_python_interpreter = '/usr/local/bin/python3'
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_global_extra_conf.py'
let g:ycm_show_diagnostics_ui = 0
let g:ycm_confirm_extra_conf = 0
set completeopt-=preview

" Airline
let g:airline_theme = 'fruit_punch'
let g:airline#extensions#tabline#enabled = 1 " Enable the list of buffers
let g:airline#extensions#tabline#fnamemod = ':t' " Show just the filename
" -----------Buffer Management---------------
set hidden " Allow buffers to be hidden if you've modified a buffer
" Move to the next buffer
map <leader>l :bnext<CR>
" Move to the previous buffer
map <leader>h :bprevious<CR>
" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
map <leader>q :bp <BAR> bd #<CR>
" Show all open buffers and their status
map <leader>bl :ls<CR>

" Coqtail
if !has('nvim')
    " jhui colors
    function! g:CoqtailHighlight()
      hi def CoqtailChecked ctermbg=236
      hi def CoqtailSent    ctermbg=237
    endfunction
else
    let g:coqtail_nomap = 1
endif

" vim-oscyank
vnoremap <leader>c :OSCYank<CR>
