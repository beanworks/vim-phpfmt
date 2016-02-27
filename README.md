# vim-phpfmt

PHP auto format plugin for vim. It works seamlessly with phpcbf, and automatically
formats currently editing php file on save, or by manually running command `:PhpFmt`.

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

By default `phpcbf` will be used to format PHP code. To change the formatter settings:

```vim
let g:phpfmt_command = '/path/to/phpcbf'
let g:phpfmt_options = '--encoding=utf-8'
let g:phpfmt_tmp_dir = '/path/to/tmp/folder'
```

Vim-phpfmt will first writes buffer to a temp file in the temp folder configured, then runs
phpcbf over the temp file, and then copies formatted content back to the editing view, and
restores cursor position.

Auto format on save is enabled by default, to disable it:

```vim
let g:phpfmt_autosave = 0
```

## Usage

Once the settings are in place, invoke command `:PhpFmt` to call the formatter. If auto
format is enabled by setting `:w` or `:x` will automatically triggers the formatter.

## Working with Docker

If you are using docker for dev, and having phpcbf installed inside the container. You
can still use vim-phpfmt.

Assume you have mounted the folder that contains all the code as a volume to the container,
you can change your settings to:

```vim
let g:phpfmt_command = 'docker exec container_name path/to/phpcbf'
let g:phpfmt_options = '--standard=path/to/custom_style.xml --encoding=utf-8'
let g:phpfmt_tmp_dir = 'path/to/tmp/folder'
```
