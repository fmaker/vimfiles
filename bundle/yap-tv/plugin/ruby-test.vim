" This code adapted from "
" http://drasticcode.com/2009/11/28/how-to-run-one-test-unit-test-case-from-vim"
function! BDD(args)
  if bufname("%") =~ "test.rb"
    call RunTest(a:args)
  elseif bufname("%") =~ "spec.rb"
    call RunSpec(a:args)
  else
    echo "don't know how to BDD this file"
  end
endfunction

function! RunTest(args)
  let cursor = matchstr(a:args, '\d\+')
  if cursor
    while !exists("cmd") && cursor != 1
      if match(getline(cursor), 'def test') >= 0
        let cmd = ":read ! bundle exec ruby ". fnameescape(expand("%")) . " -vv -n ". matchstr(getline(cursor), "test_[a-zA-Z_]*")
      else
        let cursor -= 1
      end
    endwhile
  end
  if !exists("cmd")

    let cmd = ":read ! bundle exec ruby ". fnameescape(expand("%")) . " -vv"
  end
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  execute cmd
  setlocal nomodifiable
  1
endfunction

function! RunSpec(args)
  if exists("b:rails_root") && filereadable(b:rails_root . "/script/spec")
    let spec = b:rails_root . "/script/spec"
  else
    let spec = "spec"
  end
  let cmd = ":! " . spec . " % -cfn " . a:args
  execute cmd
endfunction

map !s :call BDD("-l " . <C-r>=line('.')<CR>)
map !S :call BDD("")

