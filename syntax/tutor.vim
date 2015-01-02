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

syn region tutorCommand start=/^\s\{4,}:/ end=/$/ keepend
syn region tutorShellCommand start=/^\s\{4,}\$/ end=/$/ keepend
syn match tutorShellPrompt /\$/ contained containedin=tutorShellCommand

syn keyword tutorMarks TODO NOTE IMPORTANT TIP ATTENTION

syn match tutorKey /<'\@!.\{-}>'\@!/ 

syn match tutorInlineOK /✓/
syn match tutorInlineX /✗/

hi! tutorLink cterm=underline gui=underline ctermfg=lightblue guifg=#0088ff 
hi! link tutorLinkBands Operator
hi! link tutorLinkAnchor Identifier
hi! link tutorInternalAnchor Identifier
hi! link tutorSection Title

hi! tutorLesson cterm=bold gui=bold
hi! tutorMarks cterm=bold gui=bold

hi! link tutorSampleText Special 
hi! tutorOK ctermfg=green guifg=#00ff88 cterm=bold gui=bold
hi! tutorX ctermfg=red guifg=#ff2000  cterm=bold gui=bold
hi! link tutorInlineOK tutorOK
hi! link tutorInlineX tutorX

hi! link tutorCommand Statement
hi! link tutorShellCommand Directory
hi! link tutorShellPrompt Delimiter

syn region tutorNormalVIML matchgroup=Delimiter start=/^\~\{3} normal$/ end=/^\~\{3}/ concealends
syn region tutorInlineNormalVIML matchgroup=Delimiter start=/«/ end=/»/ concealends
syn match tutorNormalOp /[dcrypx!"#$%&,.-\/:;<>=?@ABCDEFGHIJKLMNOPQRSTUVWXYZfgqstz~]/ contained containedin=tutorNormalVIML,tutorInlineNormalVIML nextgroup=tutorNormalMod
syn match tutorNormalMod /[ia]/ contained  
syn match tutorNormalObject /["'()<>BW\[\]`bpstwe{}]/ contained containedin=tutorNormalVIML,tutorInlineNormalVIML
syn match tutorNormalCount /[0-9]/ contained containedin=tutorNormalVIML,tutorInlineNormalVIML

hi! link tutorNormalOp Operator
hi! link tutorNormalMod PreProc
hi! link tutorNormalObject Structure
hi! link tutorNormalCount Number

hi! link tutorkey Special
