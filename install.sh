#!/bin/sh

REQUIRED_PKG="neovim"
OS="$(uname -s)"
DIR="$HOME/.config/nvim"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

#Make sure what distro is that
case "${OS}" in
	Linux*)
		MACHINE="LINUX"
		if [ -f /etc/os-release ]; then
			. /etc/os-release
			DISTRO="$ID"
		else
			DISTRO="Unknown Linux"
		fi
		;;
	Darwin*)
		MACHINE="macOS"
		DISTRO="Darwin"
		;;
	MINGW*)
		MACHINE="MinGw"
		DISTRO="Windows"
		;;
	*)
		MACHINE="UNKNOWN"
		DISTRO="Unknown"
		;;
esac


#Make sure that nvim is installed
if [! command -v "$REQUIRED_PKG" &> /dev/null]; then
	echo "#@######################@#"
	echo "Neovim could not be found."
	echo "#@######################@#"
else
	echo "#@####################################################@#"
	echo "Neovim is installed, need to install vim-plug for Neovim"
	echo "#@####################################################@#"

	case "$MACHINE" in 
		"LINUX"|"macOS")
			sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
			;;
		"MinGw")
			powershell.exe -Command "iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | ni \"(\$num = \${env:XDG_DATA_HOME}; if(\$num){ \$num } else { \${env:LOCALAPPDATA} })/nvim-data/site/autoload/plug.vim\" -Force"
    			;;
	esac
fi

#Install init file

if [ -d "$DIR" ]; then
	echo "#@########################################@#"
	echo "$DIR is exist, copy init.lua into it"
	echo "#@########################################@#"
	cp "$SCRIPT_DIR/init.lua" "$DIR"
else
	echo "#@################################@#"
	echo "No directory for init.lua , creating $DIR"
	mkdir -p "$DIR"
	echo "Copy init.lua into $DIR"
	echo "#@################################@#"
	cp "$SCRIPT_DIR/init.lua" "$DIR"
fi 

echo "#@######################################@#"
echo "FINISH! Please, enter :PlugInstall inside of Neovim"
echo "#@######################################@#"
