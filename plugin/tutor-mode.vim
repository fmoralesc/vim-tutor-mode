let s:path = expand('<sfile>:h:h')."/tutorials"
exe "command! -nargs=1 -complete=customlist,tutor#TutorCmdComplete Tutor :e ".s:path."/<args>.tutor"
command! -nargs=0 VimTutor Tutor vimtutor
