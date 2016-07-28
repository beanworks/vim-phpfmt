if exists('g:loaded_phpfmt_plugin') || &compatible
    finish
endif
let g:loaded_phpfmt_plugin = 1
let g:phpfmt_root_dir = fnamemodify(globpath(&rtp, "plugin/phpfmt.vim"), ":h:h")

for s:feature in [
            \ 'autocmd',
            \ 'reltime'
        \ ]
    if !has(s:feature)
        call phpfmt#log#error('need Vim compiled with feature ' . s:feature)
        finish
    endif
endfor

if has('reltime')
    let g:_PHPFMT_START = reltime()
    lockvar! g:_PHPFMT_START
endif

if !exists('g:phpfmt_command')
    let g:phpfmt_command = g:phpfmt_root_dir . '/third_party/phpcbf.phar'
    if !executable(g:phpfmt_command)
        call phpfmt#log#error('oops, phpcbf.phar is not executable. Check ' . g:phpfmt_command)
    endif
endif

if !exists('g:phpfmt_standard')
    let g:phpfmt_options = '--standard=PSR2 --encoding=utf-8'
else
    let g:phpfmt_options = '--standard=' . g:phpfmt_standard . ' --encoding=utf-8'
endif

if !exists("g:phpfmt_experimental")
    let g:phpfmt_experimental = 0
endif

command! -bar PhpFmt call phpfmt#fmt#format()

augroup vim-phpfmt
    autocmd!
    autocmd BufWritePre *.php call phpfmt#fmt#autoformat()
augroup END
