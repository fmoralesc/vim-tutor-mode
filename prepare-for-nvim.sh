#!/usr/bin/env bash

if [[ $1 == "package" ]]
then
	echo "packaging for neovim..."
	if [ -d runtime ]
	then
		rm -r runtime
	fi
	mkdir -p runtime/{tutorials,doc}

	cp -a {autoload,ftplugin,plugin,syntax} runtime/
	cp -a doc/pi_tutor.txt runtime/doc/
	cp -a tutorials/en runtime/tutorials/
	cp -a tutorials/tutor.tutor runtime/tutorials/

	tar -cJf tutor.tar.xz runtime/
	rm -r runtime
elif [[ $1 == "apply" ]]
then
	if [ -z "$VIMRUNTIME" ]
	then
		echo "please set \$VIMRUNTIME"
		exit -1
	fi
	if [ -e "tutor.tar.xz" ]
	then
		echo
	else
		./prepare-for-nvim.sh package
	fi
	cp tutor.tar.xz "$VIMRUNTIME/.."
	cd "$VIMRUNTIME/.."
	tar -xf tutor.tar.xz
	rm tutor.tar.xz
	echo "please review and commit the changes"
fi

# vim: noet
