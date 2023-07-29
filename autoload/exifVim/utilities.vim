" Query exiftool for writable tags.
"
" For some reason they are split both by spaces and new lines thus reuqiring
" extra processing.
function! exifVim#utilities#getWritableTags()
  let tags = system(g:exifVim_backend .. ' -listw ')
  let tags = split(tags, '\_s')[3:]
  call filter(tags, 'v:val != ""')
  return tags
endfunction
