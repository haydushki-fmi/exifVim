let s:settings = #{
      \ command: g:exifVim_backend,
      \ delimiter: '->',
      \ }

function! exifVim#ReadFile(filename)
  if !filereadable(a:filename)
    echoerr "File " .. a:filename .. " could not be read."
    return
  endif

  let filename = shellescape(a:filename)

  let command_output = systemlist(s:settings.command .. ' -s ' .. filename)

  " TODO: Check for errors

  let tags = map(command_output, 'split(v:val, ":")')

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
