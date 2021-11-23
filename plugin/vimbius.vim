" -----------------------------------------------------------------------------------
" VIMBIUS:      VIM Basic Input Utilities
" Maintainer:   Charlie Burgess [http://cburg.co.uk]
" Version:      1.0.0
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
" VERBOSE COMMANDS:
" -----------------------------------------------------------------------------------
command! CheckValid   :call VIMBIUS_Check_ValidRecNo()
command! HashInclude  :call VIMBIUS_HashInclude()
command! CommentLine  :call VIMBIUS_PluginComment()
command! PTime        :call VIMBIUS_GetDateTime()
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
nnoremap f      :call VIMBIUS_GetFunctionName() <CR>


" -----------------------------------------------------------------------------------
" CONFIG:
" -----------------------------------------------------------------------------------
:set timeoutlen=250


" -----------------------------------------------------------------------------------
" CORE FUNCTIONS:
" -----------------------------------------------------------------------------------

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


" Creates a #include statement for the file under the cursor.
fun! VIMBIUS_HashInclude()
  let wordUnderCursor = expand("<cfile>")
  let hashInclude = '#include "' . wordUnderCursor . '"'
  d
  execute "normal! i" . hashInclude
  execute "normal! ^"
endfun


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


" Gets the current date and time and displays in a popup dialog.
fun! VIMBIUS_GetDateTime()
  let text = system( 'date' )
  call popup_dialog( [text], #{ title: 'Date & Time [VIMBIUS]', padding: [1,5,1,5], highlight: 'WildMenu', time: 3000, } )
endfun

fun! VIMBIUS_JumpToFuncName()
  echohl ModeMsg
  call search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW')
endfun

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


" Shows a Popup save menu - making it much easier to save and quit files in VIM.
func! VIMBIUS_SaveMenu()
  call popup_menu(['Save', 'Save + Quit', 'Quit', 'Force Quit',], #{ title: "Save Menu [VIMBIUS]", callback: 'VIMBIUS_HandleSaveMenu', highlight: 'wildmenu', border: [], close: 'click',  padding: [1,5,1,5]} )
endfunc


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
          \const char*                    RecordId )\r
          \DATA_API_ACTION_REQUEST*       ActionRequest\r
          \{\r
          \ return DATA_API_STATUS_OK;\r
          \}"  
  elseif a:result == 4
    "MANTA List Show Function
    execute "normal! o\n
          \static DATA_API_ACTION_SHOW_TYPE ShowXXXAction(\r
          \DATA_API_LIST_ACTION*    Action,\r
          \const DATA_API_QUERY*    Query )\r
          \{\r
          \ return DATA_API_ACTION_SHOW_ENABLED;\r
          \}"  
  elseif a:result == 5
    "MANTA List Handle Function
    execute "normal! o\n
          \static DATA_API_STATUS HandleXXXAction(\r
          \const DATA_API_LIST_ACTION*    Action,\r
          \const DATA_API_QUERY*          Query )\r
          \DATA_API_ACTION_REQUEST*       ActionRequest\r
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


" Shows a Popup 'Quick-Function' dialog to easily insert common function prototypes.
func! VIMBIUS_QuickFunc()
  call popup_menu([ 'GLOBAL Func', 'SHOW Detail-Func    [MANTA]', 'HANDLE Detail-Func  [MANTA]', 'SHOW List-Func      [MANTA]', 'HANDLE List-Func    [MANTA]', 'Get Value Str       [MANTA]', 'Infinite Loop', 'If Statement',  'Define Plugin Point', 'Plugin Insertion Point', '        Main Menu'], #{ title: "Quick Functions [VIMBIUS]", callback: 'VIMBIUS_HandleQuickFunc', highlight: 'wildmenu', border: [], close: 'click',  padding: [1,5,1,5]} )
endfun


" Handles all of the inputs from the SaveMenu popup box
func! VIMBIUS_HandleMainMenu(id, result)
  if a:result == 1
    execute ':PQuick'
  elseif a:result == 2
    execute ':PPlug'
  elseif a:result == 3
    execute ':PSave'
  elseif a:result == 4
    execute ':PTime'
  else
    "Do nothing
  endif
endfunc


func! VIMBIUS_MainMenu()
  call popup_menu([ 'Snippets', 'VIM-Plug Settings','Save Menu', 'Calendar'], #{ title: "Main Menu [VIMBIUS]", callback: 'VIMBIUS_HandleMainMenu', highlight: 'wildmenu', border: [], close: 'click',  padding: [1,5,1,5]} )
endfun


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


" Shows a Popup menu for VIM Plug Settings
func! VIMBIUS_VimPlug()
  call popup_menu(['PlugInstall', 'PlugClean', 'PlugUpdate', 'PlugStatus', '    Main Menu'], #{ title: "VIM Plug Settings [VIMBIUS]", callback: 'VIMBIUS_HandleVimPlug', highlight: 'wildmenu', border: [], close: 'click',  padding: [1,5,1,5]} )
endfunc


" Add a TODO comment above the current line.
fun! VIMBIUS_Todo()
  execute "normal! O//TODO"
  execute "normal! ^"
endfun

" Add a FIXME comment above the current line.
fun! VIMBIUS_FixMe()
  execute "normal! O//FIXME"
  execute "normal! ^"
endfun
" -----------------------------------------------------------------------------------
"  VIMBIUS (2021)
"  
"  Charlie Burgess (cburg.co.uk)
" -----------------------------------------------------------------------------------
