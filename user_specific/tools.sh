#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

if [ $(id -u) -ne 0 ]; then exec sudo "$0"; fi

apttools=(
'git-core'
'zsh'
'curl'
'httpie'
'cmus'
'vifm'
'dnstop'
'vnstat'
'iftop'
'atop'
'clang-format'
'sbcl'
'neovim'
'silversearcher-ag'
'rxvt-unicode-256color'
)

repos=(
'ppa:neovim-ppa/stable'
)

piptools=(
'grip'
'neovim'
)

for repo in "${repos[@]}" ; do
	echo "${GREEN}[+] Add repository ${tool} ... ${NC}"
	add-apt-repository "$repo"
	echo "${GREEN}[+] Done${NC}"
done

for tool in "${apttools[@]}" ; do
	echo "${GREEN}[+] Installing ${tool} ... ${NC}"
	if [[ ! $(which "$tool") ]]; then
		apt-get install "$tool"
	fi
	echo "${GREEN}[+] Done${NC}"
done

for tool in "${piptools[@]}" ; do
	echo "${GREEN}[+] Installing ${tool} ... ${NC}"
	if [[ ! $(which "$tool") ]]; then
		pip3 install --upgrade "$tool"
	fi
	echo "${GREEN}[+] Done${NC}"
done

if [[ ! -e ~/.fzf ]]; then
	echo "${GREEN}[+] Installing fzf ... ${NC}"
	git clone --depth 1 \
	https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install
	echo "${GREEN}[+] Done ${NC}"
fi

if [[ ! -e ~/.oh-my-zsh ]]; then
	echo "${GREEN}[+] Installing oh-my-zsh ... ${NC}"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	echo "${GREEN}[+] Done ${NC}"
fi

# install vim plugin manager
if [[ -e ~/.vim && ! -e ~/.vim/plugged ]]; then
	echo "${GREEN}[+] Installing vim plugin manager ... ${NC}"
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	echo "${GREEN}[+] Done ${NC}"
else
	echo "${RED}[-] You need to install Vim first!${NC}"
fi

SOURCE_STR="
[ -f ~/.bash_aliases ] && source ~/.bash_aliases
[ -f ~/.bash_functions ] && source ~/.bash_functions
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.local/bin/bashmarks ] && source ~/.local/bin/bashmarks
"

# add source files to end of rc file
[ -f ~/.zshrc ] && echo "$SOURCE_STR" >> ~/.zshrc

