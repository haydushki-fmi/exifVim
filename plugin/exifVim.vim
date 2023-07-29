if exists('g:loaded_exifVim') || &cp
  finish
endif

let g:loaded_exifVim = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim



let &cpo = s:keepcpo
unlet s:keepcpo
