#!/bin/bash
# vim: set ts=4 sw=4 sts=4 et:

XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
GITHUB_DIR="${HOME}/github"

set -u

# Ensure script is run from root dotfile directory 
pushd "$(dirname "$0")/.." || exit 1
DOTFILES_ROOT=$(pwd)

# Source reusable bash functions
source "${DOTFILES_ROOT}"/bash/functions.bash

printf "XDG_DATA_HOME: %s\n" "${XDG_DATA_HOME}"
printf "DOTFILES_ROOT: %s\n" "${DOTFILES_ROOT}"

function create_directory() {
    ABS_PATH="${1}"

    if [ -e "${ABS_PATH}" ]; then
        user "${ABS_PATH} exists"
    else
        mkdir -p "${ABS_PATH}"
        success "Created ${ABS_PATH}"
    fi
}

function clone_git_repo() {
    GIT_USER="${1}"
    REPO_NAME="${2}"
    REPO_URL="https://github.com/${GIT_USER}/${REPO_NAME}.git"


    if [ -d "${GITHUB_DIR}/${REPO_NAME}" ]; then
        pushd "${GITHUB_DIR}/${REPO_NAME}" || exit 1
        git pull origin master
        success "Pulled latest for ${REPO_NAME}"
        popd || exit 1
    else
        pushd "${GITHUB_DIR}" || exit 1
        git clone "${REPO_URL}"
        popd || exit 1
        success "Cloned ${REPO_NAME}"
    fi
}

function link_neovim_plugin() {
    # $XDG_DATA_HOME/nvim/site/pack/altercation/start
    APP="nvim"
    GIT_USER="${1}"
    REPO_NAME="${2}"

    APP_START_DIR="${XDG_DATA_HOME}/${APP}/site/pack/filetype/start"

    create_directory "${APP_START_DIR}"

    clone_git_repo "${GIT_USER}" "${REPO_NAME}"

    if [ ! -h "${APP_START_DIR}/${REPO_NAME}" ]; then 
        ln -s "${GITHUB_DIR}/${REPO_NAME}" "${APP_START_DIR}/${REPO_NAME}"
        success "Linked ${GITHUB_DIR}/${REPO_NAME} to ${APP_START_DIR}/${REPO_NAME}"
    else
        user "${APP_START_DIR}/${REPO_NAME} already symlinked"
    fi
    printf "\n"
}

function link_neovim_colour_scheme() {
    APP="nvim"
    GIT_USER="${1}"
    REPO_NAME="${2}"

    COLOUR_SCHEME_DIR="${XDG_DATA_HOME}/${APP}/site/pack/colours/opt"

    create_directory "${COLOUR_SCHEME_DIR}"

    clone_git_repo "${GIT_USER}" "${REPO_NAME}"

    if [ ! -h "${COLOUR_SCHEME_DIR}/${REPO_NAME}" ]; then 
        ln -s "${GITHUB_DIR}/${REPO_NAME}" "${COLOUR_SCHEME_DIR}/${REPO_NAME}"
        success "Linked ${GITHUB_DIR}/${REPO_NAME} to ${COLOUR_SCHEME_DIR}/${REPO_NAME}"
    else
        user "${COLOUR_SCHEME_DIR}/${REPO_NAME} already symlinked"
    fi
    printf "\n"
}

# File type plugins
link_neovim_plugin "gregsexton" "MatchTag"
link_neovim_plugin "hashivim" "vim-terraform"
link_neovim_plugin "martinda" "Jenkinsfile-vim-syntax"
link_neovim_plugin "saltstack" "salt-vim"
link_neovim_plugin "scrooloose" "nerdtree"
link_neovim_plugin "scrooloose" "syntastic"
link_neovim_plugin "tpope" "vim-sensible"
link_neovim_plugin "tpope" "vim-surround"
link_neovim_plugin "vim-scripts" "groovyindent-unix"
link_neovim_plugin "zxqfl" "tabnine-vim"

# Colour Schemes
link_neovim_colour_scheme "joshdick" "onedark.vim"
link_neovim_colour_scheme "drewtempelmeyer" "palenight.vim"

printf "\n"
