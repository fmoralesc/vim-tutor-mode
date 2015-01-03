call tutor#SetupVim()

if !exists('g:tutor_debug') || g:tutor_debug == 0
    setlocal buftype=nofile
    setlocal concealcursor+=inv
    setlocal conceallevel=2
    setlocal cursorline
else
    setlocal buftype=
    setlocal concealcursor&
    setlocal conceallevel=0
    setlocal textwidth=80
    setlocal nocursorline
endif


setlocal foldmethod=expr
setlocal foldexpr=tutor#TutorFolds()
setlocal foldcolumn=3
setlocal foldlevel=4

setlocal statusline=%{toupper(expand('%:t:r'))}\ tutorial%=
setlocal statusline+=%{tutor#InfoText()}

function! s:CheckMaps()
    nmap
endfunction

function! s:MapKeyWithRedirect(key, cmd) 
    if maparg(a:key) != ''
        redir => l:keys
        silent call s:CheckMaps()
        redir END
        let l:key_list = split(l:keys, '\n')

        let l:raw_map = filter(copy(l:key_list), "v:val =~ '\\* ".a:key."'")
        if len(l:raw_map) == 0
            exe "noremap <buffer> <expr> ".a:key." ".a:cmd
            return
        endif
        let l:map_data = split(l:raw_map[0], '\s*')
        
        exe "noremap <buffer> <expr> ".l:map_data[0]." ".a:cmd
    else
        exe "noremap <buffer> <expr> ".a:key." ".a:cmd
    endif
endfunction

call s:MapKeyWithRedirect('l', 'tutor#ForwardSkipConceal(v:count1)')
call s:MapKeyWithRedirect('h', 'tutor#BackwardSkipConceal(v:count1)')
call s:MapKeyWithRedirect('<right>', 'tutor#ForwardSkipConceal(v:count1)')
call s:MapKeyWithRedirect('<left>', 'tutor#ForwardSkipConceal(v:count1)')

noremap <silent> <buffer> <CR> :call tutor#FollowLink(0)<cr>
noremap <silent> <buffer> <2-LeftMouse> :call tutor#FollowLink(0)<cr>
noremap <silent> <buffer> ? :call tutor#FollowHelp()<cr>

call tutor#SetSampleTextMappings()

sign define tutorok text=✓ texthl=tutorOK
sign define tutorbad text=✗ texthl=tutorX

call tutor#PlaceXMarks()
au! TextChanged <buffer> call tutor#OnTextChanged()
au! TextChangedI <buffer> call tutor#OnTextChanged()
