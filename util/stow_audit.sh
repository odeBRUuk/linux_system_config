#!/bin/bash
# This script was written to allow a shorthand to audit `stow`. Sometimes, I 
# may want to see what will happen when `stow` runs; this script will do that.
# RJO - 09/05/2025

# A reminder to install `stow` if it doesn't exist already.
if [[ "$(command -v stow)" == "" ]]; then
    echo "'stow' is not a valid command in this system. Aborting..."
    exit 1
fi

stow --verbose --simulate --dotfiles "linux_system_config"

exit
