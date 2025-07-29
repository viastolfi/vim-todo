vim9script

command! -nargs=* Todo call Todo(<f-args>)

def Todo(...dirs: list<string>)
  var pattern = 'TODO'
  var targets = empty(dirs) ? join(GetDirNotInGitignore(), ' ') : join(dirs, ' ')
  var cmd = 'grep --color=never --binary-files=without-match -r -n "' .. pattern .. '" ' .. targets

  var output = systemlist(cmd)

  if empty(output)
    echomsg 'No TODOs found.'
    return
  endif

  call setqflist([], 'r', {lines: output, title: 'TODOs'})
  copen
enddef

def GetDirNotInGitignore(): list<string>
  var files = systemlist('git ls-files --cached --others --exclude-standard')
  if v:shell_error != 0 || empty(files)
    return ['.']
  endif

  var tops = {}

  for f in files
    if f ==# ''
      continue
    endif

    if f =~# '/'
      var dir = split(f, '/')[0]
      tops[dir] = 1
    else
      tops[f] = 1
    endif
  endfor

  return keys(tops)
enddef

