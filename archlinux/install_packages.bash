#!/bin/bash
# vim: set ts=4 sw=4 sts=4 et:
# Run this script as root

# See case statement for profile options
DOTFILE_PROFILE="${DOTFILE_PROFILE:-default}"

set -u

cd "$(dirname "$0")/.." || exit 1
DOTFILES_ROOT=$(pwd)
# Source reusable bash functions
source "${DOTFILES_ROOT}"/bash/functions.bash

MY_DEFAULTS=$(cat <<MDEOF
aws-cli
bat
bash-completion
bind-tools
broot
exa
fzf
git
gnu-netcat
grml-zsh-config
htop
jq
neovim
net-tools
nmap
pkgfile
ranger
ripgrep
shellcheck
sipcalc
the_silver_searcher
tig
tree
wget
zsh
zsh-completions
MDEOF
)
WORKSTATION=$(cat <<WSEOF
adobe-source-code-pro-fonts
alacritty
alacritty-terminfo
clementine
dbeaver
flake8
gvim
ipython
neovim-qt
pycharm-community-edition
python
python-docs
python-ipdb
python-jedi
python-neovim
python-pipenv
python-virtualenv
python-virtualenvwrapper
speedcrunch
terminator
termite
termite-terminfo
terraform
ttf-bitstream-vera
ttf-dejavu
ttf-fira-code
ttf-freefont
ttf-hack
ttf-liberation"
vim-jedi
WSEOF
)
GNOME="gdm gnome gnome-shell gnome-terminal gnome-system-monitor gnome-tweaks"
I3="i3-wm i3lock i3status gsimplecal dmenu"
KDE="kmix plasma-desktop plasma-nm powerdevil sddm"
LAPTOP="acpilight tlp"
SERVER="vim"
SWAY="bemenu grim i3status sway swayidle swaylock waybar wl-clipboard wlroots"
XORG="xorg-server"

function install_pkgs() {
    echo "********************************************************************"
    echo "$1: "
    echo "********************************************************************"
    sudo pacman --noconfirm --needed -S ${2}
}

sudo pacman --noconfirm -Sy

case "${DOTFILE_PROFILE}" in
    gnome)
        install_pkgs "WORKSTATION" "${WORKSTATION}"
        install_pkgs "GNOME" "${GNOME}"
        install_pkgs "XORG" "${XORG}"
        ;;
    server)
        install_pkgs "SERVER" "${SERVER}"
        ;;
    i3)
        install_pkgs "WORKSTATION" "${WORKSTATION}"
        install_pkgs "I3" "${I3}"
        install_pkgs "XORG" "${XORG}"
        ;;
    kde)
        install_pkgs "WORKSTATION" "${WORKSTATION}"
        install_pkgs "KDE" "${KDE}"
        install_pkgs "XORG" "${XORG}"
        ;;
    sway)
        install_pkgs "WORKSTATION" "${WORKSTATION}"
        install_pkgs "Sway" "${SWAY}"
        ;;
    laptop)
        install_pkgs "Laptop" "${LAPTOP}"
        ;;
    *)
        printf "Profile not specified, going with defaults.\n"
        ;;
esac

# Default stuff to install
install_pkgs "My default pkgs" "$(for pkg in ${MY_DEFAULTS}; do printf "%s " "${pkg}"; done)"
