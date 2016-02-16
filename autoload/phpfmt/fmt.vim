if exists('g:loaded_phpfmt_fmt_autoload') || !exists('g:loaded_phpfmt_plugin')
    finish
endif
let g:loaded_phpfmt_fmt_autoload = 1

function! phpfmt#fmt#format() abort "{{{
    " save cursor position and many other things
    let l:curw = winsaveview()
    " Write current unsaved buffer to a temp file
    let l:tmpdir = g:phpfmt_tmp_dir . expand('%:h')
    if !isdirectory(l:tmpdir)
        execute 'silent! !mkdir -p ' . shellescape(l:tmpdir, 1)
    endif
    let l:tmpname = g:phpfmt_tmp_dir . expand('%')
    call writefile(getline(1, '$'), l:tmpname)
    " populate the final command with user based fmt options
    let command = g:phpfmt_command . ' ' . g:phpfmt_options
    " execute our command...
    call system(command . ' ' . l:tmpname)
    " remove undo point caused via BufWritePre
    try | silent undojoin | catch | endtry
    " reload buffer
    let old_fileformat = &fileformat
    call rename(l:tmpname, expand('%'))
    silent edit!
    let &fileformat = old_fileformat
    let &syntax = &syntax
    " restore our cursor/windows positions
    call winrestview(l:curw)
endfunction "}}}
