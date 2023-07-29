let s:settings = #{
      \ command: 'exiftool',
      \ delimiter: '->',
      \ }

function! exifVim#ReadFile(filename)
  if !filereadable(a:filename)
    echoerr "File " .. a:filename .. " could not be read."
    return
  endif

  let filename = shellescape(a:filename)

  let command_output = systemlist(s:settings.command .. ' ' .. filename)

  " TODO: Check for errors

  let tags = map(command_output, 'split(v:val, ":")')

  " Output to buffer:
  for tag in tags
    call append(line('$'), tag[0] .. s:settings.delimiter .. tag[1])
  endfor

  exe '1d'

  set filetype=exifimage  " For highlighting
  call cursor(1,1)        " Place the cursor in the begining
endfunction
