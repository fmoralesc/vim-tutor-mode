syn include @VIM syntax/vim.vim

syn region tutorVIML matchgroup=Delimiter start=/^\~\{3} viml$/ end=/^\~\{3}/ contains=@VIM concealends

syn match tutorLink /\[.\{-}\](.\{-})/ contains=tutorInlineNormalVIML
syn match tutorLinkBands /\[\|\]\|(\|)/ contained containedin=tutorLink,tutorLinkAnchor conceal
syn match tutorLinkAnchor /(.\{-})/ contained containedin=tutorLink conceal

syn match tutorSection /^#\{1,6}\s.\+$/ fold
syn match tutorSectionBullet /#\{1,6}/ contained containedin=tutorSection conceal cchar=+
syn match tutorInternalAnchor /\*[[:alnum:]-]\+\*/ conceal containedin=tutorSection

syn region tutorLesson matchgroup=Delimiter start=/[*!]\{2}\s\+/ end=/\s\+[*!]\{2}/ concealends contains=tutorInlineNormalVIML

syn match tutorTextMark /--->/ conceal cchar=→
syn region tutorSampleText start=/^\(--->\)\@=/ end=/$/ keepend contains=@SPELL
syn match tutorSampleTextMark /--->/ contained containedin=tutorSampleText conceal cchar=→
syn region tutorSampleTextExpect start=/ {expect:/ end=/}/ contained containedin=tutorSampleText conceal

syn region tutorCommand matchgroup=Delimiter start=/^\s\{4,}:/ end=/$/ keepend contains=tutorKey
syn match tutorCommandCmd /\(:\||\s\)\@<=\S\+/ contained containedin=tutorCommand
syn region tutorShellCommand start=/^\s\{4,}\$/ end=/$/ keepend contains=tutorKey
syn match tutorShellPrompt /\$/ contained containedin=tutorShellCommand

syn keyword tutorMarks TODO NOTE IMPORTANT TIP ATTENTION
syn match tutorTOC /\ctable of contents:/

syn match tutorInlineOK /✓/
syn match tutorInlineX /✗/

hi! tutorLink cterm=underline gui=underline ctermfg=lightblue guifg=#0088ff 
hi! link tutorLinkBands Operator
hi! link tutorLinkAnchor Identifier
hi! link tutorInternalAnchor Identifier
hi! link tutorSection Title

hi! link tutorTOC Directory

hi! tutorLesson cterm=bold gui=bold
hi! tutorMarks cterm=bold gui=bold

hi! link tutorSampleText Special 
hi! tutorOK ctermfg=green guifg=#00ff88 cterm=bold gui=bold
hi! tutorX ctermfg=red guifg=#ff2000  cterm=bold gui=bold
hi! link tutorInlineOK tutorOK
hi! link tutorInlineX tutorX

hi! link tutorCommand String
hi! link tutorCommandCmd Statement
hi! link tutorShellCommand Directory
hi! link tutorShellPrompt Delimiter

syn region tutorNormalVIML matchgroup=Delimiter start=/^\~\{3} normal$/ end=/^\~\{3}/ concealends contains=tutorKey
syn region tutorInlineNormalVIML matchgroup=Delimiter start=/«/ end=/»/ concealends contains=tutorKey
syn match tutorNormalOp /[dcrypx!"#$%&.-\/:<>=?@ABCDGHIJKLMNOPQRSUVWXYZgmqstz~]/ contained containedin=tutorNormalVIML,tutorInlineNormalVIML nextgroup=tutorNormalMod
syn match tutorNormalMod /m\@<![ia]/ contained  
syn match tutorNormalObject /["'()<>BW\[\]`bstweE{}ftFT;,]/ contained containedin=tutorNormalVIML,tutorInlineNormalVIML
syn match tutorNormalCount /[0-9]/ contained containedin=tutorNormalVIML,tutorInlineNormalVIML
syn region tutorNormalSearch start=/[/?]\@<=./ end=/.<CR>\@=/ contained containedin=tutorNormalVIML,tutorInlineNormalVIML contains=tutorKey keepend
syn region tutorNormalChange start=/\([cr][wWbBeE()<>\[\]{}pst]\)\@<=./ end=/.<Esc>\@=/ contained containedin=tutorNormalVIML,tutorInlineNormalVIML contains=tutorKey keepend
syn match tutorNormalCharSearch /\c[ft]\@<=\w/ contained containedin=tutorNormalVIML,tutorInlineNormalVIML
syn match tutorNormalMark /\(f\@<!m\)\@<=[a-zA-Z0-9]/ contained containedin=tutorNormalVIML,tutorInlineNormalVIML

syn match tutorKey /<'\@!.\{-}>'\@!/ 

hi! link tutorNormalOp Operator
hi! link tutorNormalMod PreProc
hi! link tutorNormalObject Structure
hi! link tutorNormalCount Number
hi! link tutorNormalMark Identifier

hi! link tutorkey Special
