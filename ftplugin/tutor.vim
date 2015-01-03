" vim: set fdm=marker :

" Base: {{{1
call tutor#SetupVim()

" Buffer Settings: {{{1
if !exists('g:tutor_debug') || g:tutor_debug == 0
    setlocal buftype=nofile
    setlocal concealcursor+=inv
    setlocal conceallevel=2
    setlocal cursorline
else
    setlocal buftype=
    setlocal concealcursor&
    setlocal conceallevel=0
    setlocal nocursorline
endif

setlocal foldmethod=expr
setlocal foldexpr=tutor#TutorFolds()
setlocal foldcolumn=3
setlocal foldlevel=4

setlocal statusline=%{toupper(expand('%:t:r'))}\ tutorial%=
setlocal statusline+=%{tutor#InfoText()}

" Mappings: {{{1

call tutor#SetNormalMappings()
call tutor#SetSampleTextMappings()

" Checks: {{{1

sign define tutorok text=✓ texthl=tutorOK
sign define tutorbad text=✗ texthl=tutorX

call tutor#PlaceXMarks()
au! TextChanged <buffer> call tutor#OnTextChanged()
au! TextChangedI <buffer> call tutor#OnTextChanged()
