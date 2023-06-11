#!/bin/bash

# exit on errors
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd "$SCRIPT_DIR" > /dev/null


# Get some color codes
source ../../common-setup/bash.d/colors

# Get common aliases (if new shell)
shopt -s expand_aliases     # to use alias definitions
source ../../common-setup/bash.d/bash_aliases_functions

sudo chown $USER /opt

# Homebrew
if ! which -s brew; then
    printf "Installing Homebrew\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"

    brew update
fi

# Install local apps using HomeBrew
InstallLocalApps

# CMake
if ! which -s cmake; then
    brew install cmake
    dark_red "CMake was not installed earlier. Re-start the top level setup"
    exit 1
fi

if ! which -s java; then
    blue "Installing Java\n"
    # TODO: replace with SDKMAN, sdk install java open-jdk-16
fi

# Node Version Manager
if ! which -s n; then
    blue "Installing n (Node version manager) ..."
    npm install -g n
    n latest
    green "Finished.\n"
fi


#cp ./imgcat.sh ~/bin/imgcat

#oh-my-zsh install
ohmyzshInstall

#powerlevel install
pl10kInstall
#[[ ! -e "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]] && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME"/.oh-my-zsh/custom/themes/powerlevel10k

#personal .zshrc
echo "comomomomom"
echo $COMMON_SETUP
ln -sf "${COMMON_SETUP}"/zsh/zshrc "$HOME"/.zshrc











<< 'COMMENT'
if [[ ! -d /opt/google-cloud-sdk ]]; then
    blue "Installing Google Cloud SDK ...\n"

    if [[ "$(uname -m)" == arm64 ]]; then
        GSDK=google-cloud-sdk-355.0.0-darwin-arm.tar.gz
    fi

    if [[ -n $GSD ]]; then
        pushd /tmp
        curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/"$GSDK" 
        tar xzf $GSDK -C /opt
        /opt/google-cloud-sdk/install.sh
        green "Cloud SDK setup finished.\n"
    else
        dark_red "No Cloud SDK configured for architecture $(uname -m)"
    fi
fi
COMMENT