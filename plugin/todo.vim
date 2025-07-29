vim9script

command! -nargs=* Todo call Todo(<f-args>)

def Todo(...dirs: list<string>)
  var pattern = 'TODO'
  var targets = empty(dirs) ? '.' : join(dirs, ' ')
  var cmd = 'grep --binary-files=without-match -r "' .. pattern .. '" ' .. targets

  var output = systemlist(cmd)

  if empty(output)
    echomsg 'No TODOs found.'
    return
  endif

  call setqflist([], 'r', {lines: output, title: 'TODOs'})
  copen
enddef
