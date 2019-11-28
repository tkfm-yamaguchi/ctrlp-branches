" =============================================================================
" File:          autoload/ctrlp/branches.vim
" Description:   Git branch finder
" Author:        Kristian Freeman (@imkmf)
" =============================================================================

" To load this extension into ctrlp, add this to your vimrc:
"
"     let g:ctrlp_extensions = ['branches']

if ( exists('g:loaded_ctrlp_branches') && g:loaded_ctrlp_branches )
  \ || v:version < 700 || &cp
  finish
endif
let g:loaded_ctrlp_branches = 1

call add(g:ctrlp_ext_vars, {
  \ 'init': 'ctrlp#branches#init()',
  \ 'accept': 'ctrlp#branches#accept',
  \ 'lname': 'git branches',
  \ 'sname': 'branches',
  \ 'type': 'line',
  \ 'exit': 'ctrlp#branches#exit()',
  \ })

function! ctrlp#branches#init()
  if !ctrlp#branches#is_git_repository()
    return []
  endif

  " Git branches without formatting
  let input = system("git for-each-ref --format='%(refname:short)' refs/heads/")
  let branches = split(input, '\n')
  return branches
endfunction

function! ctrlp#branches#accept(mode, str)
  call system("git checkout " . a:str)
  call ctrlp#exit()
endfunction

function! ctrlp#branches#exit()
  " noop
endfunction

" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

" Allow it to be called later
function! ctrlp#branches#id()
  return s:id
endfunction

function! ctrlp#branches#is_git_repository(...)
  let path = a:0 > 0 ? a:1 : getcwd()
  return finddir('.git', fnameescape(path)) != ''
endfunction

" vim:nofen:fdl=0:ts=2:sw=2:sts=2
