let s:vimtutor = expand('<sfile>:h:h')."/tutorials/vimtutor.tutor"
exe "command! -nargs=0 VimTutor :e ".s:vimtutor
