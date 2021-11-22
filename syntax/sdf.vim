"**********************************************************
"*                                                        *
"* sdf file Syntax Highlighting                           *
"*                                                        *
"* By: Charlie Burgess                                    *
"* Created: 01/10/2021                                    *
"*                                                        *
"**********************************************************

syn match sdfStatement  "^>>.*$"
syn match sdfComment    "^!-.*$"
syn match sdfComment    "^!\*.*$"
syn match sdfComment    "^!.*$"

let b:current_syntax =  "sdf"

hi def link sdfComment     Comment
hi def link sdfStatement   Statement
