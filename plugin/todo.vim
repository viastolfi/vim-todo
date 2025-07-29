vim9script

command! -nargs=* Todo call Todo(<f-args>)

def Todo(...dirs: list<string>)
  if empty(dirs)
    execute 'silent grep --binary-files=without-macth -r TODO .'
  else
    var pattern = 'TODO'
    var targets = join(dirs, ' ')
    execute 'silent grep --binary-files=without-match -r "' .. pattern .. '" ' .. targets
  endif 

  if len(getqflist()) > 0
    copen
  else
    echo "No TODOs found."
  endif
enddef
