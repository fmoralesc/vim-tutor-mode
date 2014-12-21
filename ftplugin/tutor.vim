setlocal conceallevel=2
setlocal concealcursor=nv
if !exists('g:tutor_debug') || g:tutor_debug == 0
    setlocal concealcursor+=i
endif

setlocal foldmethod=expr
setlocal foldexpr=tutor#TutorFolds()
setlocal foldcolumn=3
setlocal foldlevel=2
setlocal cursorline

setlocal statusline=%{toupper(expand('%:t:r'))}\ tutorial%=
setlocal statusline+=%{tutor#InfoText()}

if !exists('g:tutor_debug') || g:tutor_debug == 0
    setlocal buftype=nofile
endif

noremap <buffer> <expr> l tutor#ForwardSkipConceal(v:count1)
noremap <buffer> <expr> h tutor#BackwardSkipConceal(v:count1)
noremap <buffer> <expr> <right> tutor#ForwardSkipConceal(v:count1)
noremap <buffer> <expr> <left> tutor#BackwardSkipConceal(v:count1)
noremap <silent> <buffer> <CR> :call tutor#FollowLink(0)<cr>
noremap <silent> <buffer> <2-LeftMouse> :call tutor#FollowLink(0)<cr>
noremap <silent> <buffer> ? :call tutor#FollowHelp()<cr>

