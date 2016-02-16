if exists('g:loaded_phpfmt_plugin') || &compatible
    finish
endif
let g:loaded_phpfmt_plugin = 1

if has('reltime')
    let g:_PHPFMT_START = reltime()
    lockvar! g:_PHPFMT_START
endif

for s:feature in [
            \ 'autocmd',
            \ 'reltime'
        \ ]
    if !has(s:feature)
        call phpfmt#log#error('need Vim compiled with feature ' . s:feature)
        finish
    endif
endfor

if !exists('g:phpfmt_command')
    let g:phpfmt_command = 'phpcbf'
endif

if !exists('g:phpfmt_options')
    let g:phpfmt_options = ''
endif

if !exists('g:phpfmt_tmp_dir')
    let g:phpfmt_tmp_dir = '/tmp/'
else
    let g:phpfmt_tmp_dir = fnamemodify(g:phpfmt_tmp_dir, ':p:h') . '/'
endif

command! -bar PhpFmt call phpfmt#fmt#format()

augroup phpfmt
    autocmd!
    autocmd BufWritePre *.php call phpfmt#fmt#format()
augroup END
