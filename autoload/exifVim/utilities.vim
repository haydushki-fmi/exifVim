" Query exiftool for writable tags and return them as a list.
"
" For some reason they are split both by spaces and new lines thus requiring
" extra processing.
function! exifVim#utilities#getWritableTags()
  let tags = system(g:exifVim_backend .. ' -listw ')->split('\_s')[3:]
  call filter(tags, 'v:val != ""')
  return tags
endfunction

function! exifVim#utilities#completeTagName(ArgLead, CmdLine, CursorPos)
  return filter(exifVim#utilities#getWritableTags(), 'v:val =~ a:ArgLead')
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

" Split and trim tag line using delimiter. Return tag name and value if line
" is valid.
function! exifVim#utilities#ParseTagLine(line, delimiter)
  if a:line == ''
    return ['', '']
  endif

  let line = split(a:line, a:delimiter)
  let tagName = trim(line[0])
  let tagValue =  trim(line[1])
  return [tagName, tagValue]
endfunction

" Display confirmation dialog and return string for overwriting original file.
function! exifVim#utilities#ConfirmOverwrite()
  if confirm("Overwrite original file?", "&Yes\n&No", 2) == 1
    return ' -overwrite_original'
  else
    return ''
  endif
endfunction
