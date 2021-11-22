"**********************************************************
"*                                                        *
"* .plugin file Syntax Highlighting                       *
"*                                                        *
"* By: Charlie Burgess                                    *
"* Created: 01/10/2021                                    *
"*                                                        *
"**********************************************************

syn match pluginStatement   "^>>.*$"
syn match pluginComment     "^!-.*$"
syn match pluginComment     "^!\*.*$"
syn match pluginComment     "^! .*$"
syn match pluginComment     "^!.*$"
syn match pluginConstant    "^plugin.*$"

let b:current_syntax = "plugin"

hi def link pluginComment       Comment
hi def link pluginStatement     Statement
hi def link pluginConstant      Constant
