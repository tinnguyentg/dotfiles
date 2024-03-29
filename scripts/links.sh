#!/usr/bin/env bash

link_dot_files() {
	if [ -f $HOME/.zshrc ]; then
		mv $HOME/.zshrc $HOME/.zshrc.bak
	fi
	ln -sf $PWD/.zshrc $HOME/.zshrc

	if [ -f $HOME/.mytheme.omp.json ]; then
		mv $HOME/.mytheme.omp.json $HOME/.mytheme.omp.json.bak
	fi
	ln -sf $PWD/.mytheme.omp.json $HOME/.mytheme.omp.json

	if [ -f $HOME/.bash_aliases ]; then
		mv $HOME/.bash_aliases $HOME/.bash_aliases.bak
	fi
	ln -sf $PWD/.bash_aliases $HOME/.bash_aliases

	if [ -f $HOME/.env ]; then
		mv $HOME/.env $HOME/.env.bak
	fi
	cp -n $PWD/.env.example $PWD/.env
	ln -sf $PWD/.env $HOME/.env

	mkdir -p $HOME/.functions
	cp -r $PWD/.functions/* $HOME/.functions/
}
