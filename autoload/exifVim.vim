let s:settings = #{
      \ command: g:exifVim_backend,
      \ delimiter: '->',
      \ firstTagLine: 5
      \ }

function! exifVim#ReadFile(filename)
  if !filereadable(a:filename)
    echoerr "File " .. a:filename .. " could not be read."
    return
  endif

  let filename = shellescape(a:filename)

  let command_output = systemlist(s:settings.command .. ' -s ' .. filename)

  " TODO: Check for errors
  "
  if g:exifVim_checkWritable
    let tags = s:GenerateTagsWritable(command_output)
  else
    let tags = s:GenerateTags(command_output)
  endif


  " Output to buffer:
  let filename_print = ' Exiftool file: ' .. a:filename .. ' '
  let filename_len = strdisplaywidth(filename_print)

  call append(0, [
        \ repeat('#', filename_len),
        \ filename_print,
        \ repeat('#', filename_len),
        \ ])

  for tag in tags
    call append(line('$'), tag[0] .. s:settings.delimiter .. tag[1])
  endfor

  set filetype=exifimage  " For highlighting
  call cursor(1,1)        " Place the cursor in the begining
endfunction

" TODO: Maybe refactor. Tis looks like a mess.
function! s:GenerateTagsWritable(data)
  let s:writable = exifVim#utilities#getWritableTags()
  let tags = map(a:data, function('s:GenerateWritableTag'))
  return tags
endfunction

function! s:GenerateWritableTag(index, line)
  let line = split(a:line, ':')
  let tag = line[0]
  let value = line[1]
  let tag_cleaned = trim(tag)

  if index(s:writable, tag_cleaned) >= 0
    return ['   ' .. tag, value]
  else
    return ['[X]' .. tag, value]
  endif
endfunction

function s:GenerateTags(data)
  let tags = map(a:data, 'split(v:val, ":")')
  return tags
endfunction

" Writing a file

function! exifVim#WriteFile(filename)
  let endLine = line('$')
  let tagsString = ""
  let lineNumber = s:settings.firstTagLine

  " When directory is the current directory, skip it
  let [dirLine, dirLineString] = exifVim#utilities#GetTagLineByName('Directory')
  let [dirTag, dirValue] = exifVim#utilities#ParseTagLine(dirLineString, s:settings.delimiter)
  if(dirValue == '.')
    let lineToSkip = dirLine
  else
    let lineToSkip = -1
  endif

  while lineNumber <= endLine
    let line = getline(lineNumber)

    if line != '' && lineNumber != lineToSkip
      if line[0] != '['
        let [tagName, tagValue] = exifVim#utilities#ParseTagLine(line, s:settings.delimiter)

        let tagsString = tagsString .. ' -' .. tagName .. '="' .. tagValue .. '"'
      endif
    endif

    let lineNumber += 1
  endwhile

  if confirm("Overwrite original file?", "&Yes\n&No", 2) == 1
    let overwriteOriginal = ' -overwrite_original'
  else
    let overwriteOriginal = ''
  endif

  let filename = shellescape(a:filename)
  let output = systemlist(s:settings.command .. tagsString .. overwriteOriginal .. ' ' .. filename)

  echomsg output
  if v:shell_error
    echoerr 'There was an error executing the ' .. s:settings.command .. ' command. See messages for program output.'
    return
  endif

  set nomodified
endfunction
