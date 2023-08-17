if exists('g:loaded_exifVim') || &cp
  finish
endif

let g:loaded_exifVim = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

if !exists('g:exifVim_backend')
  let g:exifVim_backend = 'exiftool'
endif

if !exists('g:exifVim_backend_directory')
  let g:exifVim_backend_directory = ''
endif

if !exists('g:exifVim_checkWritable')
  let g:exifVim_checkWritable = 1 " When this is turned on, it's a bit slower
endif

command! -nargs=1 -complete=customlist,exifVim#utilities#completeTagName ExifVimAddTag call exifVim#AddTag(<f-args>)
command! ExifVimDeleteAllTags call exifVim#DeleteAllTags()


" NOTE: Exiftool supports many file formats but to get started just use .png
" and .jpg
autocmd BufReadCmd *.png call exifVim#ReadFile(expand('<afile>'))
autocmd BufWriteCmd *.png call exifVim#WriteFile(expand('<afile>'))
autocmd BufReadCmd *.png_original call exifVim#ReadFile(expand('<afile>'))
autocmd BufWriteCmd *.png_original call exifVim#WriteFile(expand('<afile>'))

autocmd BufReadCmd *.jpg call exifVim#ReadFile(expand('<afile>'))
autocmd BufWriteCmd *.jpg call exifVim#WriteFile(expand('<afile>'))
autocmd BufReadCmd *.jpg_original call exifVim#ReadFile(expand('<afile>'))
autocmd BufWriteCmd *.jpg_original call exifVim#WriteFile(expand('<afile>'))

let &cpo = s:keepcpo
unlet s:keepcpo
