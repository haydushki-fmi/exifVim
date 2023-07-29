if exists('g:loaded_exifVim') || &cp
  finish
endif

let g:loaded_exifVim = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

" NOTE: Exiftool supports many file formats but to get started just use .png
" and .jpg
" TODO: Make regex for .jpg_original and stuff
autocmd BufReadCmd *.png call exifVim#ReadFile(expand('<afile>'))
autocmd BufWriteCmd *.png call exifVim#WriteFile(expand('<afile>'))

autocmd BufReadCmd *.jpg call exifVim#ReadFile(expand('<afile>'))
autocmd BufWriteCmd *.jpg call exifVim#WriteFile(expand('<afile>'))

let &cpo = s:keepcpo
unlet s:keepcpo
