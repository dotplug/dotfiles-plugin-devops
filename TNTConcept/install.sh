#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

DOTFILES_TNT_USERNAME=${DOTFILES_TNT_USERNAME:-}
DOTFILES_TNT_PASSWORD=${DOTFILES_TNT_PASSWORD:-}

setup_netrc () {
    local netrc_filepath=$HOME/.netrc
    local netrc_path_template=$DOTFILES_ROOT/plugins/dotfiles-plugin-devops/TNTConcept/netrc.template

    blue "[TNT Concept] Check if $netrc_filepath exist"

    if ! [ -f $netrc_filepath ]
    then
        blue '[TNT Concept] setup netrc'

        blue '[TNT Concept] What is your TNT username?'
        if [[ -z $DOTFILES_TNT_USERNAME ]]; then
          read -e tnt_username
        else
          tnt_username=$DOTFILES_TNT_USERNAME
        fi
        blue '[TNT Concept] What is your TNT password?'
        if [[ -z $DOTFILES_TNT_PASSWORD ]]; then
          read -e tnt_password
        else
          tnt_password=$DOTFILES_TNT_PASSWORD
        fi

        blue "[TNT Concept] Replace values from the template to the original netrc"
        sed -e "s/USERNAME/$tnt_username/g" -e "s/PASSWORD/$tnt_password/g" $netrc_path_template > $netrc_filepath

        green '[TNT Concept] netrc applied'
    else
        blue '[TNT Concept] netrc already exists'
    fi
}


setup_pipconf () {
    local pipconf_path_template=$DOTFILES_ROOT/plugins/dotfiles-plugin-devops/TNTConcept/pip.conf.template
    blue "[TNT Concept] Ensure pip configuration folder is created"
    mkdir -p $HOME/.config/pip
    blue "Copy pip configuration"
    cp $pipconf_path_template $HOME/.config/pip/pip.conf
}

setup_netrc
setup_pipconf

blue "[TNT Concept] Check that at least python 3.7 is installed"
python3 --version

blue "[TNT Concept] Check that pip3 is installed:"
pip3 --version

blue "[TNT Concept] Show PIP configuration is properly set"
python3 -m pip config list

blue "[TNT Concept] Install TNTGitHook in the system"
python3 -m pip install --upgrade TNTGitHook --user

blue "[TNT Concept] Setup credentials"
python3 -m TNTGitHook --set-credentials

