syn include @VIM syntax/vim.vim

syn region tutorVIML matchgroup=Delimiter start=/^\~\{3} viml$/ end=/^\~\{3}/ contains=@VIM concealends

syn match tutorLink /\[.\+\](.*)/ contains=tutorInlineNormalVIML
syn match tutorLinkBands /\[\|\]\|(\|)/ contained containedin=tutorLink,tutorLinkAnchor conceal
syn match tutorLinkAnchor /(.*)/ contained containedin=tutorLink conceal

syn match tutorSection /^#\{1,6}\s.\+$/ fold
syn match tutorSectionBullet /#\{1,6}/ contained containedin=tutorSection conceal cchar=+
syn match tutorInternalAnchor /\*[[:alnum:]-]\+\*/ conceal containedin=tutorSection

syn region tutorLesson matchgroup=Delimiter start=/\*\{2}\s\+/ end=/\s\+\*\{2}/ concealends contains=tutorInlineNormalVIML

syn match tutorTextMark /--->/ conceal cchar=→
syn region tutorSampleText start=/^\(--->\)\@=/ end=/$/ keepend
syn match tutorSampleTextMark /--->/ contained containedin=tutorSampleText conceal cchar=→

syn keyword tutorMarks TODO NOTE IMPORTANT TIP

hi! tutorLink cterm=underline gui=underline ctermfg=lightblue guifg=#0088ff 
hi! link tutorLinkBands Operator
hi! link tutorLinkAnchor Identifier
hi! link tutorInternalAnchor Identifier
hi! link tutorSection Title

hi! tutorLesson cterm=bold gui=bold
hi! tutorMarks cterm=bold gui=bold

hi! link tutorSampleText Special

syn region tutorNormalVIML matchgroup=Delimiter start=/^\~\{3} normal$/ end=/^\~\{3}/ concealends
syn region tutorInlineNormalVIML matchgroup=Delimiter start=/«/ end=/»/ concealends
syn match tutorNormalOp /[dcrypx]/ contained containedin=tutorNormalVIML,tutorInlineNormalVIML
syn match tutorNormalMod /[ia]/ contained containedin=tutorNormalVIML,tutorInlineNormalVIML 
syn match tutorNormalObject /["'()<>BW\[\]`bpstw{}]/ contained containedin=tutorNormalVIML,tutorInlineNormalVIML
syn match tutorNormalCount /[0-9]/ contained containedin=tutorNormalVIML,tutorInlineNormalVIML

hi! link tutorNormalOp Operator
hi! link tutorNormalMod PreProc
hi! link tutorNormalObject Structure
hi! link tutorNormalCount Number

