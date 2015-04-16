# vim-tutor-mode

Create and follow interactive tutorials.

![](http://i.imgur.com/1JtpjET.png)

## Installation

vim-tutor-mode uses the `+conceal` feature extensively, so Vim version >= 7.4
is suggested.

Using a plugin manager like [vim-plug](https://github.com/junegunn/vim-plug),
add the following to your `vimrc`.

    Plug 'fmoralesc/vim-tutor-mode'

Otherwise copy this repository's contents to your `~/.vim` folder.

This plugin is only available if 'compatible' is not set.

## Usage

~~~ vim
:Tutor 01-vim-beginner
:VimTutor
~~~

To learn how to create tutorials using vim-tutor-mode, see

~~~ vim
:Tutor tutor
~~~

To see an example of how a third party plugin can use a tutorial, see [vim-pad's
tutorial](https://github.com/fmoralesc/vim-pad/blob/devel/tutorials/vim-pad.tutor).

## Credits

Some of the materials included in the plugin are based on work from vim's
maintainers of vimtutor (esp. Michael C. Pierce, Robert K. Ware and Bram
Moolenaar) and in dahu's [LearnVim](https://github.com/dahu/LearnVim).
