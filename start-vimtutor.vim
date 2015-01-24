set nocompatible
filetype plugin indent on
syntax on
hi! link Conceal Operator
hi! link FoldColumn Comment
hi! link SignColumn Normal
let s:tutor_plug = globpath(&rtp, 'plugin/tutor-mode.vim', '', 1)
if len(s:tutor_plug) > 0
    runtime plugin/tutor-mode
else
    exe 'let &rtp.=",'.expand("<sfile>:h").'"'
    exe "so ". expand("<sfile>:h")."/plugin/tutor-mode.vim"
endif
VimTutor
set ft=tutor
