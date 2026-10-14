if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn case match
syn iskeyword @,48-57,_,192-255,@-@
syn spell notoplevel

syn keyword pawnConditional if else switch
syn keyword pawnRepeat while for do foreach
syn keyword pawnLabel case default
syn keyword pawnStatement assert break continue exit goto return sleep state
syn keyword pawnStructure new enum
syn keyword pawnStorageClass public forward native char const static stock hook task ptask void inline using
syn keyword pawnOperatorWord sizeof tagof
syn keyword pawnBoolean true false TRUE FALSE
syn keyword pawnDefined contained defined

syn match pawnOperator "[-+*/%&|^<>=!~?:]"
syn match pawnRange "\.\@<!\.\.\.\@!"

syn match pawnFunction "\%(\w\|@\)\@<!\%(\%(if\|else\|switch\|while\|for\|do\|foreach\|case\|default\|assert\|break\|continue\|exit\|goto\|return\|sleep\|state\|new\|enum\|public\|forward\|native\|char\|const\|static\|stock\|hook\|task\|ptask\|void\|inline\|using\|sizeof\|tagof\|defined\)\>\)\@![A-Za-z_@][A-Za-z0-9_@]*\ze\s*("
syn match pawnTag "\%(\<case\s\+\)\@<!\<\%(\%(case\|default\)\>\)\@!\h\w*:"
syn match pawnIterIndent "\%(\<Iterator:\)\@<=\t"

syn match pawnNumberError "\<\d\w*"
syn match pawnNumber "\<\d[0-9_]*\>"
syn match pawnNumber "\<0x[0-9a-fA-F_]\+\>"
syn match pawnNumber "\<0b[01_]\+\>"
syn match pawnFloat "\<\d[0-9_]*\.\d[0-9_]*\%([eE][-+]\=\d\+\)\=\>"

syn match pawnEscapeError contained "\\."
syn match pawnEscape contained +\\\%([abefnrtv'"\\%]\|\d\+;\=\|x\x\+;\=\)+
syn match pawnFormatError contained "%"
syn match pawnFormat contained "%\%(\d\+\$\)\=[#0 +'-]*\%(\d\+\|\*\)\=\%(\.\%(\d\+\|\*\)\)\=[bdiouxXDOUeEfFgGaACcSspnq%]"
syn match pawnContinuation contained "\\$"
syn match pawnBadContinuation contained "\\\s\+$"

syn region pawnString start=+"+ skip=+\\\\\|\\"\|\\$+ end=+"+ end=+$+ contains=pawnEscapeError,pawnEscape,pawnFormatError,pawnFormat,pawnContinuation,@Spell
syn region pawnCharacter start=+'+ skip=+\\\\\|\\'+ end=+'+ end=+$+ contains=pawnEscapeError,pawnEscape

syn keyword pawnTodo contained TODO
syn keyword pawnTodoHigh contained FIXME XXX WTF
syn keyword pawnTodoLow contained TBD REVIEW
syn keyword pawnNote contained NOTE NB CHANGED IDEA IMPORTANT HACK BUG
syn cluster pawnCommentGroup contains=pawnTodo,pawnTodoHigh,pawnTodoLow,pawnNote,@Spell

syn match pawnCommentError "\*/\%([/*]\)\@!"
syn region pawnCommentL start="//" skip="\\$" end="$" keepend contains=@pawnCommentGroup,pawnContinuation,pawnBadContinuation
syn region pawnComment start="/\*" end="\*/" contains=@pawnCommentGroup fold extend

syn cluster pawnLex contains=pawnConditional,pawnRepeat,pawnLabel,pawnStatement,pawnStructure,pawnStorageClass,pawnOperatorWord,pawnBoolean,pawnOperator,pawnRange,pawnFunction,pawnTag,pawnNumberError,pawnNumber,pawnFloat,pawnString,pawnCharacter,pawnCommentError,pawnCommentL,pawnComment,pawnContinuation,pawnBadContinuation
syn cluster pawnPreCore contains=pawnCommentL,pawnComment,pawnString,pawnCharacter,pawnNumberError,pawnNumber,pawnFloat,pawnContinuation,pawnBadContinuation

syn region pawnPreProcLine matchgroup=pawnPreProc start="^\s*#" skip="\\$" end="$" keepend contains=pawnPreProcBadWord,@pawnPreCore
syn match pawnPreProcBadWord contained "\%(^\s*#\s*\)\@<=\w\+"

syn region pawnPreConditLine matchgroup=pawnPreCondit start="^\s*#\s*\%(if\|elseif\|else\|endif\)\>" skip="\\$" end="$" keepend contains=@pawnLex,pawnDefined
syn region pawnPreProcLine matchgroup=pawnPreProc start="^\s*#\s*\%(line\|section\|assert\|file\|endinput\|endscript\)\>" skip="\\$" end="$" keepend contains=@pawnLex,pawnDefined

syn region pawnIncludeLine matchgroup=pawnInclude start="^\s*#\s*\%(try\)\=include\>" skip="\\$" end="$" keepend contains=pawnIncluded,pawnCommentL,pawnComment
syn match pawnIncluded contained +<[^>]*>\|"[^"]*"\|\%(include\s\+\)\@<=[^ \t<"/]\S*+

syn region pawnDefineLine matchgroup=pawnDefine start="^\s*#\s*define\>" skip="\\$" end="$" keepend contains=@pawnLex,pawnDefined,pawnMacroName,pawnMacroFunc,pawnMacroParam,pawnStringify,pawnPaste
syn match pawnMacroName contained "\%(#\s*define\s\+\)\@<=[A-Za-z_@][A-Za-z0-9_@:]*"
syn match pawnMacroFunc contained "\%(#\s*define\s\+\)\@<=[A-Za-z_@][A-Za-z0-9_@:]*\ze("
syn match pawnMacroParam contained "%\d"
syn match pawnStringify contained "#\s*\%(%\d\|\h\w*\)"
syn match pawnPaste contained "##"

syn region pawnUndefLine matchgroup=pawnPreProc start="^\s*#\s*undef\>" skip="\\$" end="$" keepend contains=pawnUndefName,pawnCommentL,pawnComment
syn match pawnUndefName contained "\%(undef\s\+\)\@<=\h\w*"

syn region pawnPragmaLine matchgroup=pawnPreProc start="^\s*#\s*pragma\>" skip="\\$" end="$" keepend contains=pawnPragmaName,@pawnPreCore
syn keyword pawnPragmaName contained align amxlimit amxram codepage compress ctrlchar deprecated dynamic library overlay pack rational semicolon tabsize unused warning naked option

syn region pawnPreProcMsgLine matchgroup=pawnPreProc start="^\s*#\s*\%(error\|warning\)\>" end="$" keepend contains=pawnPreProcMsg
syn match pawnPreProcMsg contained ".\+"

syn region pawnEmitLine matchgroup=pawnPreProc start="^\s*[#@]\s*emit\>" skip="\\$" end="$" keepend contains=pawnEmitOp,@pawnPreCore,pawnOperator
syn match pawnEmitOp contained "\%(emit\s\+\)\@<=\a[A-Za-z0-9.]*"

syn region pawnBlock start="{" end="}" transparent fold

syn sync ccomment pawnComment minlines=50

hi def link pawnConditional Conditional
hi def link pawnRepeat Repeat
hi def link pawnLabel Label
hi def link pawnStatement Statement
hi def link pawnStructure Structure
hi def link pawnStorageClass StorageClass
hi def link pawnOperatorWord Operator
hi def link pawnOperator Operator
hi def link pawnRange Operator
hi def link pawnBoolean Boolean
hi def link pawnDefined PreProc
hi def link pawnFunction Function
hi def link pawnTag Type
hi def link pawnIterIndent Error
hi def link pawnNumberError Error
hi def link pawnNumber Number
hi def link pawnFloat Float
hi def link pawnEscapeError Error
hi def link pawnEscape SpecialChar
hi def link pawnFormatError Error
hi def link pawnFormat SpecialChar
hi def link pawnContinuation SpecialChar
hi def link pawnBadContinuation Error
hi def link pawnString String
hi def link pawnCharacter Character
hi def link pawnTodo Todo
hi def link pawnTodoHigh Todo
hi def link pawnTodoLow Todo
hi def link pawnNote Todo
hi def link pawnCommentError Error
hi def link pawnCommentL Comment
hi def link pawnComment Comment
hi def link pawnPreProc PreProc
hi def link pawnPreProcBadWord Error
hi def link pawnPreCondit PreCondit
hi def link pawnInclude Include
hi def link pawnIncluded String
hi def link pawnDefine Define
hi def link pawnMacroName Macro
hi def link pawnMacroFunc Function
hi def link pawnMacroParam Identifier
hi def link pawnStringify String
hi def link pawnPaste PreProc
hi def link pawnUndefName Macro
hi def link pawnPragmaName PreProc
hi def link pawnPreProcMsg String
hi def link pawnEmitOp Function

let b:current_syntax = "pawn"

let &cpo = s:cpo_save
unlet s:cpo_save
