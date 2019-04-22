#!/bin/bash
# vim: set ts=4 sw=4 sts=4 et:
# Run this script as root
set -u

# Other profile options: gnome headless i3 kde sway
: "${PROFILE}"

cd "$(dirname "$0")/.." || exit 1
DOTFILES_ROOT=$(pwd)
# Source reusable bash functions
source "${DOTFILES_ROOT}"/bash/functions.bash

CLI_UTILS="aws-cli bat bind-tools exa fzf gnu-netcat htop jq keychain net-tools nmap pkgfile ranger ripgrep terraform the_silver_searcher tig tree wget"
GNOME="gdm gnome gnome-shell gnome-terminal gnome-system-monitor gnome-tweaks"
I3="i3-wm i3lock i3status gsimplecal dmenu"
KDE="kmix plasma-desktop plasma-nm powerdevil sddm"
DATABASE="dbeaver"
EDITOR="gvim neovim neovim-qt python-neovim vim-jedi"
FONTS="adobe-source-code-pro-fonts ttf-bitstream-vera ttf-dejavu ttf-freefont ttf-hack ttf-liberation"
GUI_APPS="clementine speedcrunch"
PYTHON="pycharm-community-edition flake8 ipython python python-docs python-ipdb python-jedi python-pipenv python-virtualenv python-virtualenvwrapper"
SHELL_PKGS="bash-completion grml-zsh-config zsh zsh-completions shellcheck"
TERMINAL="alacritty alacritty-terminfo terminator termite termite-terminfo"
SWAY="grim i3status sway swayidle swaylock waybar wl-clipboard wlroots" 
XORG="xorg-server"

function install_pkgs() {
    echo "********************************************************************"
    echo "$1" Pacakges
    echo "********************************************************************"
    echo "$2"
    echo "********************************************************************"
    sudo pacman --noconfirm --needed -S ${2}
}

sudo pacman --noconfirm -Sy

case "${PROFILE}" in
    gnome)
        install_pkgs "GNOME" "${GNOME}"
        install_pkgs "FONTS" "${FONTS}"
        install_pkgs "Terminal""${TERMINAL}"
        install_pkgs "Database""${DATABASE}"
        ;;
    headless)
        printf "\n"
        ;;
    i3)
        install_pkgs "I3" "${I3}"
        install_pkgs "XORG" "${XORG}"
        install_pkgs "FONTS" "${FONTS}"
        install_pkgs "Terminal" "${TERMINAL}"
        install_pkgs "Database" "${DATABASE}"
        ;;
    kde)
        install_pkgs "KDE" "${KDE}"
        install_pkgs "FONTS" "${FONTS}"
        install_pkgs "Terminal" "${TERMINAL}"
        install_pkgs "Database" "${DATABASE}"
        ;;
    sway)
        install_pkgs "Sway" "${SWAY}"
        install_pkgs "FONTS" "${FONTS}"
        install_pkgs "Terminal" "${TERMINAL}"
        install_pkgs "Database" "${DATABASE}"
        ;;
esac

# Default stuff to install
install_pkgs "Shell" "${SHELL_PKGS}"
install_pkgs "Editor" "${EDITOR}"
install_pkgs "Python" "${PYTHON}"
install_pkgs "CLI Utils" "${CLI_UTILS}"
install_pkgs "GUI Apps" "${GUI_APPS}"
