#!/bin/bash

cd $HOME/.cfg
for cfg in $(ls -A); do
	if [[ $cfg != ".git" ]] && [[ $cfg != "install.sh" ]]; then cp -R $cfg $HOME; fi
done
