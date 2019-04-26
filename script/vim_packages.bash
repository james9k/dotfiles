#!/bin/bash
# vim: set ts=4 sw=4 sts=4 et:
set -u

VIM_DIR="${HOME}/.vim"
GITHUB_DIR="${HOME}/github"

# Ensure script is run from root dotfile directory 
cd "$(dirname "$0")/.." || exit 1
DOTFILES_ROOT=$(pwd)

# Source reusable bash functions
source "${DOTFILES_ROOT}"/bash/functions.bash

printf "VIM_DIR: %s\n" "${VIM_DIR}"
printf "DOTFILES_ROOT: %s\n" "${DOTFILES_ROOT}"

function clone_git_repo() {
    GIT_USER="${1}"
    REPO_NAME="${2}"
    REPO_URL="https://github.com/${GIT_USER}/${REPO_NAME}.git"


    if [ -d "${GITHUB_DIR}/${REPO_NAME}" ]; then
        pushd "${GITHUB_DIR}/${REPO_NAME}" > /dev/null || exit 1
        git pull origin master
        success "Pulled latest for ${REPO_NAME}"
        popd > /dev/null || exit 1
    else
        pushd "${GITHUB_DIR}" > /dev/null || exit 1
        git clone "${REPO_URL}"
        popd > /dev/null || exit 1
        success "Cloned ${REPO_NAME}"
    fi
}

function link_vim_ft_plugin() {
    # Link FileType plugin to load on start
    GIT_USER="${1}"
    REPO_NAME="${2}"

    START_DIR="${VIM_DIR}/pack/filetype/start"

    create_directory "${START_DIR}"

    clone_git_repo "${GIT_USER}" "${REPO_NAME}"

    if [ ! -h "${START_DIR}/${REPO_NAME}" ]; then 
        ln -s "${GITHUB_DIR}/${REPO_NAME}" "${START_DIR}/${REPO_NAME}"
        success "Linked ${GITHUB_DIR}/${REPO_NAME} to ${START_DIR}/${REPO_NAME}"
    else
        user "${START_DIR}/${REPO_NAME} already symlinked"
    fi
    printf "\n"
}

function link_vim_colour_scheme() {
    GIT_USER="${1}"
    REPO_NAME="${2}"

    OPT_DIR="${VIM_DIR}/pack/colours/opt"

    create_directory "${OPT_DIR}"

    clone_git_repo "${GIT_USER}" "${REPO_NAME}"

    if [ ! -h "${OPT_DIR}/${REPO_NAME}" ]; then 
        ln -s "${GITHUB_DIR}/${REPO_NAME}" "${OPT_DIR}/${REPO_NAME}"
        success "Linked ${GITHUB_DIR}/${REPO_NAME} to ${OPT_DIR}/${REPO_NAME}"
    else
        user "${OPT_DIR}/${REPO_NAME} already symlinked"
    fi
    printf "\n"
}

# File type plugins
link_vim_ft_plugin "gregsexton" "MatchTag"
link_vim_ft_plugin "hashivim" "vim-terraform"
link_vim_ft_plugin "martinda" "Jenkinsfile-vim-syntax"
link_vim_ft_plugin "saltstack" "salt-vim"
link_vim_ft_plugin "scrooloose" "nerdtree"
link_vim_ft_plugin "scrooloose" "syntastic"
link_vim_ft_plugin "tpope" "vim-sensible"
link_vim_ft_plugin "tpope" "vim-surround"
link_vim_ft_plugin "vim-scripts" "groovyindent-unix"
link_vim_ft_plugin "zxqfl" "tabnine-vim"

# Colour Schemes
link_vim_colour_scheme "altercation" "vim-colors-solarized"
link_vim_colour_scheme "joshdick" "onedark.vim"
link_vim_colour_scheme "drewtempelmeyer" "palenight.vim"

printf "\n"