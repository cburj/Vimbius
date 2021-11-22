"**********************************************************
"*                                                        *
"* .df_alias file Syntax Highlighting                     *
"*                                                        *
"* By: Charlie Burgess                                    *
"* Created: 21/10/2021                                    *
"*                                                        *
"**********************************************************

syn match df_aliasComment   "^#.*$"
syn match df_aliasConstant  "^!.*$"

let b:current_syntax = "df_alias"

hi def link df_aliasComment     Comment
hi def link df_aliasConstant    Constant
