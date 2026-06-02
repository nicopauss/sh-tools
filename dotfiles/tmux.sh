#!/bin/bash

set -eu

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMUX_CONF_DIR="$DIR/tmux"

main() {
    tmux source-file "$TMUX_CONF_DIR/tmux-global.conf"
    source "$TMUX_CONF_DIR/tmux-resurrect/resurrect.tmux"
}

main
