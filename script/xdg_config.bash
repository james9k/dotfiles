#!/bin/bash
# vim: set ts=4 sw=4 sts=4 et:

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"

set -u

# Ensure script is run from root dotfile directory 
pushd "$(dirname "$0")/.." || exit 1
DOTFILES_ROOT=$(pwd)

# Source reusable bash functions
source "${DOTFILES_ROOT}"/bash/functions.bash

printf "XDG_CONFIG_HOME: %s\n" "${XDG_CONFIG_HOME}"
printf "DOTFILES_ROOT: %s\n" "${DOTFILES_ROOT}"

for xdg_config_dir in xdg_dirs/config/*
do
    echo "xdg_config_dir: ${xdg_config_dir}"
    config_name=$(basename "${xdg_config_dir}")
    printf "config_name: %s\n" "${config_name}"

    if [ -e "${XDG_CONFIG_HOME}/${config_name}" ]; then
        user "${XDG_CONFIG_HOME}/${config_name} exists"
    else
        ln -s "${DOTFILES_ROOT}/${xdg_config_dir}" "${XDG_CONFIG_HOME}/${config_name}"
        success "Linked ${DOTFILES_ROOT}/${xdg_config_dir} to ${XDG_CONFIG_HOME}/${config_name}"
    fi
    printf "\n"
done
