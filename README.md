# vim-tutor-mode

Create and follow interactive tutorials for vim.

### Ideas, suggestions, bug reports, code and tutorials are welcome! :)

# Screenshots

![screenshot 1 - Tutor command](http://i.imgur.com/I1rAivL.png)

![screenshot 2 - vimtutor](http://i.imgur.com/1JtpjET.png)

![screenshot 3 - learnvim](http://i.imgur.com/EvjIu09.png)

# Installation

vim-tutor-mode uses the `+conceal` feature extensively, so a vim version >= 7.4
is suggested.

Using a plugin manager like [vim-plug](https://github.com/junegunn/vim-plug),
simply add

    Plug 'fmoralesc/vim-tutor-mode'

to your vimrc. Otherwise copy this repo to your `~/.vim` folder.

# Usage

~~~ vim
:Tutor 00-vimtutor
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
