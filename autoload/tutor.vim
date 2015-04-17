" vim: fdm=marker

" Setup: {{{1
function! tutor#SetupVim()
    if has('syntax')
        if !exists(g:syntax_on) || g:syntax_on == 0
            syntax on
        endif
    endif
endfunction

" Mappings: {{{1

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
            exe "nnoremap <buffer> <expr> ".a:key." ".a:cmd
            return
        endif
        let l:map_data = split(l:raw_map[0], '\s*')

        exe "nnoremap <buffer> <expr> ".l:map_data[0]." ".a:cmd
    else
        exe "nnoremap <buffer> <expr> ".a:key." ".a:cmd
    endif
endfunction

function! tutor#MouseDoubleClick()
    if foldclosed(line('.')) > -1
        normal  zo
    else
        if match(getline('.'), '^#\{1,} ') > -1
            normal zc
        else
            call tutor#FollowLink(0)
        endif
    endif
endfunction

function! tutor#InjectCommand()
    let l:cmd = substitute(getline('.'),  '^\s*', '', '')
    exe l:cmd
    redraw | echohl WarningMsg | echon  "tutor: ran" | echohl None | echon " " | echohl Statement | echon l:cmd
endfunction

function! tutor#SetNormalMappings()
    call s:MapKeyWithRedirect('l', 'tutor#ForwardSkipConceal(v:count1)')
    call s:MapKeyWithRedirect('h', 'tutor#BackwardSkipConceal(v:count1)')
    call s:MapKeyWithRedirect('<right>', 'tutor#ForwardSkipConceal(v:count1)')
    call s:MapKeyWithRedirect('<left>', 'tutor#BackwardSkipConceal(v:count1)')

    nnoremap <silent> <buffer> <CR> :call tutor#FollowLink(0)<cr>
    nnoremap <silent> <buffer> <2-LeftMouse> :call tutor#MouseDoubleClick()<cr>
    nnoremap <silent> <buffer> ? :call tutor#FollowHelp()<cr>
    nnoremap <buffer> >> :call tutor#InjectCommand()<cr>
endfunction

function! tutor#SetSampleTextMappings()
    noremap <silent> <buffer> A :if match(getline('.'), '^--->') > -1 \| call search('\s{\@=', 'Wc') \| startinsert \| else \| startinsert! \| endif<cr>
    noremap <silent> <buffer> $ :if match(getline('.'), '^--->') > -1 \| call search('.\s{\@=', 'Wc') \| else \| call search('$', 'Wc') \| endif<cr>
    onoremap <silent> <buffer> $ :if match(getline('.'), '^--->') > -1 \| call search('.\s{\@=', 'Wc') \| else \| call search('$', 'Wc') \| endif<cr>
    noremap <silent> <buffer> ^ :if match(getline('.'), '^--->') > -1 \| call search('\(--->\s\)\@<=.', 'bcW') \| else \| call search('^', 'bcW') \|endif<cr>
    onoremap <silent> <buffer> ^ :if match(getline('.'), '^--->') > -1 \| call search('\(--->\s\)\@<=.', 'bcW') \| else \| call search('^', 'bcW') \|endif<cr>
    nmap <silent> <buffer> 0 ^<esc>
    nmap <silent> <buffer> <Home> ^<esc>
    nmap <silent> <buffer> <End> $
    imap <silent> <buffer> <Home> <esc>^<esc>:startinsert<cr>
    imap <silent> <buffer> <End> <esc>$:startinsert<cr>
    noremap <silent> <buffer> I :exe "normal 0" \| startinsert<cr>
endfunction

" Navigation: {{{1

" taken from http://stackoverflow.com/a/24224578

function! tutor#ForwardSkipConceal(count)
    let cnt=a:count
    let mvcnt=0
    let c=col('.')
    let l=line('.')
    let lc=col('$')
    let line=getline('.')
    while cnt
        if c>=lc
            let mvcnt+=cnt
            break
        endif
        if stridx(&concealcursor, 'n')==-1
            let isconcealed=0
        else
            let [isconcealed, cchar, group] = synconcealed(l, c)
        endif
        if isconcealed
            let cnt-=strchars(cchar)
            let oldc=c
            let c+=1
            while c < lc
              let [isconcealed2, cchar2, group2] = synconcealed(l, c)
              if !isconcealed2 || cchar2 != cchar
                  break
              endif
              let c+= 1
            endwhile
            let mvcnt+=strchars(line[oldc-1:c-2])
        else
            let cnt-=1
            let mvcnt+=1
            let c+=len(matchstr(line[c-1:], '.'))
        endif
    endwhile
    return mvcnt.'l'
endfunction

function! tutor#BackwardSkipConceal(count)
    let cnt=a:count
    let mvcnt=0
    let c=col('.')
    let l=line('.')
    let lc=0
    let line=getline('.')
    while cnt
        if c<=1
            let mvcnt+=cnt
            break
        endif
        if stridx(&concealcursor, 'n')==-1 || c == 0
            let isconcealed=0
        else
            let [isconcealed, cchar, group]=synconcealed(l, c-1)
        endif
        if isconcealed
            let cnt-=strchars(cchar)
            let oldc=c
            let c-=1
            while c>1
              let [isconcealed2, cchar2, group2] = synconcealed(l, c-1)
              if !isconcealed2 || cchar2 != cchar
                  break
              endif
              let c-=1
            endwhile
            let c = max([c, 1])
            let mvcnt+=strchars(line[c-1:oldc-2])
        else
            let cnt-=1
            let mvcnt+=1
            let c-=len(matchstr(line[:c-2], '.$'))
        endif
    endwhile
    return mvcnt.'h'
endfunction

" Hypertext: {{{1

function! tutor#FollowLink(force)
    let l:stack_s = join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), '')
    if l:stack_s =~ 'tutorLink'
        let l:link_start = searchpairpos('\[', '', ')', 'nbcW')
        let l:link_end = searchpairpos('\[', '', ')', 'ncW')
        if l:link_start[0] == l:link_end[0]
            let l:linkData = getline(l:link_start[0])[l:link_start[1]-1:l:link_end[1]-1]
        else
            return
        endif
        let l:target = matchstr(l:linkData, '(\@<=.*)\@=')
        if a:force != 1 && match(l:target, '\*.\+\*') > -1
            call cursor(l:link_start[0], l:link_end[1])
            call search(l:target, '')
            normal ^
        elseif a:force != 1 && match(l:target, '^@tutor:') > -1
            let l:tutor = matchstr(l:target, '@tutor:\zs.*')
            exe "Tutor ".l:tutor
        else
            exe "help ".l:target
            noremap <silent> <buffer> q :close<cr>
        endif
    endif
endfunction

function! tutor#FollowHelp()
    if synIDattr(synID(line('.'), col('.'), 0), 'name') == 'tutorLink'
        call tutor#FollowLink(1)
    else
        exe "help " .expand('<cWORD>')
        noremap <silent> <buffer> q :close<cr>
    endif
endfunction

" Folding And Info: {{{1

function! tutor#TutorFolds()
    if getline(v:lnum) =~ '^#\{1,6}'
        return ">". len(matchstr(getline(v:lnum), '^#\{1,6}'))
    else
        return "="
    endif
endfunction

function! tutor#InfoText()
    let l:info_parts = []
    if exists('b:tutor_infofunc')
        call add(l:info_parts, eval(b:tutor_infofunc.'()'))
    endif
    call add(l:info_parts, mode())
    return join(l:info_parts, " ")
endfunction

" Marks {{{1
function! tutor#PlaceXMarks()
    call cursor(1, 1)
    let b:tutor_sign_id = 1
    while search('^--->', 'W') > 0
        call tutor#CheckText(getline('.'))
        let b:tutor_sign_id+=1
    endwhile
    call cursor(1, 1)
endfunction

function! tutor#CheckText(text)
    if match(a:text, '{expect:NULL}\s*$') == -1
        if match(getline('.'), '|expect:.\+|') == -1
            let l:cur_text = matchstr(a:text, '---> \zs.\{-}\ze {expect:')
            let l:expected_text = matchstr(a:text, '{expect:\zs.*\ze}\s*$')
        else
            let l:cur_text = matchstr(a:text, '---> \zs.\{-}\ze |expect:')
            let l:expected_text = matchstr(a:text, '|expect:\zs.*\ze|\s*$')
        endif
        if l:cur_text ==# l:expected_text
            exe "sign place ".b:tutor_sign_id." line=".line('.')." name=tutorok buffer=".bufnr('%')
        else
            exe "sign place ".b:tutor_sign_id." line=".line('.')." name=tutorbad buffer=".bufnr('%')
        endif
    endif
endfunction

function! tutor#OnTextChanged()
    let l:text = getline('.')
    if match(l:text, '^--->') > -1
        call tutor#CheckText(l:text)
    endif
endfunction

" Tutor Cmd: {{{1
function! tutor#TutorCmd(tutor_name)
    if match(a:tutor_name, '\.tutor$') > 0
        let l:tutor_name = fnamemodify(a:tutor_name, ':r')
    else
        let l:tutor_name = a:tutor_name
    endif

    if v:version >= 704 && has('patch279')
        let l:tutors = globpath(&rtp, 'tutorials/'.l:tutor_name.'.tutor', 0, 1)
    else
        let l:tutors = split(globpath(&rtp, 'tutorials/'.l:tutor_name.'.tutor', 0), '\n')
    endif

    if len(l:tutors) == 0
        echom "No tutorials with that name found."
        return
    endif

    if len(l:tutors) == 1
        exe "edit ".l:tutors[0]
    else
        let l:idx = 0
        let l:candidates = ['Several tutorials with that name found. Select one:']
        for candidate in map(l:tutors, 'fnamemodify(v:val, ":h:h:t")."/".fnamemodify(v:val, ":t")')
            let l:idx += 1
            call add(l:candidates, l:idx.'. '.candidate)
        endfor
        let l:tutor_to_open = inputlist(l:candidates)
        exe "edit ".substitute(l:candidates[l:tutor_to_open], '^\d\+. ', '', '')
    endif
endfunction

function! tutor#TutorCmdComplete(lead,line,pos)
    if v:version >= 704 && has('patch279')
        let l:tutors = globpath(&rtp, 'tutorials/*.tutor', 0, 1)
    else
        let l:tutors = split(globpath(&rtp, 'tutorials/*.tutor', 0), '\n')
    endif
    let l:names = uniq(sort(map(l:tutors, 'fnamemodify(v:val, ":t:r")')))
    return join(l:names, "\n")
endfunction

