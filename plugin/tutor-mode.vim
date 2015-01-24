command! -nargs=1 -complete=custom,tutor#TutorCmdComplete Tutor call tutor#TutorCmd(<f-args>)
command! -nargs=0 VimTutor Tutor 00-vimtutor
