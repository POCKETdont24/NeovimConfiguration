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
	echo "Neovim could not be found."
	
	case "$MACHINE" in
		"LINUX")
			case "$DISTRO" in
				arch)
					echo "#@#############################################################@#"
					echo "Installing on Arch linux, also install vim-plug for Neovim"
					echo "#@#############################################################@#"
					sudo pacman -S --noconfirm "$REQUIRED_PKG"
					sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
					;;
				postmarketos)
					echo "#@###############################################################@#"
					echo "Installing on PostMarketOS, also install vim-plug for Neovim"
					echo "#@###############################################################@#"
					sudo apk add "$REQUIRED_PKG"
					sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
					;;
				*)
					echo "#@###############################################################@#"
					echo "Unsupported Linux distribution,but you can install it on your own"
					echo "Open a new terminal and install $REQUIRED_PKG"
					read -p "Press [ENTER] once you have installed $REQUIRED_PKG to continue."
					echo "#@###############################################################@#"
					;;
				#Need to add more DISTRO
			esac
			;;
		"macOS")
			echo "#@########################################################@#"
			echo "Installing on macOS, also install vim-plug for Neovim"
			echo "#@########################################################@#"
			brew install "$REQUIRED_PKG"
			sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
			;;
		"MinGw")
			echo "#@##########################################################@#"
			echo "Installing on Windows, also install vim-plug for Neovim"
			echo "#@##########################################################@#"
			winget install "$REQUIRED_PKG"
			powershell.exe -Command "iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | ni \"(\$num = \${env:XDG_DATA_HOME}; if(\$num){ \$num } else { \${env:LOCALAPPDATA} })/nvim-data/site/autoload/plug.vim\" -Force"
			;;
		*)
			echo "#@###################@#"
			echo "Unsupported on $MACHINE"
			echo "#@###################@#"
			;;
	esac
else
	echo "#@##################################################################@#"
	echo "Neovim is installed, need to install vim-plug for Neovim"
	echo "#@##################################################################@#"

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
