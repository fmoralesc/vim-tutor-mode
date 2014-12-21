syn include @VIM syntax/vim.vim

syn region tutorVIML matchgroup=Delimiter start=/^:/ end=/^\~\{3}/ contains=@VIM concealends

syn match tutorLink /\[.\+\](.*)/
syn match tutorLinkBands /\[\|\]\|(\|)/ contained containedin=tutorLink,tutorLinkAnchor conceal
syn match tutorLinkAnchor /(.*)/ contained containedin=tutorLink conceal

syn match tutorSection /^#\{,6}\s.\+$/ fold
syn match tutorSectionBullet /#\{,6}/ contained containedin=tutorSection conceal cchar=+

syn match tutorInternalAnchor /\*[[:alnum:]-]\+\*/ conceal containedin=tutorSection

hi! link tutorLink Label
hi! link tutorLinkBands Operator
hi! link tutorLinkAnchor Identifier
hi! link tutorInternalAnchor Identifier
hi! link tutorSection Title

syn region tutorNormalVIML matchgroup=Delimiter start=/^-/ end=/^\~\{3}/ concealends
syn match tutorNormalOp /[dcryp]/ contained containedin=tutorNormalVIML
syn match tutorNormalMod /[ia]/ contained containedin=tutorNormalVIML
syn match tutorNormalObject /["'()<>BW\[\]`bpstw{}]/ contained containedin=tutorNormalVIML

hi! link tutorNormalOp Operator
hi! link tutorNormalMod PreProc
hi! link tutorNormalObject Structure

