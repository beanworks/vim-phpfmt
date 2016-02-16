if exists('g:loaded_phpfmt_log_autoload') || !exists('g:loaded_phpfmt_plugin')
    finish
endif
let g:loaded_phpfmt_log_autoload = 1

function! phpfmt#log#info(msg) abort "{{{
    echomsg 'phpfmt: info: ' . a:msg
endfunction "}}}

function! phpfmt#log#warn(msg) abort "{{{
    echohl WarningMsg
    echomsg 'phpfmt: warning: ' . a:msg
    echohl None
endfunction "}}}

function! phpfmt#log#error(msg) abort "{{{
    execute "normal \<Esc>"
    echohl ErrorMsg
    echomsg 'phpfmt: error: ' . a:msg
    echohl None
endfunction "}}}

function! phpfmt#log#debug(level, msg, ...) abort "{{{
    if !s:_isDebugEnabled(a:level)
        return
    endif

    let leader = s:_log_timestamp()
    call s:_logRedirect(1)

    if a:0 > 0
        " filter out dictionary functions
        echomsg leader . a:msg . ' ' .
            \ strtrans(string(type(a:1) == type({}) || type(a:1) == type([]) ?
            \ filter(copy(a:1), 'type(v:val) != type(function("tr"))') : a:1))
    else
        echomsg leader . a:msg
    endif

    call s:_logRedirect(0)
endfunction "}}}

" ---------- Private functions ----------

function! s:_isDebugEnabled_smart(level) abort "{{{
    return and(g:phpfmt_debug, a:level)
endfunction "}}}

function! s:_isDebugEnabled_dumb(level) abort " {{{
    " poor man's bit test for bit N, assuming a:level == 2**N
    return (g:phpfmt_debug / a:level) % 2
endfunction " }}}

let s:_isDebugEnabled = function(exists('*and') ? 's:_isDebugEnabled_smart' : 's:_isDebugEnabled_dumb')
lockvar s:_isDebugEnabled

function! s:_logRedirect(on) abort "{{{
    if exists('g:phpfmt_debug_file')
        if a:on
            try
                execute 'redir >> ' . fnameescape(expand(g:phpfmt_debug_file, 1))
            catch /\m^Vim\%((\a\+)\)\=:/
                silent! redir END
                unlet g:phpfmt_debug_file
            endtry
        else
            silent! redir END
        endif
    endif
endfunction "}}}

function! s:_log_timestamp_smart() abort "{{{
    return printf('phpfmt: %f: ', reltimefloat(reltime(g:_PHPFMT_START)))
endfunction "}}}

function! s:_log_timestamp_dumb() abort "{{{
    return 'phpfmt: ' . split(reltimestr(reltime(g:_PHPFMT_START)))[0] . ': '
endfunction "}}}

let s:_log_timestamp = function(has('float') && exists('*reltimefloat') ? 's:_log_timestamp_smart' : 's:_log_timestamp_dumb')
lockvar s:_log_timestamp
