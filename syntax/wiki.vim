"**********************************************************
"*                                                        *
"* .wiki file Syntax Highlighting                         *
"*                                                        *
"* By: Charlie Burgess                                    *
"* Created: 18/10/2021                                    *
"*                                                        *
"**********************************************************

if exists("b:current_syntax")
  finish                     
endif                        


syn match wikiComment   "^#.*$"
syn match wikiFixture   "^$.*$"
syn match wikiInclude   "^include.*$"
syn match wikiDefine    "^!define.*$"
syn match wikiTable     "^|.*$"
syn match wikiHeading   "^'''.*$"
syn match wikiSection   "^!\*.*$"

let b:current_syntax = "wiki"

hi def link wikiComment   Comment
hi def link wikiFixture   PreProc 
hi def link wikiInclude   Special
hi def link wikiDefine    Statement
hi def link wikiTable     Statement
hi def link wikiHeading   Comment
hi def link wikiSection   Underlined
