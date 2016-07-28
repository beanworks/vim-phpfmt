if exists('g:loaded_phpfmt_fmt_autoload') || !exists('g:loaded_phpfmt_plugin')
    finish
endif
let g:loaded_phpfmt_fmt_autoload = 1

function! phpfmt#fmt#autoformat() abort "{{{
    if get(g:, 'phpfmt_autosave', 1)
        call phpfmt#fmt#format()
    endif
endfunction "}}}

function! phpfmt#fmt#format() abort "{{{
    if g:phpfmt_experimental == 1
        " Using winsaveview to save/restore cursor state has the problem of
        " closing folds on save. One fix is to use mkview instead. Unfortunately,
        " this sometimes causes other bad side effects, and still closes all folds
        " if foldlevel>0.
        let l:curw = {}
        try
            mkview!
        catch
            let l:curw=winsaveview()
        endtry
    else
        " Save cursor position and many other things.
        let l:curw=winsaveview()
    endif

    " Write current unsaved buffer to a temp file
    if exists('g:phpfmt_tmp_dir')
        let l:tmpdir = g:phpfmt_tmp_dir . expand('%:h')
        if !isdirectory(l:tmpdir)
            exe 'silent! !mkdir -p ' . shellescape(l:tmpdir, 1)
        endif
        let l:tmpname = g:phpfmt_tmp_dir . expand('%')
    else
        let l:tmpname = tempname()
    endif
    call writefile(getline(1, '$'), l:tmpname)

    if g:phpfmt_experimental == 1
        " save our undo file to be restored after we are done. This is needed to
        " prevent an additional undo jump due to BufWritePre auto command and also
        " restore 'redo' history because it's getting being destroyed every
        " BufWritePre
        let tmpundofile=tempname()
        exe 'wundo! ' . tmpundofile
    endif

    " populate the final command with user based fmt options
    let command = g:phpfmt_command . ' ' . g:phpfmt_options
    " execute our system command...
    call system(command . ' ' . l:tmpname)

    " remove undo point caused via BufWritePre
    try | silent undojoin | catch | endtry
    " reload buffer
    let old_fileformat = &fileformat
    call rename(l:tmpname, expand('%'))
    silent edit!
    let &fileformat = old_fileformat
    let &syntax = &syntax

    if g:phpfmt_experimental == 1
        " restore our undo history
        silent! exe 'rundo ' . tmpundofile
        call delete(tmpundofile)
    endif

    if g:phpfmt_experimental == 1
        " Restore our cursor/windows positions, folds, etc.
        if empty(l:curw)
            silent! loadview
        else
            call winrestview(l:curw)
        endif
    else
        " Restore our cursor/windows positions.
        call winrestview(l:curw)
    endif
endfunction "}}}
