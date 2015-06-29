#!/bin/sh

set -e

MAGIC_STR="__sh-tools__install_sh__"
SH_TOOLS_DIR="$HOME/.sh-tools"
GITHUB_URL="https://github.com/nicopauss/sh-tools.git"
DATE_TIME_STR=$(date "+%Y%m%d_%k%M%S")
BACKUP_DIR="$HOME/.sh-tools-bck-$DATE_TIME_STR"

e_header()   { echo "\n\033[1m$@\033[0m"; }
e_success()  { echo " \033[1;32m✔\033[0m  $@"; }

install_script()
{
    local found_str=$(grep -F "$MAGIC_STR" "$0" 2>/dev/null || echo "")

    if [ -z "$found_str" ]; then
        if [ ! -d "$SH_TOOLS_DIR" ]; then
            git clone  --recursive "$GITHUB_URL" "$SH_TOOLS_DIR"
        fi
    else
        SH_TOOLS_DIR=$(cd "$(dirname "$0")"; pwd)
    fi
}

install_vimrc()
{
    local home_vimrc="$HOME/.vimrc"
    local home_vimdir="$HOME/.vim"
    local vimrc_path="$SH_TOOLS_DIR/dotfiles/vimrc"
    local vimrc_script="source $vimrc_path"
    local found_str=''

    e_header "Installing vimrc"

    if [ ! -e "$home_vimrc" ]; then
        echo "$vimrc_script" > "$home_vimrc"
        e_success "No previous vimrc found, installed new one"
        return 0
    fi

    found_str=$(grep -F "$vimrc_script" "$home_vimrc" 2>/dev/null || echo "")

    if [ -n "$found_str" ]; then
        e_success "Vimrc already installed"
        return 0
    fi

    mkdir -p "$BACKUP_DIR"
    mv "$home_vimrc" "$BACKUP_DIR"
    echo "$vimrc_script" > "$home_vimrc"
    if [ -d "$home_vimdir" ]; then
        mv "$home_vimdir" "$BACKUP_DIR"
        e_success "Backing up vimrc and vim dir to '$BACKUP_DIR', installed new one"
    else
        e_success "Backing up vimrc to '$BACKUP_DIR', installed new one"
    fi
}

main()
{
    install_script
    install_vimrc
}

main
