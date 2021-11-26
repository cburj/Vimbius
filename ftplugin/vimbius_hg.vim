" -----------------------------------------------------------------------------------
" VIMBIUS:      VIM Basic Input Utilities
" Maintainer:   Charlie Burgess [http://cburg.co.uk]
" Version:      1.4.0
" Project Repo: http://github.com/cburj/vimbius/
" Description:  VIMBIUS is a lightweight collection of
"               Syntax Highlighting and Programming tools, designed to increase
"               productivity and reduce the time it takes to transition to VIM.
"
"               VIMBIUS is made up of fragments from two of my previous
"               plugins: Vimps and POPBOX. They were combined into the
"               foundation of VIMBIUS to reduce duplication and generally make
"               my life easier when working on the functionality.


" -----------------------------------------------------------------------------------
" KEYBINDS:
" -----------------------------------------------------------------------------------
nnoremap <buffer> <C-x> :call VIMBIUS_ProcessFile() <CR>
nnoremap <buffer> <cr>  :call VIMBIUS_OpenFile() <CR>

function! VIMBIUS_OpenFile()
  echo 'Opening File 📂'

  " Figure out the file name from the line selected
  let line = getline(".")
  let fileName = substitute( line, "^[A-Z!?] ", "", "" )

  " Jump back to the previous split to the left.
  exe winnr()-1 . "wincmd w"

  " Open the selected file in a new tab, so you can always go
  " back to whatver you were doing.
  exe "tabedit " . fileName . ""
  exe "normal! ^"
endfunction

""
" Handles the selection of the user when inside the mercurial HG Status
" side panel. Users can use CTRL+x to auto change the file.
" E.g. an untracked file will be ADDED, a modified file will be REVERTED,
" an added file will be FORGOTTEN etc.
function! VIMBIUS_ProcessFile()
  let line = getline(".")

  " Figure out the status of the file. E.g. M (Modified), ? (Untracked), etc.
  let fileStatus = line[0]

  " Figure out the file name
  let fileName = substitute( line, "^[A-Z!?] ", "", "" )

  " Figure out what the command will be e.g. M->Revert, ?->Add
  if( fileStatus == "M" )
    let fileOption = "revert"
  elseif( fileStatus == "?" )
    let fileOption = "add"
  elseif( fileStatus == "!" )
    let fileOption = "revert"
  elseif( fileStatus == "A" )
    let fileOption = "forget"
  else
    "This is an unsupported option.
    let fileOption = "null"
    echo ">> Unsupported file status"
    return
  endif

  let response = system("hg " . fileOption . " " . fileName )

  "Close the Buffer
  bdelete

  "TODO - figure out how to re-fresh or re-call the buffer
  "with all of the updated mercurial status info.

endfunction

" -----------------------------------------------------------------------------------
"  VIMBIUS (2021)
"  
"  Charlie Burgess (cburg.co.uk)
" -----------------------------------------------------------------------------------
