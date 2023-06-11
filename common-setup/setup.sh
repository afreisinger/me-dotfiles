#!/bin/bash
# Run to setup with ./setup.sh
BASH_DIR="${HOME}/.bash.d"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

set -e #exit on error

# read local environment variables, like auth tokens
if [ -e "${HOME}/.secret" ]; then
  source "${HOME}/.secret"
  success "read local environment variables, like auth tokens"
fi

pushd "$SCRIPT_DIR" > /dev/null

source "$SCRIPT_DIR/bash.d/colors"


if [ ! -e "$BASH_DIR" ]; then
  dark_red "$BASH_DIR not found"
  mkdir "${BASH_DIR}"
  success "$BASH_DIR add" 
fi

if [ ! -e "$HOME/bin" ]; then
  mkdir "${HOME}/bin"
fi

rm -rf "$HOME"/.bash_completion.d 2>/dev/null

success "bash dir $BASH_DIR"
success "script dir $SCRIPT_DIR"

configureGitCompletion () {
    GIT_VERSION=`git --version | awk '{print $3}'`
    URL="https://raw.github.com/git/git/v$GIT_VERSION/contrib/completion/git-completion.bash"
    success "git-completion for $GIT_VERSION downloaded"
    if ! curl "$URL" --silent --location --output "$SCRIPT_DIR/bash_completion.d/git-completion.bash"; then
        dark_red "ERROR: Couldn't download completion script. Make sure you have a working internet connection." && exit 1
        fail 'git completion download failed'
    fi
}; configureGitCompletion


if [ -e "$HOME/.bash_profile" ]; then
    success "We don't use .bash_profile to avoid trouble. Renaming to .bash_profile.bak"
    mv ~/.bash_profile{,.bak}
fi


success "symbolic links added"
ln -sf "$SCRIPT_DIR"/profile "$HOME"/.profile
ln -sf "$SCRIPT_DIR"/bashrc "$HOME"/.bashrc
ln -sf "$SCRIPT_DIR"/gitconfig "$HOME"/.gitconfig
ln -sf "$SCRIPT_DIR"/gitignore_global "$HOME"/.gitignore_global
ln -sf "$SCRIPT_DIR"/pystartup "$HOME"/.pystartup
ln -sf "$SCRIPT_DIR"/tmux.conf "$HOME"/.tmux.conf
#ln -sf "$SCRIPT_DIR"/zsh/zshrc "$HOME"/.zshrc
ln -sf "$SCRIPT_DIR"/pl10k/p10k.zsh "$HOME"/.p10k.zsh
ln -sf  "$SCRIPT_DIR"/bash_completion.d "$HOME"/.bash_completion.d 

for file in "$SCRIPT_DIR"/bash.d/*; do
  ln -sf "$file" "${BASH_DIR}"/
done

<< 'COMMENT'
if [ -e "$HOME/.zshrc" ]; then
    echo "We don't use .zshrc to avoid trouble. Renaming to .zshrc.bak"
    mv ~/.zshrc{,.bak}
fi
COMMENT

# create needed dirs
[[ ! -e "$HOME/.tmux" ]] && mkdir "$HOME/.tmux";
[[ ! -e "$HOME/.tmux/plugins" ]] && mkdir "$HOME/.tmux/plugins";
[[ ! -e "$HOME/.tmux/plugins/tpm" ]] && git clone https://github.com/tmux-plugins/tpm "$HOME"/.tmux/plugins/tpm 

# copy tmux project settings
for file in "$SCRIPT_DIR"/tmux/*; do
  ln -sf "$file" "${HOME}/.tmux/"
done

<< 'COMMENT'
# Remove any existing symlink (or dir on mingw) - will fail if it is a dir
rm -rf "$HOME"/.vim 2>/dev/null
if [ ! -e "$HOME"/.vim ]; then  
    ln -sf "$SCRIPT_DIR"/vim/dotvim "$HOME"/.vim
fi

ln -sf "$SCRIPT_DIR"/vim/vimrc "$HOME"/.vimrc

# Checks out the Vundle submodule
git submodule update --init --recursive

echo  -n -e $(blue "Installing all VIM plugins")
echo -e $(dark_grey "(might take some time the first time ... )")
vim +PlugInstall +qall

# Vim Fugitive setup
vim -u NONE -c "helptags vim-fugitive/doc" -c q

# Needed for Typescript support in CoC and YCM using tsserver
ts_cmd='npm install -g typescript'
if which npm > /dev/null 2>&1 ; then
    which tsc > /dev/null 2>&1 || bash -c "$ts_cmd"
else
    echo "Install NodeJS and run '$ts_cmd' to get TypeScript support in Vim"
fi

touch "$HOME"/.vimrc.local

# Install NeoVim config (we don't have to worry about XDG_CONFIG_HOME stuff
[[ ! -e "$HOME"/.config ]] && mkdir "$HOME/.config"
rm -rf ~/.config/nvim 
ln -sf ~/.vim ~/.config/nvim
ln -sf ~/.vimrc ~/.config/nvim/init.vim

# Install a better matcher for Ctrl-P
if ! hash matcher; then 
    if ! hash make 2>/dev/null; then 
        printf "$(dark_red make is not installed. Rerun the setup after the per-machine setup completes)\n\n" 
    else
        (cd matcher
        make 
        make install PREFIX=$HOME
        cd ..) > /dev/null
    fi
fi

# Make a config file for ngrok, passing in the secret auth token
[[ ! -e "$HOME"/.ngrok2 ]] && mkdir "$HOME/.ngrok2"
NGROK_YML="$HOME/.ngrok2/ngrok.yml"
rm "$NGROK_YML" 2> /dev/null || :;
cat > "$NGROK_YML" << EOF
###############################################################
## WARNING: this file is auto-generated. See dotfiles repo   ##
###############################################################
authtoken: ${NGROK_AUTHTOKEN:-'fill-NGROK_AUTHTOKEN-in-in-~/.secret'} 

EOF
cat $SCRIPT_DIR/ngrok.yml >> "$NGROK_YML"

# Postgres config
ln -sf "$SCRIPT_DIR"/psqlrc $HOME/.psqlrc

# Download to latest to home dir
printf "$(blue "Fetching rupa/z (Jump Around)")\n"
curl -s https://raw.githubusercontent.com/rupa/z/master/z.sh -o ~/bin/z.sh
COMMENT

printf "$(blue "Finished common setup")\n\n"
popd > /dev/null
