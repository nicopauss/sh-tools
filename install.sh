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

    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

install_tmux()
{
    local home_tmuxconf="$HOME/.tmux.conf"
    local tmuxconf_path="$SH_TOOLS_DIR/dotfiles/tmux.conf"
    local tmuxconf_script="source-file $tmuxconf_path"
    local found_str=''

    e_header "Installing tmux"

    if [ ! -e "$home_tmuxconf" ]; then
        echo "$tmuxconf_script" > "$home_tmuxconf"
        e_success "No previous tmux found, installed new one"
        return 0
    fi

    found_str=$(grep -F "$tmuxconf_script" "$home_tmuxconf" 2>/dev/null || echo "")

    if [ -n "$found_str" ]; then
        e_success "Tmux already installed"
        return 0
    fi

    mkdir -p "$BACKUP_DIR"
    mv "$home_tmuxconf" "$BACKUP_DIR"
    echo "$tmuxconf_script" > "$home_tmuxconf"
    e_success "Backing up tmux to '$BACKUP_DIR', installed new one"
}

install_bashrc()
{
    local home_bashrc="$HOME/.bashrc"
    local bashrc_path="$SH_TOOLS_DIR/dotfiles/bashrc"
    local bashrc_script=". $bashrc_path"
    local found_str=''

    e_header "Installing bashrc"

    found_str=$(grep -F "$bashrc_script" "$home_bashrc" 2>/dev/null || echo "")

    if [ -n "$found_str" ]; then
        e_success "Bashrc already installed"
        return 0
    fi

    echo "$bashrc_script" >> "$home_bashrc"
    e_success "Installed new bashrc"
}

install_path_scripts()
{
    local home_bashrc="$HOME/.bashrc"
    local scripts_path="$SH_TOOLS_DIR/scripts"
    local scripts_script="export PATH=\"$scripts_path:\$PATH\""
    local found_str=''

    e_header "Installing scripts"

    found_str=$(grep -F "$scripts_script" "$home_bashrc" 2>/dev/null || echo "")

    if [ -n "$found_str" ]; then
        e_success "Scripts already installed"
        return 0
    fi

    echo "$scripts_script" >> "$home_bashrc"
    e_success "Installed new scripts"
}

install_gitconfig()
{
    local home_gitconfig="$HOME/.gitconfig"
    local gitconfig_path="$SH_TOOLS_DIR/dotfiles/gitconfig"
    local gitconfig_script="    path = $gitconfig_path"
    local found_str=''

    e_header "Installing gitconfig"

    found_str=$(grep -F "$gitconfig_script" "$home_gitconfig" 2>/dev/null || echo "")

    if [ -n "$found_str" ]; then
        e_success "Gitconfig already installed"
        return 0
    fi

    echo "[include]" >> "$home_gitconfig"
    echo "$gitconfig_script" >> "$home_gitconfig"
    e_success "Installed new gitconfig"
}

main()
{
    install_script
    install_vimrc
    install_tmux
    install_bashrc
    install_path_scripts
    install_gitconfig
}

main
