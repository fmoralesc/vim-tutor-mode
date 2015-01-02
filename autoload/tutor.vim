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

function! tutor#PlaceXMarks()
    call cursor(1, 1)
    let b:tutor_sign_id = 1
    while search('^--->', 'W') > 0
        call tutor#CheckText()
        let b:tutor_sign_id+=1
    endwhile
    call cursor(1, 1)
endfunction

function! tutor#CheckText()
    let l:text = getline('.')
    if match(l:text, '{expect:NULL}\s*$') == -1
        if match(getline('.'), '|expect:.\+|') == -1
            let l:cur_text = matchstr(l:text, '---> \zs.\{-}\ze {expect:')
            let l:expected_text = matchstr(l:text, '{expect:\zs.*\ze}\s*$')
        else
            let l:cur_text = matchstr(l:text, '---> \zs.\{-}\ze |expect:')
            let l:expected_text = matchstr(l:text, '|expect:\zs.*\ze|\s*$')
        endif
        if l:cur_text ==# l:expected_text
            exe "sign place ".b:tutor_sign_id." line=".line('.')." name=tutorok buffer=".bufnr('%')
        else
            exe "sign place ".b:tutor_sign_id." line=".line('.')." name=tutorbad buffer=".bufnr('%')
        endif
    endif
endfunction

function! tutor#SetSampleTextMappings()
    noremap <silent> <buffer> A :if match(getline('.'), '^--->') > -1 \| call search('.\s{\@=', 'Wc') \| startinsert \| else \| startinsert! \| endif<cr>
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


function! tutor#OnTextChanged()
    if match(getline('.'), '^--->') > -1
        call tutor#CheckText()
    endif
endfunction

let s:path = expand('<sfile>:h:h')."/tutorials/"

function! tutor#TutorCmdComplete(lead,line,pos)
    let l:tutorials = glob(s:path."*.tutor", 0, 1)
    return map(tutorials, 'fnamemodify(v:val, ":t:r")')
endfunction
