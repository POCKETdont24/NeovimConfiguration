#!/bin/sh

#Variables 
REQUIRED_PKG="neovim"
DIR="$HOME/.config/nvim"
OS="$(uname -s)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#Style
BOLD="\e[1m"
GREEN="\e[32m"
CYAN="\e[36m"
RESET="\e[0m"

#Check for sudo run
if [ "$EUID" -ne 0 ]; then
    echo -e "${BOLD} ${CYAN} Please run this script with sudo. ${RESET}"
    exit 1
fi 

#Make sure that nvim is installed
if [! command -v "$REQUIRED_PKG" &> /dev/null]; then
	echo -e "${BOLD} ${CYAN} Neovim could not be found. ${RESET}"
	echo -e "${BOLD} ${CYAN} For Linux/macOS user recommended to use your favorite package manager ${RESET}"
	echo -e "${BOLD} ${CYAN} something like sudo pacman -S neovim ${RESET}"
	exit 1
else
	echo -e "${BOLD} ${CYAN} Neovim is installed, need to install vim-plug for Neovim ${RESET}"
	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi

#Install init file
if [ -d "$DIR" ]; then
	echo -e "${BOLD} ${CYAN} $DIR is exist, copy init.lua into it ${RESET}"
	cp "$SCRIPT_DIR/init.lua" "$DIR"
else
	echo -e "${BOLD} ${CYAN} No directory for init.lua , creating $DIR ${RESET}"
	mkdir -p "$DIR"
	echo -e "${BOLD} ${CYAN} Copy init.lua into $DIR ${RESET}"
	cp "$SCRIPT_DIR/init.lua" "$DIR"
fi 

echo -e "${BOLD} ${GREEN} FINISH! Please, enter :PlugInstall inside of Neovim ${RESET}"
