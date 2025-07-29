command! Todo call Todo()

def Todo()
  silent grep -r TODO .
  if len(getqflist()) > 0
    copen
  else
    echo "No TODOs found."
  endif
enddef

