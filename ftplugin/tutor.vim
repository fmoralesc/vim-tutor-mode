" tajen from http://stackoverflow.com/a/24224578

function! ForwardSkipConceal(count)
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
    return ":\<C-u>\e".mvcnt.'l'
endfunction

function! BackwardSkipConceal(count)
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
    return ":\<C-u>\e".mvcnt.'h'
endfunction

noremap <buffer> <expr> l ForwardSkipConceal(v:count1)
noremap <buffer> <expr> h BackwardSkipConceal(v:count1)
noremap <buffer> <expr> <right> ForwardSkipConceal(v:count1)
noremap <buffer> <expr> <left> BackwardSkipConceal(v:count1)

function! FollowLink(force)
    if synIDattr(synID(line('.'), col('.'), 0), 'name') == 'tutorLink'
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
        endif
    endif
endfunction

function! FollowHelp()
    if synIDattr(synID(line('.'), col('.'), 0), 'name') == 'tutorLink'
        call FollowLink(1)
    else
        exe "help " .expand('<cWORD>')
    endif
endfunction

function! TutorFolds()
    if getline(v:lnum) =~ '^#\{1,6}'
        return ">". len(matchstr(getline(v:lnum), '^#\{1,6}'))
    else
        return "="
    endif
endfunction

setlocal conceallevel=2
setlocal concealcursor=nv
if !exists('g:tutor_debug') || g:tutor_debug == 0
    setlocal concealcursor+=i
endif

setlocal foldmethod=expr
setlocal foldexpr=TutorFolds()
setlocal foldcolumn=3
setlocal foldlevel=2

noremap <silent> <buffer> <CR> :call FollowLink(0)<cr>
noremap <silent> <buffer> ? :call FollowHelp()<cr>

setlocal statusline=%{toupper(expand('%:t:r'))}\ tutorial
setlocal statusline+=%=tutor\ keys:\ 
setlocal statusline+=\<enter>\ \(follow\ tag)\ 
setlocal statusline+=\?\ \(help\ for\ word\ under\ cursor\)

if !exists('g:tutor_debug') || g:tutor_debug == 0
    setlocal buftype=nofile
endif

