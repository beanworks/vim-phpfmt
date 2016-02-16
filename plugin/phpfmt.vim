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
            \ 'system',
            \ 'reltime'
        \ ]
    if !has(s:feature)
        call phpfmt#log#error('need Vim compiled with feature ' . s:feature)
        finish
    endif
endfor

if !exists('g:phpfmt_command')
    call phpfmt#log#error('setting g:phpfmt_command is missing')
    finish
endif

if !exists('g:phpfmt_options')
    call phpfmt#log#error('setting g:phpfmt_options is missing')
    finish
endif

if !exists('g:phpfmt_tmp_dir')
    call phpfmt#log#error('setting g:phpfmt_tmp_dir is missing')
    finish
endif

augroup phpfmt
    autocmd!
    autocmd BufWritePre *.php call phpfmt#fmt#format()
augroup END
