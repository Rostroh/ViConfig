syntax on
set nu
set mouse=a

" NERDTree: reasonable defaults from webinstall.dev/vim-nerdtree
source ~/.vim/plugins/nerdtree.vim

autocmd VimEnter * NERDTree | wincmd p

"mapping buffer shortcut
nnoremap <Esc>[1;2D <C-w>h
nnoremap <Esc>[1;2C <C-w>l
nnoremap <Esc>[1;2A <C-w>k 
nnoremap <Esc>[1;2B <C-w>j

"mapping term buffer shortcut
tnoremap <Esc>[1;2D <C-\><C-n><C-w>h  
tnoremap <Esc>[1;2C <C-\><C-n><C-w>l
tnoremap <Esc>[1;2A <C-\><C-n><C-w>k 
tnoremap <Esc>[1;2B <C-\><C-n><C-w>j

let g:term_win = -1

function! OpenTerminalSplit()
	if g:term_win == -1 || !winbufnr(g:term_win)
		"let t:terminal_opened = 1
		"botright 10split
		echom "Creat term"
		botright terminal
		resize 25
		let g:term_win = winnr()
		let g:term_buf = bufnr('%') 
		wincmd k 
	endif
endfunction

function! SendToTerm()
	if bufexists(g:term_win)
		call term_sendkeys(g:term_buf, "exit\<CR>")
	endif
endfunction

function! s:TermInsert(_)
	if &buftype ==# 'terminal' && mode() !=# 't'
		call feedkeys('i', 'n')
	endif
endfunction

augroup RunAndQuit
	autocmd!
	autocmd BufWinEnter *.c,*.py call OpenTerminalSplit()
	autocmd BufWinLeave *.c,*.py call SendToTerm()
augroup END

augroup TerminalInsert
	autocmd!
	autocmd BufWinEnter,WinEnter * call timer_start(0, function('s:TermInsert'))
	"autocmd BufWinEnter,WinEnter * if &buftype ==# 'terminal' | startinsert | endif
augroup END
