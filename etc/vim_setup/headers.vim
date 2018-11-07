" (c) 2018, Andres Aquino <inbox@andresaquino.sh>
" This file is licensed under the BSD License version 3 or later.
" See the LICENSE file.
"
" Based on work of Agapo (fpmarias@google.com), /usr/share/vim/vim70/plugin/header.vim

" Last modification: 20180326.034630

""
function s:filetype()
  "
  set si ai
  let s:options = "si ai"
  let s:fn = expand("%:t")
  let s:ft = expand("%:e")

  " Default header
  let s:comment = "N"
  let s:header  = s:comment
  let s:footer  = s:comment

  " check if {sh, groovy}
  if s:ft ==# "sh"
    let s:comment  = "#"
    let s:header   = s:comment . "!/usr/bin/env bash"
    let s:footer   = s:comment
  elseif s:ft ==# "groovy" || s:ft ==# "gvy"
    let s:comment  = "//"
    let s:header   = "#!/usr/bin/env groovy\n"
    let s:footer   = s:comment
  elseif s:ft ==# "ruby"
    let s:comment  = "#"
    let s:header   = s:comment . "!/usr/bin/env ruby"
    let s:footer   = s:comment
  elseif s:ft ==# "python"
    let s:comment  = "#"
    let s:header   = s:comment . "!/usr/bin/env python"
    let s:footer   = s:comment
  elseif s:ft ==# "perl"
    let s:comment  = "#"
    let s:header   = s:comment . "!/usr/bin/env perl"
    let s:footer   = s:comment
  elseif s:ft ==# "vim"
    let s:comment  = "\""
    let s:header   = s:comment . " Vim File"
    let s:footer   = s:comment
  elseif s:ft==# "php"
    let s:comment  = "\/\/"
    let s:header   = "<?PHP"
    let s:footer   = "?>"
  elseif s:ft ==# "js" || s:ft ==# "javascript" || s:ft ==# "javascript.jsx" || s:ft ==# "ts" || s:ft ==# "vue"
    let s:comment  = "\/\/"
    let s:header   = s:comment . " Javascript File"
    let s:footer   = s:comment
  elseif s:ft ==# "c" || s:ft ==# "cpp"
    let s:comment  = "\/\/"
    let s:header   = s:comment . " C/C++ File"
    let s:footer   = s:comment
  elseif s:ft ==# "md" || s:ft ==# "markdown"
    let s:comment  = "#"
    let s:header   = s:comment . " Markdown File"
    let s:footer   = s:comment
    let s:options  = "si ai noet list"
  elseif s:ft ==# "htm" || s:ft ==# "html"
    let s:comment  = ""
    let s:header   = "<!-- HTML File"
    let s:footer   = "-->"
    let s:options  = "si ai noet list"
  elseif s:ft ==# "css"
    let s:comment  = "*"
    let s:header   = "/* CSS File"
    let s:footer   = "*/"
    let s:options  = "si ai noet list"
  endif

endfunction


""
function s:insert()
  "
  call s:filetype()
  "
  set comments=
  if s:comment ==# "N"
    execute "normal i# (c) " . strftime("%Y") . ", " . expand("$__UPFullname") . " <" . expand("$__UPMailbox") . ">\n"
    execute "normal i# This file is licensed under the BSD License version 3 or later.\n"
    execute "normal i# See the LICENSE file.\n"
    execute "normal i# \n"
    execute "normal i# LastModf: " . strftime ("%Y%m%d.%H%M") . "\n"
    execute "normal i# \n"
  else 
    execute "normal i" . s:header  . "\n"
    execute "normal i" . s:comment . " vim: " . s:options . ":\n"
    execute "normal i" . s:comment . " \n"
    execute "normal i" . s:comment . " (c) " . strftime("%Y") . ", " . expand("$__UPFullname") . " <" . expand("$__UPMailbox") . ">\n"
    execute "normal i" . s:comment . " This file is licensed under the BSD License version 3 or later.\n"
    execute "normal i" . s:comment . " See the LICENSE file.\n"
    execute "normal i" . s:comment . " \n"
    execute "normal i" . s:comment . " LastModf: " . strftime ("%Y%m%d.%H%M") . "\n"
    execute "normal i" . s:footer . "\n"
    execute "normal i \n"
    execute "normal i \n"
    execute "normal i \n"
  endif
  unlet s:comment
  unlet s:header
  unlet s:footer

endfunction


""
function s:update()
  "
  call s:filetype()
  "
  call cursor(0,0)
  let s:pattern = s:comment . " LastModf: [0-9]"
  let [s:lnum, s:col] = searchpos(s:pattern, "n")
  let s:modified = s:comment . " LastModf: " . strftime ("%Y%m%d.%H%M")

  if s:lnum != 0
    call setline(s:lnum, s:modified)
  endif

  unlet s:comment
  unlet s:header
  unlet s:footer
  unlet s:pattern
  unlet s:modified

endfunction

autocmd BufNewFile * call s:insert()
autocmd BufWritePre * call s:update()
