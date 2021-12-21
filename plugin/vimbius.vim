" -----------------------------------------------------------------------------------
" VIMBIUS:      VIM Basic Input Utilities
" Maintainer:   Charlie Burgess [http://cburg.co.uk]
" Version:      2.0.0
" Project Repo: http://github.com/cburj/vimbius/
" Description:  VIMBIUS is a lightweight collection of
"               Syntax Highlighting and Programming tools, designed to increase
"               productivity and reduce the time it takes to transition to VIM.


" -----------------------------------------------------------------------------------
" VERBOSE COMMANDS:
" -----------------------------------------------------------------------------------
command! CheckValid   :call VIMBIUS_Check_ValidRecNo()
command! HashInclude  :call VIMBIUS_HashInclude()
command! CommentLine  :call VIMBIUS_PluginComment()
command! TemplateConv :call VIMBIUS_TemplateConvert()
command! HgStatus     :call VIMBIUS_HgStatus()
command! HgLogBranch  :call VIMBIUS_HgLogBranch()
command! PFunc        :call VIMBIUS_GetFunctionName()
command! PJump        :call VIMBIUS_JumpToFuncName()
command! PSave        :call VIMBIUS_SaveMenu()
command! PQuick       :call VIMBIUS_QuickFunc()
command! PMenu        :call VIMBIUS_MainMenu()
command! PPlug        :call VIMBIUS_VimPlug()


" -----------------------------------------------------------------------------------
" KEYBINDS:
" -----------------------------------------------------------------------------------
nnoremap cvr    :call VIMBIUS_Check_ValidRecNo() <CR>
nnoremap hi     :call VIMBIUS_HashInclude() <CR>
nnoremap com    :call VIMBIUS_PluginComment() <CR>
nnoremap mm     :call VIMBIUS_MainMenu() <CR>
nnoremap ff     :call VIMBIUS_JumpToFuncName() <CR>
nnoremap ss     :call VIMBIUS_SaveMenu() <CR>
nnoremap ##     :call VIMBIUS_QuickFunc() <CR>
nnoremap todo   :call VIMBIUS_Todo() <CR>
nnoremap fixme  :call VIMBIUS_FixMe() <CR>
nnoremap temp   :call VIMBIUS_TemplateConvert() <CR>
nnoremap hgst   :call VIMBIUS_HgStatus() <CR>
nnoremap hglog  :call VIMBIUS_HgLogBranch() <CR>
nnoremap f      :call VIMBIUS_GetFunctionName() <CR>


" -----------------------------------------------------------------------------------
" CONFIG:
" -----------------------------------------------------------------------------------
:set timeoutlen=250


" -----------------------------------------------------------------------------------
" CORE FUNCTIONS:
" -----------------------------------------------------------------------------------

""
"Autogen XXX_ValidRecNo() if-statement for XxxRecNo Variable.
"Default Keybind is "cvr" (a.k.a. Check Valid RecNo), but this
"can be changed in the lines above.
func! VIMBIUS_Check_ValidRecNo()
  let wordUnderCursor = expand("<cword>")

  "Strip away RecNo from the entity
  let entityName = substitute( wordUnderCursor, 'RecNo', '', '' )

  let underscored = ""
  let l:count = "true"
  
  "Loop through the entity name and convert it to
  "snake_case
  for s:item in split(entityName, '\zs')
    if( s:item == toupper( s:item ) )
      if( l:count == "true" )
        "We don't want to add an underscore to the start
        "of the new string, so just carry on.
        let underscored = underscored . s:item
      else
        "Add an underscore before any remaining Capitals
        let underscored = underscored . '_' . s:item
      endif
    else
      let underscored = underscored . s:item
    endif
    let l:count = "false" 
  endfor

  "This is the final UPPER_SNAKE_CASE version
  "of the string.
  let finalUpper = toupper(underscored)

  "Now paste it into the file.
  execute "normal! oif( !" . finalUpper . "_ValidRecNo( " . wordUnderCursor . " ) )\r
        \{\r
        \return FALSE;\r
        \}"
  execute "normal! ^"

endfun


""
" Creates a #include statement for the file under the cursor.
fun! VIMBIUS_HashInclude()
  let wordUnderCursor = expand("<cfile>")
  let hashInclude = '#include "' . wordUnderCursor . '"'
  d
  execute "normal! i" . hashInclude . "\r"
  execute "normal! ^"
endfun


""
" Commenting single lines in Plugin, SDF, DF Alias and WIKI/ATF Files.
" Use 'com' to activate this function.
fun! VIMBIUS_PluginComment()

  "Default to nothing so files that aren't supported are unaffected
  let commentSymbol = ""

  "Detect the file type
  let my_filetype = &filetype

  "Get the current line
  let line = getline(".")

  "Figure out the comment symbol.
  if( my_filetype == "plugin" || my_filetype == "sdf" )
    let commentSymbol = "!"
  elseif( my_filetype == "df_alias" || my_filetype == "wiki" )
    let commentSymbol = "#"
  endif

  if( line[0] != commentSymbol )
    "If there isn't a comment at the start of this line, then add one:
    execute "normal! 0i" . commentSymbol
    execute "normal! ^"
  else
    "Otherwise, delete the comment
    execute "normal! 0x"
    execute "normal! ^"
  endif
endfun


""
" Gets the name of the current function and displays in a popup dialog
fun! VIMBIUS_GetFunctionName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  let funcName = getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  call popup_dialog( [funcName], #{ title: 'Function Name [VIMBIUS]', padding: [1,5,1,5], highlight: 'WildMenu', time: 3000, } )
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun


fun! VIMBIUS_JumpToFuncName()
  echohl ModeMsg
  call search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW')
endfun


""
" Handles all of the inputs from the SaveMenu popup box
func! VIMBIUS_HandleSaveMenu(id, result)
  " echo a:result
  if a:result == 1
    "Save the file
    execute ':w'
    call popup_dialog("File Saved", #{ title: 'VIMBIUS', time: '1000', highlight: 'WildMenu', padding: [0,15,0,15],} )
  elseif a:result == 2
    "Save and Quit
    execute ':wq'
  elseif a:result == 3
    "Quit
    execute ':q'
  elseif a:result == 4
    "Force Quit
    execute ':q!'
  else
    "Do nothing
  endif
endfunc

""
" Shows a Popup save menu - making it much easier to save and quit files in VIM.
func! VIMBIUS_SaveMenu()
  call popup_menu(['Save', 'Save + Quit', 'Quit', 'Force Quit',], #{ title: "Save Menu [VIMBIUS]", callback: 'VIMBIUS_HandleSaveMenu', highlight: 'wildmenu', border: [], close: 'click',  padding: [1,5,1,5]} )
endfunc

""
" Handles the inputs for the QuickFunc Popup
func! VIMBIUS_HandleQuickFunc(id, result)
  let cur_line_num = line('.')
  let cur_col_num = col('.')
  let orig_line = getline('.')
  if a:result == 1
    "Global Function Template
    execute "normal! o\nGLOBAL void XXX_Func( void )\r
                      \{\r
                      \}"  
  elseif a:result == 2
    "MANTA Details Show Function
    execute "normal! o\n
          \static DATA_API_ACTION_SHOW_TYPE ShowXXXAction(\r
          \DATA_API_DETAIL_ACTION*  Action,\r
          \const char*              RecordId )\r
          \{\r
          \ return DATA_API_ACTION_SHOW_ENABLED;\r
          \}"  
  elseif a:result == 3
    "MANTA Details Handle Function
    execute "normal! o\n
          \static DATA_API_STATUS HandleXXXAction(\r
          \const DATA_API_DETAIL_ACTION*  Action,\r
          \const char*                    RecordId,\r
          \DATA_API_ACTION_REQUEST*       ActionRequest )\r
          \{\r
          \ return DATA_API_STATUS_OK;\r
          \}"  
  elseif a:result == 4
    "MANTA List Show Function
    execute "normal! o\n
          \static DATA_API_ACTION_SHOW_TYPE ShowXXXAction(\r
          \DATA_API_LIST_ACTION    *Action,\r
          \const DATA_API_QUERY    *Query )\r
          \{\r
          \ return DATA_API_ACTION_SHOW_ENABLED;\r
          \}"  
  elseif a:result == 5
    "MANTA List Handle Function
    execute "normal! o\n
          \static DATA_API_STATUS HandleXXXAction(\r
          \const DATA_API_LIST_ACTION    *Action,\r
          \const DATA_API_QUERY          *Query )\r
          \DATA_API_ACTION_REQUEST       *ActionRequest\r
          \{\r
          \ return DATA_API_STATUS_OK;\r
          \}"  
  elseif a:result == 6
    "MANTA Get Str Function
    execute "normal! o\n
          \ const char* XxxStr = DATA_API_ACTION_REQUEST_GetActionFormFieldValueStr( ActionRequest, XxxField );" 
  elseif a:result == 7
    "Infinite Loop
    execute "normal! o\n
          \int i=1;\r
          \while(i==1)\r
          \{\r
          \}\r"
  elseif a:result == 8
    "if statement
    execute "normal! o\n
          \if(  )\r
          \{\r
          \\r
          \}\r"
  elseif a:result == 9
    execute "normal! o>> FILE.FUNCTION.plugin.inc"
    execute "normal! ^"
  elseif a:result == 10 
    execute "normal! o/* PLUGINSTART (FILE.FUNCTION.plugin.inc)              */\r
          \/* PLUGINEND - end of plugin - edit keyline do not alter               */"
    execute "normal! ^"
  elseif a:result == 11
    execute ':PMenu' 
  else
    "Do nothing
  endif
endfunc

""
" Shows a Popup 'Quick-Function' dialog to easily insert common function prototypes.
func! VIMBIUS_QuickFunc()
  call popup_menu([ 'GLOBAL Func', 'SHOW Detail-Func    [MANTA]', 'HANDLE Detail-Func  [MANTA]', 'SHOW List-Func      [MANTA]', 'HANDLE List-Func    [MANTA]', 'Get Value Str       [MANTA]', 'Infinite Loop', 'If Statement',  'Define Plugin Point', 'Plugin Insertion Point', '        Main Menu'], #{ title: "Quick Functions [VIMBIUS]", callback: 'VIMBIUS_HandleQuickFunc', highlight: 'wildmenu', border: [], close: 'click',  padding: [1,5,1,5]} )
endfun


""
" Handles all of the inputs from the SaveMenu popup box
func! VIMBIUS_HandleMainMenu(id, result)
  if a:result == 1
    execute ':PQuick'
  elseif a:result ==2
    execute ':TemplateConv'
  elseif a:result == 3
    execute ':PPlug'
  elseif a:result == 4
    execute ':PSave'
  elseif a:result == 5
  else
    "Do nothing
  endif
endfunc

""
" Main Menu Popup Function
func! VIMBIUS_MainMenu()
  call popup_menu([ 'Snippets', 'Convert Template', 'VIM-Plug Settings','Save Menu', 'Reload ~/.vimrc'], #{ title: "Main Menu [VIMBIUS]", callback: 'VIMBIUS_HandleMainMenu', highlight: 'wildmenu', border: [], close: 'click',  padding: [1,5,1,5]} )
endfun

""
" Handles all of the inputs from the VimPlug popup box
func! VIMBIUS_HandleVimPlug(id, result)
  if a:result == 1
    execute ':PlugInstall'
  elseif a:result == 2
    execute 'PlugClean'
  elseif a:result == 3
    execute ':PlugUpdate'
  elseif a:result == 4
    execute ':PlugUpgrade'
  elseif a:result == 5
    execute ':PMenu'
  else
    "Do nothing
  endif
endfunc

""
" Shows a Popup menu for VIM Plug Settings
func! VIMBIUS_VimPlug()
  call popup_menu(['PlugInstall', 'PlugClean', 'PlugUpdate', 'PlugStatus', '    Main Menu'], #{ title: "VIM Plug Settings [VIMBIUS]", callback: 'VIMBIUS_HandleVimPlug', highlight: 'wildmenu', border: [], close: 'click',  padding: [1,5,1,5]} )
endfunc

""
" Add a TODO comment above the current line.
fun! VIMBIUS_Todo()
  execute "normal! O//TODO"
  execute "normal! ^"
endfun

""
" Add a FIXME comment above the current line.
fun! VIMBIUS_FixMe()
  execute "normal! O//FIXME"
  execute "normal! ^"
endfun

""
" Quickly convert a template file using its filename as the new entity name.
" E.g. manual_loc_lib.c will result in all instances of XXX/Xxx/xxx being
" converted to MANUAL_LOC/ManualLoc/manual_loc
func! VIMBIUS_TemplateConvert()
  let filename = expand('%')
  let entityName = ""

  " Strip away relevant entityName endings
  if filename =~ "lib.c" 
    let entityName = substitute( filename, "_lib.c", "", "" )
  elseif filename =~ "_lib_api.c"
    let entityName = substitute( filename, "_lib_api.c", "", "" )
  elseif filename =~ ".plugin"
    let entityName = substitute( filename, ".plugin", "", "" )
  elseif filename =~ "_definitions.h"
    let entityName = substitute( filename, "_definitions.h", "", "" )
  elseif filename =~ "_declarations.h"
    let entityName = substitute( filename, "_declarations.h", "", "" )
  endif

  " It's a bit harder to convert xxx_yyy to Xxx_Yyy
  let entityCamel = ""
  let counter = 1
  for s:item in split(entityName, '\zs')
    if( counter == 1 )
      let entityCamel = entityCamel . toupper( s:item )
      let counter = 0
    elseif s:item == "_"
      "we ignore underscores, so we get CamelCase
      let counter = 1
    else
      let entityCamel = entityCamel . s:item
      let counter = 0
    endif
  endfor

  echo ">> Making Changes..."
  " Replace the first all instances with the match case of the file name.
  " If we don't check the patterns exist first, then we will get errors.
  if( search( "xxx" ) )
    exe 'silent %s/xxx/' . entityName . '/g'
  endif
  if( search( "XXX" ) )
    exe 'silent %s/XXX/' . toupper(entityName) . '/g'
  endif
  if( search( "Xxx" ) )
    exe 'silent %s/Xxx/' . entityCamel . '/g'
  endif

  echo ">> File Updated!"

endfun


""
" Show the output of 'hg status .' in a new split to the right.
fun! VIMBIUS_HgStatus()
  "Call HG Status and assign to a variable
  let hgstatus = system("hg status .")

  "Create a new split to hold the HG Status contents
  vsplit __HgStatus__
  
  "Make this new split 45 units wide
  vertical resize 45

  setlocal buftype=nofile

  "Custom filetype so we can have some syntax highlighting
  "based on the file changes.
  setlocal filetype=vimbius_hg

  "Append the HG Status contents
  "TODO This is done in reverse order for now. But needs to be fixed 🙂
  call append( 0, split(hgstatus, '\v\n') )  
  call append( 0, '' )
  call append( 0, '========================================' )
  call append( 0, 'Changes in Current Directory:' )
  call append( 0, '========================================' )

  "Jump to the 5th line - this is where the files will always
  "start from.
  execute "normal! 5G"
endfun


""
" Show the history of the current repo - in the current branch.
" This is kind of useful as it means you don't have to open up
" Kallithea or Tortoise Workbench 
function! VIMBIUS_HgLogBranch()
  let hglog = system("hg log -b $(hg branch) -l 10")

  "Create a new split to hold the HG Log contents
  vsplit __HgLogBranch__
  
  "Make this new split 50 units wide
  vertical resize 50

  setlocal buftype=nofile

  call append( 0, split( hglog, '\v\n' ) )

  " Go to the top of the buffer
  execute "normal! gg"
endfunction
" -----------------------------------------------------------------------------------
"  VIMBIUS (2021)
"  
"  Charlie Burgess (cburg.co.uk)
" -----------------------------------------------------------------------------------
