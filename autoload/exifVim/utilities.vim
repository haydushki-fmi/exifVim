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

" Search for tagname and return line number and string.
function! exifVim#utilities#GetTagLineByName(tagname)
  echo a:tagname
  let tag_line = search(a:tagname)
  if tag_line <= 0
    return [tag_line, '']
  endif
  return [tag_line, getline(tag_line)]
endfunction

" Split and trim tag line using delimiter.
function! exifVim#utilities#ParseTagLine(line, delimiter)
  if a:line == ''
    return ['', '']
  endif

  let line = split(a:line, a:delimiter)
  let tagName = trim(line[0])
  let tagValue =  trim(line[1])
  return [tagName, tagValue]
endfunction
