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

  var qfl = ParseGrepOutputToQF(output)
  call setqflist([], 'r', {items: qfl, title: 'TODOs'})
  copen
enddef

def ParseGrepOutputToQF(lines: list<string>): list<any>
  var qflist = []

  for line in lines
    var parts = split(line, ':', v:true)
    if len(parts) < 3
      continue
    endif

    var filename = parts[0]
    var lnum = str2nr(parts[1])

    var entry = {
      'filename': filename,
      'lnum': lnum,
      'text': parts[2],
    }

    call add(qflist, entry)
  endfor

  return qflist
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
