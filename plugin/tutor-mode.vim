if exists('g:loaded_tutor_mode_plugin') || &compatible
    finish
endif
let g:loaded_tutor_mode_plugin = 1

" disable the indent guides plugin in tutor files, to reduce clutter
if exists('g:indent_guides_exclude_filetypes')
    call add(g:indent_guides_exclude_filetypes, 'tutor')
endif

command! -nargs=1 -complete=custom,tutor#TutorCmdComplete Tutor call tutor#TutorCmd(<f-args>)
command! -nargs=0 VimTutor Tutor 01-vim-beginner
