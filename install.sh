#!/bin/sh

REQUIRED_PKG="neovim"
OS="$(uname -s)"
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
			DIR="$HOME/.config/nvim"
		else
			DISTRO="Unknown Linux"
			DIR="$HOME/.config/nvim"
		fi
		;;
	Darwin*)
		MACHINE="macOS"
		DISTRO="Darwin"
		DIR="$HOME/.config/nvim"
		;;
	MINGW*)
		MACHINE="MinGw"
		DISTRO="Windows"
		DIR="/c/Users/$USER/AppData/Local/nvim"
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
	echo "For Linux/macOS user recommended to use your favorite package manager"
	echo "something like sudo pacman -S neovim"
	echo " "
	echo "For Windows user recommended to use winget, or google, i dunno"
	echo "like winget install neovim"
	echo "#@######################@#"
	exit 1
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
	case "$MACHINE" in 
		"LINUX"|"macOS")
				echo "#@########################################@#"
				echo "$DIR is exist, copy init.lua into it"
				echo "#@########################################@#"
				cp "$SCRIPT_DIR/init.lua" "$DIR"
				;;
			"MinGw" | *)
				echo "#@########################################@#"
				echo "$DIR is exist, copy init.lua into it"
				echo "#@########################################@#"
				cp "$SCRIPT_DIR/init.lua" "$DIR" 
				;;
	esac
else
	case "$MACHINE" in 
		"LINUX"|"macOS")
				echo "#@################################@#"
				echo "No directory for init.lua , creating $DIR"
				mkdir -p "$DIR"
				echo "Copy init.lua into $DIR"
				echo "#@################################@#"
				cp "$SCRIPT_DIR/init.lua" "$DIR"
				;;
			"MinGw"| *)
				echo "#@################################@#"
				echo "No directory for init.lua , creating $DIR"
				mkdir -p "$DIR"
				echo "Copy init.lua into $DIR"
				echo "#@################################@#"
				cp "$SCRIPT_DIR/init.lua" "$DIR"
				;;
			esac
fi 

echo "#@######################################@#"
echo "FINISH! Please, enter :PlugInstall inside of Neovim"
echo "#@######################################@#"
