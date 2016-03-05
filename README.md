# vim-phpfmt

PHP auto format plugin for vim. It works seamlessly with phpcbf, and automatically
formats currently editing PHP file on save, or by manually running command `:PhpFmt`.

## Install

Vim-phpfmt follows the standard runtime path structure, so we highly recommend to
use a common and well known plugin manager to install vim-phpfmt. For Pathogen just
clone the repo. For other plugin managers add the appropriate lines and execute the
plugin's install command.

* [Pathogen](https://github.com/tpope/vim-pathogen): `git clone https://github.com/beanworks/vim-phpfmt.git ~/.vim/bundle/vim-phpfmt`
* [vim-plug](https://github.com/junegunn/vim-plug): `Plug 'beanworks/vim-phpfmt'`
* [NeoBundle](https://github.com/Shougo/neobundle.vim): `NeoBundle 'beanworks/vim-phpfmt'`
* [Vundle](https://github.com/gmarik/vundle): `Plugin 'beanworks/vim-phpfmt'`

## Settings

By default `third_party/phpcbf.phar` is used to format PHP code with `PSR2` as the
default standard. To change to a different standard type or file, add the following
setting to your vimrc file:

```vim
" A standard type: PEAR, PHPCS, PSR1, PSR2, Squiz and Zend
let g:phpfmt_standard = 'PSR2'

" Or your own defined source of standard (absolute or relative path):
let g:phpfmt_standard = '/path/to/custom/standard.xml'
```

Vim-phpfmt will first writes buffer to a temp file in the temp folder configured, then runs
phpcbf over the temp file, and then copies formatted content back to the editing view, and
restores cursor position.

Auto format on save is enabled by default, to disable it:

```vim
let g:phpfmt_autosave = 0
```

For more precise control, you can specify paths to your own phpcbf executable, or another
PHP formatter of your choice. You can also set up a different temp file storing folder for
intermediate formatting buffer:

```vim
let g:phpfmt_command = '/path/to/phpcbf'
let g:phpfmt_tmp_dir = '/path/to/tmp/folder'
```

## Usage

Once the settings are in place, invoke command `:PhpFmt` to call the formatter. If auto
format is enabled by setting `:w` or `:x` will automatically triggers the formatter.

## Working with Docker

If you are using docker for dev, and having phpcbf executable installed inside the container,
along with your own standard source. You can still use vim-phpfmt.

Assume you have mounted source code folders as volumes to the container, you can then change
the settings to:

```vim
" NOTE: all the paths below should be pointing to executable, standard file,
"       and tmp folder that are actually inside the container
let g:phpfmt_command = 'docker exec container_name /path/to/phpcbf'
let g:phpfmt_options = '--standard=/path/to/custom/standard.xml --encoding=utf-8'
let g:phpfmt_tmp_dir = '/path/to/tmp/folder'
```
