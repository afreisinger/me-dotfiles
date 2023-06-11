#!/bin/bash

# Put your machine name in this file. 
# The name must match one of the subdirectories in this dir
MACHINE_NAME_FILE="$HOME/.dotfiles-machine"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd "$SCRIPT_DIR" > /dev/null

# Get some color codes
source ../common-setup/bash.d/colors

if [[ ! -e $MACHINE_NAME_FILE ]]; then
    echo -e $(dark_red "Missing name of this machine in $MACHINE_NAME_FILE") >> /dev/stderr
    echo -e $(dark_yellow "Create it like this:") "echo my-computer-name > $MACHINE_NAME_FILE"
    exit 1
fi

# Handle rename
#rm -r ubuntu-diffia || :
#ln -s $PWD/ubuntu ubuntu-diffia

MACHINE=$(cat "$MACHINE_NAME_FILE")

if [[ -e "$MACHINE" ]]; then 
    echo -e $(blue "Setting up local settings for this machine")
    cd $MACHINE
    ln -sf `pwd`/bashrc.local "$HOME/.bashrc.local"
    ln -sf `pwd`/profile.local "$HOME/.profile.local"
    ln -sf `pwd`/gitlocal "$HOME/.gitlocal"
    ln -sf `pwd`/vimrc.local "$HOME/.vimrc.local"
    [[ -e ./setup.sh ]] && ./setup.sh

    dark_yellow "You might need to re-run the global setup as build tools might not have been available"
else
    echo -e $(dark_red "Missing local settings directory: $SCRIPT_DIR/$MACHINE" >> /dev/stderr)
    exit 1
fi

popd >> /dev/null
