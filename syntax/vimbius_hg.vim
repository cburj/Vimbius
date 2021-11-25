"**********************************************************
"*                                                        *
"* VIMBIUS HG file Syntax Highlighting                    *
"*                                                        *
"* By: Charlie Burgess                                    *
"* Created: 25/11/2021                                    *
"*                                                        *
"**********************************************************

syn match hgModified   "^M.*$"
syn match hgUntracked  "^?.*$"
syn match hgAdded      "^A.*$"
syn match hgRemoved    "^R.*$"
syn match hgMissing    "^!.*$"

let b:current_syntax = "plugin"

hi def link hgModified          Statement 
hi def link hgUntracked         Comment 
hi def link hgAdded             String 
hi def link hgRemoved           Error 
hi def link hgMissing           StorageClass 
