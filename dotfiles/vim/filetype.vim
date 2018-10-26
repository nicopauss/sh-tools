if exists("did_load_filetypes")
    finish
endif

" C/C++
au FileType c,cpp setlocal noignorecase textwidth=78
au BufRead,BufNewFile *.blk,*.fc,*.h setf c
au BufRead,BufNewFile *.blkk,*.hpp setf cpp

let c_gnu=1
let c_space_errors=1
let c_no_curly_errors=1

" IOP
au FileType d setlocal noignorecase textwidth=78
au BufRead,BufNewFile *.iop setf d

" Javascript
au FileType javascript setlocal cindent cinoptions-=L0.5s noignorecase textwidth=78 iskeyword+=$

" PHP
au FileType php setlocal et fo+=ro indentexpr= cin
let php_noShortTags=1
autocmd BufEnter *.php :syntax sync fromstart

" Syntax highlighting for LESS files
au BufRead,BufNewFile *.less setf css

" Html
au FileType html setlocal tabstop=2 softtabstop=2 shiftwidth=2

" Smarty
au FileType smarty setlocal tabstop=2 softtabstop=2 shiftwidth=2

" Python
au FileType python setlocal textwidth=78
au BufRead,BufNewFile wscript* setf python
let python_highlight_all=1

" Snippets
au FileType snippets setlocal expandtab

" Json
au FileType json setlocal textwidth=78 fo=croql

" Shell
let g:is_bash=1

" Diff
au FileType diff setlocal nofoldenable

" Asciidoc
au FileType asciidoc setlocal spell spelllang=en_us
au BufRead,BufNewFile *.adoc setf asciidoc

" Git commit message
let git_diff_spawn_mode=2
au FileType gitcommit setlocal spell spelllang=en_us
au BufNewFile,BufRead *.git/config,*/.git/config,.gitconfig setf dosini

" Cython
au FileType pyrex setlocal textwidth=78
