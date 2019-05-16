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

CLI_UTILS=$(cat <<EOF
aws-cli
bat
bind-tools
exa
fzf
git
gnu-netcat
htop
jq
keychain
kubectl
net-tools
nmap
pkgfile
ranger
ripgrep
sipcalc
terraform
the_silver_searcher
tig
tree
wget
EOF
)
DATABASE="dbeaver"
EDITOR="gvim neovim neovim-qt python-neovim vim-jedi"
FONTS="adobe-source-code-pro-fonts ttf-bitstream-vera ttf-dejavu ttf-fira-code ttf-freefont ttf-hack ttf-liberation"
GNOME="gdm gnome gnome-shell gnome-terminal gnome-system-monitor gnome-tweaks"
GUI_APPS="clementine speedcrunch"
I3="i3-wm i3lock i3status gsimplecal dmenu"
KDE="kmix plasma-desktop plasma-nm powerdevil sddm"
LAPTOP="acpilight tlp"
PYTHON=$(cat <<EOF
pycharm-community-edition
flake8
ipython
python
python-docs
python-ipdb
python-jedi
python-pipenv
python-virtualenv
python-virtualenvwrapper
EOF
)
SHELL_PKGS="bash-completion grml-zsh-config zsh zsh-completions shellcheck"
TERMINAL="alacritty alacritty-terminfo terminator termite termite-terminfo"
SWAY="bemenu grim i3status sway swayidle swaylock waybar wl-clipboard wlroots"
XORG="xorg-server"

function install_pkgs() {
    echo "********************************************************************"
    echo "$1: "
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
        install_pkgs "GUI Apps" "${GUI_APPS}"
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
        install_pkgs "GUI Apps" "${GUI_APPS}"
        ;;
    kde)
        install_pkgs "KDE" "${KDE}"
        install_pkgs "FONTS" "${FONTS}"
        install_pkgs "Terminal" "${TERMINAL}"
        install_pkgs "Database" "${DATABASE}"
        install_pkgs "GUI Apps" "${GUI_APPS}"
        ;;
    sway)
        install_pkgs "Sway" "${SWAY}"
        install_pkgs "FONTS" "${FONTS}"
        install_pkgs "Terminal" "${TERMINAL}"
        install_pkgs "Database" "${DATABASE}"
        install_pkgs "GUI Apps" "${GUI_APPS}"
        ;;
    laptop)
        install_pkgs "Laptop" "${LAPTOP}"
        ;;
esac

# Default stuff to install
install_pkgs "Shell" "${SHELL_PKGS}"
install_pkgs "Editor" "${EDITOR}"
install_pkgs "Python" "$(for pkg in ${PYTHON}; do printf "%s " "${pkg}"; done)"
install_pkgs "CLI Utils" "$(for pkg in ${CLI_UTILS}; do printf "%s " "${pkg}"; done)"
