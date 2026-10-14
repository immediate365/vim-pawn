au BufNewFile,BufRead *.p,*.pwn,*.pawn set filetype=pawn
au BufRead *.inc call s:DetectPawnInc()

function! s:DetectPawnInc() abort
  for l:line in getline(1, 200)
    if l:line =~# '^\s*#\s*\%(tryinclude\|endinput\|include\s*<\%(a_\|open\.mp\|omp_\)\)\|^\s*\%(native\|forward\|stock\)\>'
      set filetype=pawn
      return
    endif
  endfor
endfunction
