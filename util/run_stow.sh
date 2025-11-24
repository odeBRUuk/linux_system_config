#!/bin/bash
# This script was written to launch the `stow` command. It contains safeguards
# to avoid running the command if it doesn't exist. I also will probably forget
# the syntax, since I wont be running it often, so I figured I'd just write a 
# script.

if [[ "$(command -v stow)" == "" ]]; then
    echo "The 'stow' command does not exist on this system. Aborting..."
    exit 1
fi

stow --dotfiles --verbose linux_system_config

exit
